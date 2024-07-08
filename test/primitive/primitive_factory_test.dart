// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/check.dart';
import 'package:app/primitive/choice.dart';
import 'package:app/primitive/command.dart';
import 'package:app/primitive/exportfile.dart';
import 'package:app/primitive/frame.dart';
import 'package:app/primitive/group.dart';
import 'package:app/primitive/importfile.dart';
import 'package:app/primitive/list.dart';
import 'package:app/primitive/table.dart';
import 'package:app/primitive/text.dart';
import 'package:app/primitive/textfield.dart';
import 'package:app/primitive/timer.dart';
import 'package:app/primitive/tristate.dart';
import 'package:test/test.dart';
import 'package:app/primitive/primitive_factory.dart';
import 'test_cbor_samples.dart';
import 'test_ctor_args.dart';

void main() {
  test('Create a Command primitive.', () {
    var args = TestCtorArgs(distinctCborForCommand());
    var cmd = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(cmd is CommandImpl, isTrue);
  });

  test('Create a Group primitive.', () {
    var args = TestCtorArgs(distinctCborForGroup());
    var grp = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(grp is GroupImpl, isTrue);
  });

  test('Create a Text primitive.', () {
    var args = TestCtorArgs(distinctCborForText());
    var txt = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(txt is TextImpl, isTrue);
  });

  test('Create a Choice primitive.', () {
    var args = TestCtorArgs(distinctCborForChoice());
    var choice = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(choice is ChoiceImpl, isTrue);
  });

  test('Create a Check primitive.', () {
    var args = TestCtorArgs(distinctCborForCheck());
    var check = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(check is CheckImpl, isTrue);
  });

  test('Create a Tristate primitive.', () {
    var args = TestCtorArgs(distinctCborForTristate());
    var tri = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(tri is TristateImpl, isTrue);
  });

  test('Create a List primitive.', () {
    var args = TestCtorArgs(distinctCborForList());
    var list = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(list is ListImpl, isTrue);
  });

  test('Create a TextField primitive.', () {
    var args = TestCtorArgs(distinctCborForTextField());
    var tf = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(tf is TextFieldImpl, isTrue);
  });

  test('Create a Frame primitive.', () {
    var args = TestCtorArgs(distinctCborForFrame());
    var tf = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(tf is FrameImpl, isTrue);
  });

  test('Create an ExportFile primitive.', () {
    var args = TestCtorArgs(distinctCborForExportFile());
    var tf = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(tf is ExportFileImpl, isTrue);
  });

  test('Create an ImportFile primitive.', () {
    var args = TestCtorArgs(distinctCborForImportFile());
    var tf = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(tf is ImportFileImpl, isTrue);
  });

  test('Create a Table primitive.', () {
    var args = TestCtorArgs(distinctCborForTable());
    var p = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(p is TableImpl, isTrue);
  });

  test('Create a Timer primitive.', () {
    var args = TestCtorArgs(distinctCborForTimer());
    var p = PrimitiveFactory.createPrimitiveFromCborMap(args.get);
    expect(p is TimerImpl, isTrue);
  });
}
