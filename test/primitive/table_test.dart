// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/command.dart';
import 'package:test/test.dart';
import 'package:app/primitive/table.dart';
import 'package:app/primitive/pkey.dart';
import 'test_ctor_args.dart';
import 'test_cbor_samples.dart';

void main() {
  test('Default field settings.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = TableImpl(args.get);

    expect(pimpl.rows.length, equals(0));
  });

  test('Update fields from CBOR.', () {
    var args = TestCtorArgs(cborForTable());
    var pimpl = TableImpl(args.get);

    expect(pimpl.rows.length, equals(2));
    expect(pimpl.rows[0].length, equals(2));
    expect(pimpl.rows[1].length, equals(2));

    expect(pimpl.rows[0][0].getParent(), equals(pimpl));
    expect(pimpl.rows[0][1].getParent(), equals(pimpl));
    expect(pimpl.rows[1][0].getParent(), equals(pimpl));
    expect(pimpl.rows[1][1].getParent(), equals(pimpl));
  });

  test('Locate descendant.', () {
    var args = TestCtorArgs(cborForTable());
    var pimpl = TableImpl(args.get);

    var pkey = PKey.empty().addIndex(0).addIndex(1).addIndex(1);

    var desc = pimpl.locateDescendant(PKeyLocator(pkey)) as Command;
    expect(desc.label, equals('START'));
  });

  test('Is notification point.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = TableImpl(args.get);

    expect(pimpl.isNotificationPoint, equals(true));
  });

  test('Implements abstract Table class.', () {
    var args = TestCtorArgs(cborEmpty());
    TableP _ = TableImpl(args.get);
  });
}
