// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/embodiment/check_embodiment.dart';
import 'package:app/primitive/check.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'testtree.dart';

class _TestCheck implements Check {
  _TestCheck.withLabel(this.label);

  _TestCheck.emptyLabel();

  @override
  bool checked = false;

  @override
  String label = '';

  var notifyCount = 0;

  @override
  String tag = "";

  @override
  void updateChecked(bool checked) {
    notifyCount++;
  }

  @override
  void nextState() {}
}

void main() {
  testWidgets('Check shows correctly', (tester) async {
    // Test code goes here.

    final check = _TestCheck.withLabel('turn this on');

    await tester.pumpWidget(TestTree(wut: CheckEmbodiment(check: check)));

    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(check.notifyCount, equals(1));

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(check.notifyCount, equals(2));
  });

  testWidgets('Check shows correctly with empty label', (tester) async {
    // Test code goes here.

    final check = _TestCheck.emptyLabel();

    await tester.pumpWidget(TestTree(wut: CheckEmbodiment(check: check)));

    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byType(Row), findsNothing);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(check.notifyCount, equals(1));

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(check.notifyCount, equals(2));
  });
}
