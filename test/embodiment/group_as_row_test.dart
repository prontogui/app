// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/embodiment/group_embodiment.dart';
import 'package:app/primitive/group.dart';
import 'package:app/primitive/primitive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'testtree.dart';

class _TestGroup implements Group {
  @override
  List<Primitive> get groupItems {
    return [];
  }

  @override
  String tag = "";
}

void main() {
/*
  testWidgets('Group is created', (tester) async {
    // Test code goes here.

    final grp = _TestGroup();

    await tester.pumpWidget(TestTree(wut: GroupEmbodiment(group: grp)));

    expect(find.byType(Row), findsOneWidget);
  });
*/
}
