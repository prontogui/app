// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'package:test/test.dart';
import 'package:app/primitive/command.dart';
import 'package:app/primitive/events.dart';
import 'test_cbor_samples.dart';
import 'test_ctor_args.dart';

void main() {
  test('Default field settings.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = CommandImpl(args.get);

    expect(pimpl.label, equals(''));
    expect(pimpl.status, equals(0));
  });

  test('Update fields from CBOR.', () {
    var v = CborMap({
      CborString("Label"): CborString("Click on me."),
      CborString("Status"): const CborSmallInt(2),
    });

    var args = TestCtorArgs(v);
    var pimpl = CommandImpl(args.get);

    expect(pimpl.label, equals("Click on me."));
    expect(pimpl.status, equals(2));
  });

  test('Event handler is called with proper update.', () {
    var v = CborMap({});

    var args = TestCtorArgs(v);
    var pimpl = CommandImpl(args.get);
    pimpl.issueCommand();

    expect(args.eventType, equals(EventType.commandIssued));
    expect(args.pkey.indices, equals(TestCtorArgs.pkeyForTest().indices));
    expect(args.update.length, equals(0));
  });

  test('Is not a notification point.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = CommandImpl(args.get);

    expect(pimpl.isNotificationPoint, equals(false));
  });

  test('Implements abstract Command class.', () {
    var args = TestCtorArgs(cborEmpty());
    Command _ = CommandImpl(args.get);
  });
}
