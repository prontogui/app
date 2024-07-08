// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:app/proto/pg.pbgrpc.dart';
import 'package:cbor/cbor.dart';

class PGComm {
  late final ClientChannel _channel;
  late final PGServiceClient _stub;
  late Completer _completer;
  late PGUpdate _response;
  late ResponseStream<PGUpdate> _call;
  late Function _onUpdate;

  PGComm.start(Function onUpdate) {
    _onUpdate = onUpdate;

    // Open an HTTP/2 channel
    _channel = ClientChannel(
      InternetAddress("127.0.0.1"),
      //      'localhost',
      port: 50053,
      options: ChannelOptions(
        credentials: const ChannelCredentials.insecure(),
        codecRegistry:
            CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      ),
    );

    // Create a client object for talking with PGService
    _stub = PGServiceClient(_channel);

    // Create a Complete to signal when there is an update to send
    _completer = Completer();

    // Initialize with an empty update
    _response = PGUpdate();

    // Start streaming inbound (toward the app) and provide an async function
    // that will yield updates to stream outbound.
    _call = _stub.streamUpdates(_outgoingUpdates());

    _incomingUpdates();
  }

  void sendUpdate(CborValue cborUpdate) {
    _response = PGUpdate(cbor: cbor.encode(cborUpdate));
    _completer.complete(true);
  }

  // An indefinite asynchonous function that yields mutations to send back to server
  Stream<PGUpdate> _outgoingUpdates() async* {
    for (;;) {
      await _completer.future;
      print('Sending update XXX ');
      yield _response;
      _completer = Completer();
    }
  }

  Future<void> _incomingUpdates() async {
    await for (var pgUpdate in _call) {
      print('Received update of length = ${pgUpdate.cbor.length} bytes');

      if (pgUpdate.cbor.isNotEmpty) {
        final cborUpdate = cbor.decode(pgUpdate.cbor);
        _onUpdate(cborUpdate);
      }
    }
  }
}
