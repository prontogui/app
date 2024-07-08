// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';

String cborToString(CborValue v) {
  return (v as CborString).toString();
}

int cborToInt(CborValue v) {
  return (v as CborSmallInt).value;
}

bool cborToBool(CborValue v) {
  return (v as CborBool).value;
}

List<int> cborToBlob(CborValue v) {
  if (v is CborNull) {
    return [];
  }
  return (v as CborBytes).bytes;
}

List<String> cborToStringList(CborValue v) {
  var cborList = v as CborList;
  var list = List<String>.generate(cborList.length, (index) {
    var cborItem = cborList[index] as CborString;
    return cborItem.toString();
  });
  return list;
}
