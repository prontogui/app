// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'package:test/test.dart';
import 'package:app/primitive/textfield.dart';
import 'test_ctor_args.dart';
import 'test_cbor_samples.dart';

void main() {
  test('Default field settings.', () {
    var args = TestCtorArgs(cborEmpty());
    var txt = TextFieldImpl(args.get);

    expect(txt.textEntry, equals(''));
  });

  test('Update content field from CBOR.', () {
    var v = CborMap({
      CborString("TextEntry"): CborString("Lorem ipsum dolor sit amet"),
    });

    var args = TestCtorArgs(v);
    var text = TextFieldImpl(args.get);

    expect(text.textEntry, equals("Lorem ipsum dolor sit amet"));
  });

  test('Is not a notification point.', () {
    var args = TestCtorArgs(cborEmpty());
    var txt = TextFieldImpl(args.get);

    expect(txt.isNotificationPoint, equals(false));
  });

  test('Implements abstract TextField class.', () {
    var args = TestCtorArgs(cborEmpty());
    TextField _ = TextFieldImpl(args.get);
  });
}
