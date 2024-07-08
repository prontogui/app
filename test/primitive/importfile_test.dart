// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'package:test/test.dart';
import 'package:app/primitive/importfile.dart';
import 'package:app/primitive/events.dart';
import 'test_cbor_samples.dart';
import 'test_ctor_args.dart';

void main() {
  test('Default field settings.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = ImportFileImpl(args.get);

    expect(pimpl.data, isEmpty);
    expect(pimpl.imported, isFalse);
    expect(pimpl.name, isEmpty);
    expect(pimpl.validExtensions, isEmpty);
  });

  test('Update fields from CBOR.', () {
    var v = CborMap({
      CborString("Data"): CborBytes([10, 20, 30]),
      CborString("Imported"): const CborBool(true),
      CborString("Name"): CborString("file.txt"),
    });

    var args = TestCtorArgs(v);
    var pimpl = ImportFileImpl(args.get);

    expect(pimpl.data, equals([10, 20, 30]));
    expect(pimpl.imported, isTrue);
    expect(pimpl.name, equals('file.txt'));
  });

  test('Event handler is called with proper update.', () {
    var v = CborMap({});

    var args = TestCtorArgs(v);
    var pimpl = ImportFileImpl(args.get);
    pimpl.importComplete('file.txt', [10, 20, 30]);

    expect(args.eventType, equals(EventType.importComplete));
    expect(args.pkey.indices, equals(TestCtorArgs.pkeyForTest().indices));
    expect(args.update.length, equals(3));
    expect(args.update[CborString('Name')], equals(CborString('file.txt')));
    expect(args.update[CborString('Data')], equals(CborBytes([10, 20, 30])));
    expect(args.update[CborString('Imported')], equals(const CborBool(true)));
  });

  test('Is not a notification point.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = ImportFileImpl(args.get);

    expect(pimpl.isNotificationPoint, equals(false));
  });

  test('Implements abstract ImportFile class.', () {
    var args = TestCtorArgs(cborEmpty());
    ImportFile _ = ImportFileImpl(args.get);
  });
}
