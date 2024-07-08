// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:test/test.dart';
import 'package:app/primitive/fkey.dart';

void main() {
  test('Get a fieldname for an FKey #1.', () {
    var fieldname = fieldnameFor(FKey.embodiment);
    expect(fieldname, equals("Embodiment"));
  });

  test('Get a fieldname for an FKey #2.', () {
    var fieldname = fieldnameFor(FKey.rows);
    expect(fieldname, equals("Rows"));
  });

  test('Get an FKey for a fieldname #3.', () {
    var fkey = fkeyFor("Choices");
    expect(fkey, equals(FKey.choices));
  });
}
