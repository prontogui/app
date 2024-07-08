// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'package:test/test.dart';
import 'package:app/primitive/exportfile.dart';
import 'package:app/primitive/events.dart';
import 'test_cbor_samples.dart';
import 'test_ctor_args.dart';

void main() {
  test('Default field settings.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = ExportFileImpl(args.get);

    expect(pimpl.data, isEmpty);
    expect(pimpl.exported, isFalse);
    expect(pimpl.name, isEmpty);
  });

  test('Update fields from CBOR.', () {
    var v = CborMap({
      CborString("Data"): CborBytes([10, 20, 30]),
      CborString("Exported"): const CborBool(true),
      CborString("Name"): CborString("file.txt"),
    });

    var args = TestCtorArgs(v);
    var pimpl = ExportFileImpl(args.get);

    expect(pimpl.data, equals([10, 20, 30]));
    expect(pimpl.exported, isTrue);
    expect(pimpl.name, equals('file.txt'));
  });

  test('Event handler is called with proper update.', () {
    var v = CborMap({});

    var args = TestCtorArgs(v);
    var pimpl = ExportFileImpl(args.get);
    pimpl.exportComplete();

    expect(args.eventType, equals(EventType.exportComplete));
    expect(args.pkey.indices, equals(TestCtorArgs.pkeyForTest().indices));
    expect(args.update.length, equals(1));
    expect(args.update[CborString('Exported')], equals(const CborBool(true)));
  });

  test('Is not a notification point.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = ExportFileImpl(args.get);

    expect(pimpl.isNotificationPoint, equals(false));
  });

  test('Implements abstract ExportFile class.', () {
    var args = TestCtorArgs(cborEmpty());
    ExportFile _ = ExportFileImpl(args.get);
  });
}
