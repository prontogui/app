// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'package:test/test.dart';
import 'package:app/primitive/tristate.dart';
import 'package:app/primitive/events.dart';
import 'test_cbor_samples.dart';
import 'test_ctor_args.dart';

void main() {
  test('Default field settings.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = TristateImpl(args.get);

    expect(pimpl.label, equals(''));
    expect(pimpl.state, equals(0));
  });

  test('Update fields from CBOR.', () {
    var v = CborMap({
      CborString('Label'): CborString('Enable suchandsuch'),
      CborString('State'): const CborSmallInt(2),
    });

    var args = TestCtorArgs(v);
    var pimpl = TristateImpl(args.get);

    expect(pimpl.label, equals('Enable suchandsuch'));
    expect(pimpl.state, equals(2));
  });

  test('Event handler is called with proper update when updateState is called.',
      () {
    var v = CborMap({});

    var args = TestCtorArgs(v);
    var pimpl = TristateImpl(args.get);
    pimpl.updateState(true);

    expect(pimpl.state, equals(1));
    expect(args.eventType, equals(EventType.stateChanged));
    expect(args.pkey.indices, equals(TestCtorArgs.pkeyForTest().indices));
    expect(args.update.length, equals(1));
    expect(args.update[CborString('State')], equals(const CborSmallInt(1)));
  });

  test('Event handler is called with proper update when nextState is called.',
      () {
    var v = CborMap({});

    var args = TestCtorArgs(v);
    var pimpl = TristateImpl(args.get);
    pimpl.nextState();

    expect(pimpl.state, equals(1));
    expect(args.eventType, equals(EventType.stateChanged));
    expect(args.pkey.indices, equals(TestCtorArgs.pkeyForTest().indices));
    expect(args.update.length, equals(1));
    expect(args.update[CborString('State')], equals(const CborSmallInt(1)));
  });

  test('Is not a notification point.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = TristateImpl(args.get);

    expect(pimpl.isNotificationPoint, isFalse);
  });

  test('Implements abstract Tristate class.', () {
    var args = TestCtorArgs(cborEmpty());
    Tristate _ = TristateImpl(args.get);
  });
}
