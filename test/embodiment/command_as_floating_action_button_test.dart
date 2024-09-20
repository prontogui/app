// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/embodiment/command_embodiment.dart';
import 'package:app/primitive/command.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'testtree.dart';

class _TestCommand implements Command {
  @override
  String label = "Press Me";

  @override
  int status = 0;

  var notifyCount = 0;

  @override
  String tag = "";

  @override
  void issueCommand() {
    notifyCount++;
  }
}

void main() {
  testWidgets('Label shows correctly', (tester) async {
    // Test code goes here.

    final cmd = _TestCommand();

    await tester.pumpWidget(
        TestTree(wut: CommandEmbodiment(command: cmd, embodimentMap: null)));

    await tester.tap(find.byType(FloatingActionButton));

    final labelFinder = find.text("Press Me");

    expect(labelFinder, findsOneWidget);
    expect(cmd.notifyCount, equals(1));
  });
}
