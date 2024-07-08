// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/cbor_conversion.dart';
import 'package:cbor/cbor.dart';
import 'package:test/test.dart';

void main() {
  test('Covnert CBOR to string.', () {
    // Test for arbitrary string
    var cbor = CborString('zero sugar');
    var s = cborToString(cbor);
    expect(s, 'zero sugar');

    // Test for empty string
    cbor = CborString('');
    s = cborToString(cbor);
    expect(s, '');
  });

  test('Covnert CBOR to int.', () {
    // Test for arbitrary number
    var cbor = const CborSmallInt(2342);
    var i = cborToInt(cbor);
    expect(i, 2342);

    // Test for negative
    cbor = const CborSmallInt(-78889);
    i = cborToInt(cbor);
    expect(i, -78889);

    // Test for zero
    cbor = const CborSmallInt(0);
    i = cborToInt(cbor);
    expect(i, 0);
  });

  test('Covnert CBOR to bool.', () {
    // Test for true
    var cbor = const CborBool(true);
    var b = cborToBool(cbor);
    expect(b, isTrue);

    // Test for false
    cbor = const CborBool(false);
    b = cborToBool(cbor);
    expect(b, isFalse);
  });

  test('Covnert CBOR to string list.', () {
    var cbor = CborList([CborString("A"), CborString("B")]);
    var list = cborToStringList(cbor);
    expect(list, equals(["A", "B"]));
  });

  test('Covnert empty CBOR list to string list.', () {
    var cbor = CborList([]);
    var list = cborToStringList(cbor);
    expect(list, equals([]));
  });
}
