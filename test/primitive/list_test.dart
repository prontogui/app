// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/command.dart';
import 'package:cbor/cbor.dart';
import 'package:test/test.dart';
import 'package:app/primitive/list.dart';
import 'package:app/primitive/pkey.dart';
import 'package:app/primitive/events.dart';
import 'test_ctor_args.dart';
import 'test_cbor_samples.dart';

void main() {
  test('Default field settings.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = ListImpl(args.get);

    expect(pimpl.listItems.length, equals(0));
    expect(pimpl.selected, equals(-1));
  });

  test('Update fields from CBOR.', () {
    var args = TestCtorArgs(cborForList());
    var pimpl = ListImpl(args.get);

    expect(pimpl.listItems.length, equals(2));
    expect(pimpl.listItems[0].getParent(), equals(pimpl));
    expect(pimpl.listItems[1].getParent(), equals(pimpl));
    expect(pimpl.selected, equals(1));
  });

  test(
      'Event handler is called with proper update when updateSelected is called.',
      () {
    var v = CborMap({});

    var args = TestCtorArgs(v);
    var pimpl = ListImpl(args.get);
    pimpl.updateSelected(1);

    expect(args.eventType, equals(EventType.selectedChanged));
    expect(args.pkey.indices, equals(TestCtorArgs.pkeyForTest().indices));
    expect(args.update.length, equals(1));
    expect(args.update[CborString('Selected')], equals(const CborSmallInt(1)));
  });

  test('Locate descendant.', () {
    var args = TestCtorArgs(cborForList());
    var pimpl = ListImpl(args.get);

    var pkey = PKey.empty().addIndex(0).addIndex(1);

    var desc = pimpl.locateDescendant(PKeyLocator(pkey)) as Command;
    expect(desc.label, equals("Click Here! (disable)"));
  });

  test('Is notification point.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = ListImpl(args.get);

    expect(pimpl.isNotificationPoint, equals(true));
  });

  test('Implements abstract ListP class.', () {
    var args = TestCtorArgs(cborEmpty());
    ListP _ = ListImpl(args.get);
  });
}
