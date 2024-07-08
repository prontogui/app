// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'events.dart';
import 'pkey.dart';
import 'primitive.dart';
import 'package:cbor/cbor.dart';

class CtorArgs {
  CtorArgs.once(this.parent, this.eventHandler, this.cbor, this.pkey);
  CtorArgs.multi(this.parent, this.eventHandler);

  final Primitive parent;
  final EventHandler eventHandler;
  late CborMap cbor;
  late PKey pkey;

  CtorArgs using(CborMap cbor, PKey pkey) {
    this.cbor = cbor;
    this.pkey = pkey;
    return this;
  }
}
