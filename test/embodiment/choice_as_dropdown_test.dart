// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/embodiment/choice_embodiment.dart';
import 'package:app/primitive/choice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'testtree.dart';

class _TestChoice implements Choice {
  @override
  String choice = "Apple";

  @override
  List<String> choices = ["Apple", "Orange", "Banana"];

  var notifyCount = 0;

  @override
  void updateChoice(String newChoice) {
    notifyCount++;
  }

  @override
  bool get isChoiceValid {
    return true;
  }
}

void main() {
  testWidgets('Choice shows correctly', (tester) async {
    // Test code goes here.

    final choice = _TestChoice();

    await tester.pumpWidget(TestTree(wut: ChoiceEmbodiment(choice: choice)));

    expect(find.byType(DropdownButton<String>), findsOneWidget);

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();

    expect(choice.notifyCount, equals(1));
  });
}
