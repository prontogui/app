// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'package:flutter/foundation.dart';

String cborToString(CborValue v) {
  assert(v is CborString);
  return (v as CborString).toString();
}

int cborToInt(CborValue v) {
  assert(v is CborSmallInt);
  return (v as CborSmallInt).value;
}

bool cborToBool(CborValue v) {
  assert(v is CborBool);
  return (v as CborBool).value;
}

List<int> cborToBlob(CborValue v) {
  if (v is CborNull) {
    return [];
  }
  assert(v is CborBytes);
  return (v as CborBytes).bytes;
}

List<String> cborToStringList(CborValue v) {
  if (v is CborNull) {
    return List<String>.empty();
  }

  assert(v is CborList);
  var cborList = v as CborList;
  var list = List<String>.generate(cborList.length, (index) {
    assert(cborList[index] is CborString);
    var cborItem = cborList[index] as CborString;
    return cborItem.toString();
  });
  return list;
}
