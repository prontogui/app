// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'package:test/test.dart';
import 'package:app/primitive/check.dart';
import 'package:app/primitive/events.dart';
import 'test_cbor_samples.dart';
import 'test_ctor_args.dart';

void main() {
  test('Default field settings.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = CheckImpl(args.get);

    expect(pimpl.label, equals(''));
    expect(pimpl.checked, isFalse);
  });

  test('Update fields from CBOR.', () {
    var v = CborMap({
      CborString('Label'): CborString('Enable suchandsuch'),
      CborString('Checked'): const CborBool(true),
    });

    var args = TestCtorArgs(v);
    var pimpl = CheckImpl(args.get);

    expect(pimpl.label, equals('Enable suchandsuch'));
    expect(pimpl.checked, isTrue);
  });

  test('Event handler is called with proper update when updateChecked called.',
      () {
    var v = CborMap({});

    var args = TestCtorArgs(v);
    var pimpl = CheckImpl(args.get);
    pimpl.updateChecked(true);

    expect(args.eventType, equals(EventType.checkedChanged));
    expect(args.pkey.indices, equals(TestCtorArgs.pkeyForTest().indices));
    expect(args.update.length, equals(1));
    expect(args.update[CborString('Checked')], equals(const CborBool(true)));
  });

  test('Event handler is called with proper update when nextState called.', () {
    var v = CborMap({});

    var args = TestCtorArgs(v);
    var pimpl = CheckImpl(args.get);
    pimpl.nextState();

    expect(pimpl.checked, equals(true));
    expect(args.eventType, equals(EventType.checkedChanged));
    expect(args.pkey.indices, equals(TestCtorArgs.pkeyForTest().indices));
    expect(args.update.length, equals(1));
    expect(args.update[CborString('Checked')], equals(const CborBool(true)));
  });

  test('Is not a notification point.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = CheckImpl(args.get);

    expect(pimpl.isNotificationPoint, isFalse);
  });

  test('Implements abstract Check class.', () {
    var args = TestCtorArgs(cborEmpty());
    Check _ = CheckImpl(args.get);
  });
}
