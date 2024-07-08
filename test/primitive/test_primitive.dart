// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/pkey.dart';
import 'package:app/primitive/primitive.dart';
import 'package:cbor/cbor.dart';
import 'package:flutter/material.dart';

class TestPrimitive implements Primitive {
  @override
  void updateFromCbor(CborMap m) {}

  @override
  Listenable? doesNotify({bool notifyNow = false}) {
    return null;
  }

  @override
  Primitive? getParent() {
    return null;
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    return this;
  }

  @override
  Map<String, dynamic>? getEmbodimentProperties() {
    return null;
  }
}
