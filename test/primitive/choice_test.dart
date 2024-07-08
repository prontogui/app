// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'package:test/test.dart';
import 'package:app/primitive/choice.dart';
import 'package:app/primitive/events.dart';
import 'test_cbor_samples.dart';
import 'test_ctor_args.dart';

void main() {
  test('Default field settings.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = ChoiceImpl(args.get);

    expect(pimpl.choice, equals(''));
    expect(pimpl.choices.length, equals(0));
  });

  test('Update fields from CBOR.', () {
    var v = CborMap({
      CborString("Choice"): CborString("Apple"),
      CborString("Choices"):
          CborList([CborString("Apple"), CborString("Orange")]),
    });

    var args = TestCtorArgs(v);
    var pimpl = ChoiceImpl(args.get);

    expect(pimpl.choice, equals('Apple'));
    expect(pimpl.choices, equals(['Apple', 'Orange']));
  });

  test('Event handler is called with proper update.', () {
    var v = CborMap({});

    var args = TestCtorArgs(v);
    var pimpl = ChoiceImpl(args.get);
    pimpl.updateChoice("");

    expect(args.eventType, equals(EventType.choiceChanged));
    expect(args.pkey.indices, equals(TestCtorArgs.pkeyForTest().indices));
    expect(args.update.length, equals(1));
    expect(args.update[CborString('Choice')], equals(CborString('')));
  });

  test('Is not a notification point.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = ChoiceImpl(args.get);

    expect(pimpl.isNotificationPoint, equals(false));
  });

  test('Implements abstract Choice class.', () {
    var args = TestCtorArgs(cborEmpty());
    Choice _ = ChoiceImpl(args.get);
  });
}
