// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/embodiment/text_embodiment.dart';
import 'package:app/primitive/text.dart' as pri;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'testtree.dart';

class _TestText implements pri.Text {
  @override
  String content = "Hello, World!";

  @override
  String tag = "";
}

void main() {
  testWidgets('Group is created', (tester) async {
    // TODO - fix this test.
    /*
    // Test code goes here.

    final txt = _TestText();

    await tester.pumpWidget(TestTree(wut: TextEmbodiment(text: txt)));

    expect(find.byType(Text), findsOneWidget);
    expect(find.text("Hello, World!"), findsOne);
  */
  });
}
