// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:grpc/grpc.dart';
import 'package:app/proto/pg.pbgrpc.dart';
import 'package:cbor/cbor.dart';

/// ProntoGUI Communication with a single server.
///
/// An instance of this class handles communication with a single server.  To use this,
/// first create an instance and supply a callback (onUpdate) that handles CBOR updates
/// when they arrive from the server.  Next, call the open() method with an IP address and
/// port of the server.  The streaming communication will start with the server.  If the server
/// is down then PGComm will retry until a connection is established.  PGComm also sends
/// an empty "check-in" update to the server to make sure communication is still working.
/// If this check-in fails, then PGComm will keep trying until communication is up again.
///
/// You can call open() any time to specify a different server to connect with.
class PGComm extends ChangeNotifier {
  /// The user-supplied callback for handling the updates coming from the server.
  late Function _onUpdate;

  /// The amount of time (in seconds) between server check-ins.
  late int _serverCheckinPeriod;

  /// The amount of time (in seconds) between attempts to re-establish streaming after
  /// it is paused.
  late int _reestablishmentPeriod;

  /// The server address that was opened.
  String _serverAddress = "";

  /// The server port that was opened.
  int _serverPort = 0;

  /// The HTTP/2 channel in use
  ClientChannel? _channel;

  /// A client object for talking with PGService.  This object is generated
  /// by gRPC/Protobuf tools.
  PGServiceClient? _stub;

  /// A completer syrnonization object for sending a response back to the server.
  late Completer _completer;

  /// The response to send back to the server.
  late PGUpdate _response;

  /// The ongoing, active call for streaming updates to/from the server.
  ResponseStream<PGUpdate>? _call;

  /// A periodic timer that calls a routine for checking in with the server.
  Timer? _serverCheckinTimer;

  /// True means PGComm is active in working with a server.  False means the
  /// open() method call failed in some way to initialize communication with
  /// the server.
  bool _active = false;

  /// True means the server is invalid or unreachable, given the provided server
  /// address and port in the open() method call.
  bool _invalidServer = false;

  /// The number of seconds remaining until PGComm attempts to reestablish streaming
  /// with the server.
  int _reestablishmentCountdown = 0;

  /// A periodic timer (every second) for checking when to try reestablishing streaming wtih the server.
  Timer? _reestablishmentTimer;

  /// True means PGComm is paused in working with a server, which may be down or
  /// unavailable at the moment.  If this is False and _active is True, then it can
  /// be assumed that streaming is working.
  bool _paused = false;

  /// Construct an object for streaming updates back/forth with a server.
  ///
  /// This takes a callback function [onUpdate] for handling CBOR updates coming from
  /// the server.  This callback function takes a single argument as CborValue.
  /// For example:  void onUpdate(CborValue cborUpdate) {}
  ///
  /// You can provide an optional time period [serverCheckinPeriod] expressed in seconds
  /// for how often to check communication with the server.  There is another optional
  /// time period [reestablishmentPeriod] expressed in seconds for how often to try
  /// reestablishing streaming with the server during a paused state.
  PGComm(Function onUpdate,
      {int serverCheckinPeriod = 60, int reestablishmentPeriod = 30}) {
    _onUpdate = onUpdate;
    _serverCheckinPeriod = serverCheckinPeriod;
    _reestablishmentPeriod = reestablishmentPeriod;
  }

  /// Opens a session for streaming updates back/forth with a server.
  ///
  /// [serverAddress] is the address of the server.  Likewise, [serverPort]
  /// is the server port to connect through.
  void open(String serverAddress, int serverPort) {
    // Active session already?
    if (_active) {
      _cleanupResources();
    }

    _serverAddress = serverAddress;
    _serverPort = serverPort;
    _invalidServer = false;

    try {
      // Open an HTTP/2 channel
      _channel = ClientChannel(
        InternetAddress(serverAddress),
        port: serverPort,
        options: ChannelOptions(
          credentials: const ChannelCredentials.insecure(),
          codecRegistry:
              CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
        ),
      );

      // Create a client object for talking with PGService
      _stub = PGServiceClient(_channel!);
    } catch (err) {
      _invalidServer = true;
      _cleanupResources();
      return;
    }

    // Create a Completer to signal when there is an update to send
    _completer = Completer();

    // Initialize with an empty update
    _response = PGUpdate();

    // Set a timer to perform a periodic check for connectivity to server
    _serverCheckinTimer = Timer.periodic(
        Duration(seconds: _serverCheckinPeriod), _periodicServerCheck);

    _active = true;
    _startStreamingIncomingUpdates();
  }

  /// Cleans up outstanding resources for the active session.
  void _cleanupResources() {
    _active = false;

    // Clean up resources in reverse-order of creation
    _call?.cancel();
    _call = null;

    _serverCheckinTimer?.cancel();
    _serverCheckinTimer = null;

    _response = PGUpdate();

    _stub = null;

    _channel?.terminate();
    _channel = null;
  }

  /// True means PGComm is active in working with a server.  False means the
  /// open() method call failed in some way to initialize communication with
  /// the server.
  bool get active {
    return _active;
  }

  /// True means PGComm is paused in working with a server, which may be down or
  /// unavailable at the moment.  If this is False and _active is True, then it can
  /// be assumed that streaming is working.
  bool get paused {
    return _paused;
  }

  /// True means the server is invalid or unreachable, given the provided server
  /// address and port in the open() method call.
  bool get invalidServer {
    return _invalidServer;
  }

  /// Address of server we are streaming updates with.
  String get serverAddress {
    return _serverAddress;
  }

  /// Port of server we are streamig update with.
  int get serverPort {
    return _serverPort;
  }

  /// The remaining seconds until the next attempt to re-establish streaming.
  int get reconnectCountdown {
    return _reestablishmentCountdown;
  }

  /// Forcefully try to re-establish streaming without waiting for a reconnection
  /// countdown to expire.
  void tryConnectionAgain() {
    if (_reestablishmentTimer != null) {
      _reestablishmentTimer!.cancel();
      _startStreamingIncomingUpdates();
    }
  }

  /// Stream an update back to the server.
  void streamUpdateToServer(CborValue cborUpdate) {
    if (_paused) return;
    _response = PGUpdate(cbor: cbor.encode(cborUpdate));
    _completer.complete(true);
  }

  /// The routine called by a periodic timer to perform a "check-in" with the server
  /// to determine whether we are still streaming back/forth.
  void _periodicServerCheck(Timer timer) {
    if (_paused) {
      //print('Communication with server is paused.');
      return;
    }

    // Send over an empty partial update
    var emptyPartialUpdate = CborList([const CborBool(false)]);
    streamUpdateToServer(emptyPartialUpdate);
  }

  // An indefinite asynchonous function that yields updates to send back to server
  Stream<PGUpdate> _outgoingUpdates() async* {
    for (;;) {
      await _completer.future;
      // print('Sending update XXX ');
      yield _response;
      _completer = Completer();
    }
  }

  /// The routine called by a periodic timer to perform a second-based countdwon
  /// until an attempt is made to re-establish streaming with the server.
  void _reconnectCountdownRoutine(Timer timer) {
    _reestablishmentCountdown--;
    assert(_reestablishmentCountdown >= 0);

    notifyListeners();

    if (_reestablishmentCountdown == 0) {
      timer.cancel();
      _reestablishmentTimer = null;
      _startStreamingIncomingUpdates();
    }
  }

  /// An asyncrhonous method that attempts to start streaming uppdates with the server.
  Future<void> _startStreamingIncomingUpdates() async {
    //print('Streaming of updates is starting.');

    try {
      // Start streaming inbound (toward the app) and provide an async function
      // that will yield updates to stream outbound.
      _call = _stub!.streamUpdates(_outgoingUpdates());

      await _incomingUpdates();
    } catch (err) {
      //print('Error occurred waiting for incoming updates:  $err');
      _paused = true;
      notifyListeners();

      var emptyFullUpdate = CborList([const CborBool(true)]);
      _onUpdate(emptyFullUpdate);

      _reestablishmentCountdown = _reestablishmentPeriod;
      _reestablishmentTimer = Timer.periodic(
          const Duration(seconds: 1), _reconnectCountdownRoutine);
    }
  }

  /// An asynchronous method that pulls updates streamed from the server one at a time,
  /// decodes the update into CBOR, and calls the user-provided callback function with
  /// the update contents.
  Future<void> _incomingUpdates() async {
    await for (var pgUpdate in _call!) {
      //print('Received update of length = ${pgUpdate.cbor.length} bytes');

      if (_paused) {
        notifyListeners();
      }
      _paused = false;

      if (pgUpdate.cbor.isNotEmpty) {
        final cborUpdate = cbor.decode(pgUpdate.cbor);
        _onUpdate(cborUpdate);
      }
    }
  }
}

/// A widget that is used to rebuild the widget tree if PGComm notifies of state change.
class InheritedPGComm extends InheritedNotifier<PGComm> {
  const InheritedPGComm({
    super.key,
    super.notifier,
    required super.child,
  });

  static PGComm of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedPGComm>()!
        .notifier!;
  }
}
