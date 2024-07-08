// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/embodiment/tristate_embodiment.dart';
import 'package:app/primitive/tristate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'testtree.dart';

class _TestTristate implements Tristate {
  _TestTristate.withLabel(this.label);

  _TestTristate.emptyLabel();

  @override
  String label = '';

  @override
  int state = 0;

  @override
  bool? get stateAsBool {
    switch (state) {
      case 0:
        return false;
      case 1:
        return true;
      case 2:
        return null;
      default:
        assert(false);
    }
    return null;
  }

  @override
  void nextState() {}

  /// Alternative setter of state using a nullable boolean.  Calling this function also
  /// sets the state field appropriately.
  @override
  set stateAsBool(bool? boolState) {
    if (boolState == null) {
      state = 2;
    } else if (boolState) {
      state = 1;
    } else {
      state = 0;
    }
  }

  var notifyCount = 0;

  @override
  void updateState(bool? newState) {
    notifyCount++;
  }
}

void main() {
  testWidgets('Tristate shows correctly', (tester) async {
    // Test code goes here.

    final tristate = _TestTristate.withLabel('Vote for trump or biden');

    await tester
        .pumpWidget(TestTree(wut: TristateEmbodiment(tristate: tristate)));

    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(tristate.notifyCount, equals(1));

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(tristate.notifyCount, equals(2));
  });

  testWidgets('Check shows correctly with empty label', (tester) async {
    // Test code goes here.

    final tristate = _TestTristate.emptyLabel();

    await tester
        .pumpWidget(TestTree(wut: TristateEmbodiment(tristate: tristate)));

    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.byType(Row), findsNothing);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(tristate.notifyCount, equals(1));
  });
}
