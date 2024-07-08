// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'package:test/test.dart';
import 'package:app/primitive/timer.dart';
import 'package:app/primitive/events.dart';
import 'test_cbor_samples.dart';
import 'test_ctor_args.dart';

void main() {
  test('Default field settings.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = TimerImpl(args.get);

    expect(pimpl.periodMs, equals(0));
  });

  test('Update fields from CBOR.', () {
    var v = CborMap({
      CborString("PeriodMs"): const CborSmallInt(2000),
    });

    var args = TestCtorArgs(v);
    var pimpl = TimerImpl(args.get);

    expect(pimpl.periodMs, equals(2));
  });

  test('Event handler is called with proper update.', () {
    var v = CborMap({});

    var args = TestCtorArgs(v);
    var pimpl = TimerImpl(args.get);

    pimpl.timerFired();

    expect(args.eventType, equals(EventType.timerFired));
    expect(args.pkey.indices, equals(TestCtorArgs.pkeyForTest().indices));
    expect(args.update.length, equals(0));
  });

  test('Is a notification point.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = TimerImpl(args.get);

    expect(pimpl.isNotificationPoint, equals(true));
  });

  test('Implements abstract Timer class.', () {
    var args = TestCtorArgs(cborEmpty());
    TimerP _ = TimerImpl(args.get);
  });
}
