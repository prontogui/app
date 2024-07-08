// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';

const invalidIndex = -1;

class PKey {
  PKey.fromCbor(CborValue v) {
    assert(v is CborList);
    var cborIndices = v as CborList;

    _indices = List<int>.generate(cborIndices.length,
        (index) => (cborIndices[index] as CborSmallInt).value,
        growable: false);
  }

  CborList toCbor() {
    return CborList.generate(
        _indices.length, (index) => CborSmallInt(_indices[index]));
  }

  PKey.addIndex(PKey pkey, int index) {
    _indices = [...pkey._indices, index];
  }

  PKey addIndex(int index) {
    _indices = [..._indices, index];
    return this;
  }

  PKey.empty() {
    _indices = [];
  }

  late List<int> _indices;

  List<int> get indices {
    return _indices;
  }
}

class PKeyLocator {
  PKeyLocator(this.pkey) : locationLevel = -1;

  final PKey pkey;
  int locationLevel;

  int nextIndex() {
    assert(locationLevel < (pkey.indices.length - 1));
    locationLevel++;
    return pkey.indices[locationLevel];
  }

  bool located() {
    return locationLevel == (pkey.indices.length - 1);
  }
}
