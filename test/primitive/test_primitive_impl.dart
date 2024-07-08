// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/fkey.dart';
import 'package:app/primitive/pkey.dart';
import 'package:app/primitive/cbor_conversion.dart';
import 'package:app/primitive/primitive.dart';
import 'package:app/primitive/primitive_base.dart';
import 'package:cbor/cbor.dart';
import 'test_primitive.dart';

class TestPrimitiveImpl extends PrimitiveBase {
  TestPrimitiveImpl(super.ctorArgs);

  String label = '';

  @override
  void updateFieldFromCbor(FKey fkey, CborValue v) {
    switch (fkey) {
      case FKey.label:
        label = cborToString(v);
      default:
        assert(false);
    }
  }
}

class TestPrimitveImplDoesNotify extends PrimitiveBase {
  TestPrimitveImplDoesNotify(super.ctorArgs);

  @override
  bool get isNotificationPoint {
    return true;
  }
}

class TestPrimitveImplWithDescendant extends PrimitiveBase {
  TestPrimitveImplWithDescendant(super.ctorArgs);

  var child = TestPrimitive();

  @override
  Primitive locateDescendant(PKeyLocator locator) {
    locator.nextIndex();
    return child;
  }
}
