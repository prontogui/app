// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/embodiment/check_embodiment.dart';
import 'package:app/embodiment/choice_embodiment.dart';
import 'package:app/embodiment/command_embodiment.dart';
import 'package:app/embodiment/embodifier.dart';
import 'package:app/embodiment/exportfile_embodiment.dart';
import 'package:app/embodiment/group_embodiment.dart';
import 'package:app/embodiment/importfile_embodiment.dart';
import 'package:app/embodiment/table_embodiment.dart';
import 'package:app/embodiment/text_embodiment.dart';
import 'package:app/embodiment/textfield_embodiment.dart';
import 'package:app/embodiment/timer_embodiment.dart';
import 'package:app/embodiment/tristate_embodiment.dart';
import 'package:app/primitive/ctor_args.dart';
import 'package:app/primitive/pkey.dart';
import 'package:app/primitive/primitive.dart';
import 'package:app/primitive/primitive_factory.dart';
import 'package:cbor/cbor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../primitive/test_cbor_samples.dart';
import '../primitive/test_primitive.dart';
import 'testtree.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key, required this.primitive});

  final Primitive primitive;

  @override
  Widget build(BuildContext context) {
    return Embodifier.of(context).buildPrimitive(context, primitive);
  }
}

Widget createTestWidget(CborMap cbor) {
  var ctorArgs = CtorArgs.once(
      TestPrimitive(), (eventType, pkey, fieldUpdates) {}, cbor, PKey.empty());
  var primitive = PrimitiveFactory.createPrimitiveFromCborMap(ctorArgs);
  var wut = TestWidget(primitive: primitive!);
  return TestTree(wut: wut);
}

void main() {
  group('Command embodiments', () {
    testWidgets('CommandAsFloatingActionButton is created by default.',
        (tester) async {
      var cbor = distinctCborForCommand();

      await tester.pumpWidget(createTestWidget(cbor));

      expect(find.byType(CommandEmbodiment), findsOneWidget);
    });

    testWidgets('Command embodiment for outlined.', (tester) async {
      var cbor = cborForCommandAsOutlined();

      await tester.pumpWidget(createTestWidget(cbor));

      expect(find.byType(CommandEmbodiment), findsOneWidget);
    });
  });

  group('Group embodiment', () {
    testWidgets('GroupEmbodiment is created by default.', (tester) async {
      var cbor = distinctCborForGroup();

      await tester.pumpWidget(createTestWidget(cbor));

      expect(find.byType(GroupEmbodiment), findsOneWidget);
    });
  });

  group('Text embodiments', () {
    testWidgets('TextEmbodiment is created by default.', (tester) async {
      var cbor = distinctCborForText();

      await tester.pumpWidget(createTestWidget(cbor));

      expect(find.byType(TextEmbodiment), findsOneWidget);
    });
  });

  group('Choice embodiments', () {
    testWidgets('ChoiceEmbodiment is created by default.', (tester) async {
      var cbor = distinctCborForChoice();
      await tester.pumpWidget(createTestWidget(cbor));
      expect(find.byType(ChoiceEmbodiment), findsOneWidget);
    });
  });

  group('Check embodiments', () {
    testWidgets('CheckEmbodiment is created by default.', (tester) async {
      var cbor = distinctCborForCheck();
      await tester.pumpWidget(createTestWidget(cbor));
      expect(find.byType(CheckEmbodiment), findsOneWidget);
    });
  });

  group('Tristate embodiments', () {
    testWidgets('TristateEmbodiment is created by default.', (tester) async {
      var cbor = distinctCborForTristate();
      await tester.pumpWidget(createTestWidget(cbor));
      expect(find.byType(TristateEmbodiment), findsOneWidget);
    });
  });

  group('TextField embodiments', () {
    testWidgets('TextFieldEmbodiment is created by default.', (tester) async {
      var cbor = distinctCborForTextField();

      await tester.pumpWidget(createTestWidget(cbor));

      expect(find.byType(TextFieldEmbodiment), findsOneWidget);
    });
  });

  group('ExportFile embodiments', () {
    testWidgets('ExportFileEmbodiment is created by default.', (tester) async {
      var cbor = distinctCborForExportFile();

      await tester.pumpWidget(createTestWidget(cbor));

      expect(find.byType(ExportFileEmbodiment), findsOneWidget);
    });
  });

  group('ImportFile embodiments', () {
    testWidgets('ImportFileEmbodiment is created by default.', (tester) async {
      var cbor = distinctCborForImportFile();

      await tester.pumpWidget(createTestWidget(cbor));

      expect(find.byType(ImportFileEmbodiment), findsOneWidget);
    });
  });

  group('Table embodiment', () {
    testWidgets('TableEmbodiment is created by default.', (tester) async {
      var cbor = distinctCborForTable();

      await tester.pumpWidget(createTestWidget(cbor));

      expect(find.byType(TableEmbodiment), findsOneWidget);
    });
  });

  group('Timer embodiment', () {
    testWidgets('TimerEmbodiment is created by default.', (tester) async {
      var cbor = distinctCborForTimer();

      await tester.pumpWidget(createTestWidget(cbor));

      expect(find.byType(TimerEmbodiment), findsOneWidget);
    });
  });
}
