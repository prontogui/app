// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:grpc/grpc.dart';
import 'package:app/proto/pg.pbgrpc.dart';
import 'package:cbor/cbor.dart';

/// States of communication
enum PGCommState {
  /// Communication is inactive because either open() hasn't been called yet or
  /// the close() method was called.
  inactive,

  /// A connection attempt has been made by trying to make an RPC.  This brief state is designed
  /// to allow time for the connection to be established without having to tell the user
  /// we are waiting for the connection to be made.  It's mainly for messaging purposes.  After
  /// the connectingPeriod elapses, it switches to the connectingWait state, where we
  /// can notify the user that we're waiting.
  connecting,

  /// A connection attempt has been made by trying to make an RPC.  It remains in this state
  /// until successful or the connection times out or an error is returned.  This state is
  /// designed so we can update the user that we are waiting on the connection to occur.
  connectingWait,

  /// State where streaming of updates is happening without any problems.
  active,

  /// This state is entered upon error or disconnection during active streaming.  It
  /// is where we peroidically try to reestablish streaming through a successful RPC.
  reestablishmentDelay,
}

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

  final int _connectingPeriod = 3;

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

  /// A periodic timer used in different communication states.
  Timer? _timer;

  /// The current state of communication.
  PGCommState _state = PGCommState.inactive;

  /// True means the server is invalid or unreachable, given the provided server
  /// address and port in the open() method call.
  bool _invalidServer = false;

  /// True means PGComm is paused in working with a server, which may be down or
  /// unavailable at the moment.  If this is False and _active is True, then it can
  /// be assumed that streaming is working.
  // bool _paused = false;

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
  /// The optional [serverAddress] is the address of the server.  Likewise, the optional
  /// [serverPort] is the server port to connect through.  If either of these are not
  /// provided then it uses the previous values of the serverAddress and/or
  /// serverPort properties.
  void open({String? serverAddress, int? serverPort}) {
    // Active session already?
    if (_state != PGCommState.inactive) {
      _cleanupResources(false);
    }

    if (serverAddress != null) {
      _serverAddress = serverAddress;
    }
    if (serverPort != null) {
      _serverPort = serverPort;
    }
    _invalidServer = false;

    try {
      // Open an HTTP/2 channel
      _channel = ClientChannel(
        InternetAddress(_serverAddress),
        port: _serverPort,
        options: ChannelOptions(
          credentials: const ChannelCredentials.insecure(),
          codecRegistry:
              CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
          //connectTimeout: const Duration(minutes: 5),
        ),
      );

      // Create a client object for talking with PGService
      _stub = PGServiceClient(_channel!);
    } catch (err) {
      _cleanupResources(true);
      return;
    }

    // Create a Completer to signal when there is an update to send
    _completer = Completer();

    // Initialize with an empty update
    _response = PGUpdate();

    _state = PGCommState.connecting;
    _startStreamingIncomingUpdates();
  }

  /// Closes an open communication session (if any) and enters the inactive state.
  void close() {
    _cleanupResources(false);
    notifyListeners();
  }

  /// Returns the current state of communication.
  PGCommState get state {
    return _state;
  }

  /// True means the server is invalid or unreachable, given the provided server
  /// address and port in the open() method call.
  bool get invalidServer {
    return _invalidServer;
  }

  double get reestablishmentWaitProgress {
    if (_timer == null) {
      return 0.0;
    }
    return _timer!.tick / _reestablishmentPeriod;
  }

  /// Address of server we are streaming updates with.
  String get serverAddress {
    return _serverAddress;
  }

  /// Set the server address for next communication session.  If there is a session
  /// already open and the server address is different then it will be forcefully closed.
  set serverAddress(String addr) {
    if (_state != PGCommState.inactive && addr != _serverAddress) {
      _cleanupResources(false);
    }
    _serverAddress = addr;
  }

  /// Port of server we are streamig update with.
  int get serverPort {
    return _serverPort;
  }

  /// Set the server port for next communication session.  If there is a session
  /// already open and the server port is different then it will be forcefully closed.
  set serverPort(int port) {
    if (_state != PGCommState.inactive && port != _serverPort) {
      _cleanupResources(false);
    }
    _serverPort = port;
  }

  /// The remaining timer ticks (approximately 1 second each) elapsed while waiting for
  /// a connection or the ticks left until the next attempt to re-establish streaming.
  int get ticks {
    return _timer != null ? _timer!.tick : 0;
  }

  /// Forcefully try to re-establish streaming without waiting for a reconnection
  /// countdown to expire.
  void tryConnectionAgain() {
    if (_state == PGCommState.connectingWait) {
      open();
    } else if (_state == PGCommState.reestablishmentDelay) {
      _startStreamingIncomingUpdates();
    }
  }

  /// Stream an update back to the server.
  void streamUpdateToServer(CborValue cborUpdate) {
    if (_state != PGCommState.active) return;
    _response = PGUpdate(cbor: cbor.encode(cborUpdate));
    // NOTE:  this routine doesn't support multiple back-to-back updates without
    // a microtask intermission.
    // You will get an exception:  StateError (Bad state: Future already completed)
    _completer.complete(true);
  }

  /// Cleans up outstanding resources for the active session.
  /// [invalidServer] should be true if calling this after a failed attempt to
  /// to establish a client channel due to an invalid server address.
  void _cleanupResources(bool invalidServer) {
    _state = PGCommState.inactive;

    // Clean up resources in reverse-order of creation
    _call?.cancel();
    _call = null;

    _timer?.cancel();
    _timer = null;

    _response = PGUpdate();

    _stub = null;

    _channel?.terminate();
    _channel = null;

    _invalidServer = invalidServer;
  }

  /// The routine called by a periodic timer to perform a work during certain
  /// states of communication.
  void _timerRoutine(Timer timer) {
    if (kDebugMode) {
      print('State is $_state (${timer.tick} ticks\n');
    }

    switch (_state) {
      case PGCommState.inactive:
        // This should never happen
        assert(false);
      case PGCommState.active:
        // Send over an empty partial update
        var emptyPartialUpdate = CborList([const CborBool(false)]);
        streamUpdateToServer(emptyPartialUpdate);
      case PGCommState.connecting:
        // Switch to next state
        _state = PGCommState.connectingWait;
        _startTimer(1);

      case PGCommState.connectingWait:
        notifyListeners();

      case PGCommState.reestablishmentDelay:
        notifyListeners();

        if (timer.tick >= _reestablishmentPeriod) {
          _startStreamingIncomingUpdates();
        }
    }
  }

  // An indefinite asynchonous function that yields updates to send back to server
  Stream<PGUpdate> _outgoingUpdates() async* {
    for (;;) {
      await _completer.future;
      if (_response.cbor.isNotEmpty) {
        yield _response;
      }
      _completer = Completer();
    }
  }

  // Starts (or restarts) the timer for checking in with the server.
  void _startTimer(int period) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: period), _timerRoutine);
  }

  /// An asynchronous method that pulls updates streamed from the server one at a time,
  /// decodes the update into CBOR, and calls the user-provided callback function with
  /// the update contents.
  Future<void> _incomingUpdates() async {
    await for (var pgUpdate in _call!) {
      if (kDebugMode) {
        print('Received update of length = ${pgUpdate.cbor.length} bytes');
      }

      if (_state != PGCommState.active) {
        notifyListeners();
      }
      _state = PGCommState.active;

      // reset the timer for checking in with server
      _startTimer(_serverCheckinPeriod);

      if (pgUpdate.cbor.isNotEmpty) {
        final cborUpdate = cbor.decode(pgUpdate.cbor);
        _onUpdate(cborUpdate);
      }
    }
  }

  /// An asyncrhonous method that attempts to start streaming uppdates with the server.
  Future<void> _startStreamingIncomingUpdates() async {
    if (kDebugMode) {
      print('Streaming of updates is starting.');
    }

    final timerPeriod = (_state == PGCommState.connecting)
        ? _connectingPeriod
        : _reestablishmentPeriod;

    // Set a timer to perform a countdown until attempt is made to reconnect
    _startTimer(timerPeriod);

    try {
      // Start streaming inbound (toward the app) and provide an async function
      // that will yield updates to stream outbound.
      _call = _stub!.streamUpdates(_outgoingUpdates());

      await _incomingUpdates();

      // This is the main excpetion catcher for when communication problems arise
    } catch (err) {
      if (kDebugMode) {
        print('Error occurred waiting for incoming updates:  $err');
      }

      // Clear any pending response heading back to server
      _response = PGUpdate();

      if (_state == PGCommState.active ||
          _state == PGCommState.reestablishmentDelay) {
        _state = PGCommState.reestablishmentDelay;
        _startTimer(1);
        notifyListeners();
      }

      var emptyFullUpdate = CborList([const CborBool(true)]);
      _onUpdate(emptyFullUpdate);
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
