// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/ctor_args.dart';
import 'package:app/primitive/events.dart';
import 'package:app/primitive/pkey.dart';
import 'package:cbor/cbor.dart';

import 'test_primitive.dart';

class TestCtorArgs {
  TestCtorArgs(this.cbor);

  final CborMap cbor;
  late EventType eventType;
  late PKey pkey;
  late CborMap update;

  static PKey pkeyForTest() {
    // Make a PKey with indices [1, 2]
    return PKey.addIndex(PKey.addIndex(PKey.empty(), 1), 2);
  }

  CtorArgs get get {
    return CtorArgs.once(TestPrimitive(),
        (evEventType, evPkey, evFieldUpdates) {
      eventType = evEventType;
      pkey = evPkey;
      update = evFieldUpdates;
    }, cbor, pkeyForTest());
  }
}
