// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:test/test.dart';
import 'package:app/primitive/pkey.dart';
import 'package:cbor/cbor.dart';

CborValue buildSamplePkey() {
  return CborList([
    const CborSmallInt(1),
    const CborSmallInt(5),
    const CborSmallInt(23),
  ]);
}

void main() {
  test('Construct from CBOR.', () {
    final pkey = PKey.fromCbor(buildSamplePkey());
    expect(pkey.indices.length, equals(3));
    expect(pkey.indices[0], equals(1));
    expect(pkey.indices[1], equals(5));
    expect(pkey.indices[2], equals(23));
  });
}
