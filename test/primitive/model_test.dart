// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:test/test.dart';
import 'package:app/primitive/model.dart';
import 'package:app/primitive/command.dart';
import 'package:app/primitive/frame.dart';
import 'package:app/primitive/check.dart';
import 'package:app/primitive/group.dart';
import 'package:app/primitive/text.dart';
import 'package:app/primitive/pkey.dart';
import 'package:cbor/cbor.dart';
import 'package:app/primitive/events.dart';

CborValue buildSampleFullUpdate() {
  var cmd1 = CborMap({
    CborString('Label'): CborString('Press Me!'),
    CborString('Status'): const CborSmallInt(1),
  });

  var cmd2 = CborMap({
    CborString('Label'): CborString('Click Here!'),
    CborString('Status'): const CborSmallInt(2),
  });

  var group1 = CborMap({
    CborString('GroupItems'): CborList([cmd1, cmd2]),
  });

  var text1 = CborMap({
    CborString('Content'): CborString('Hello, world!'),
  });

  var frame1 = CborMap({
    CborString('Embodiment'): CborString('full-view'),
    CborString('Showing'): const CborBool(true),
    CborString('FrameItems'): CborList([]),
  });

  var frame2 = CborMap({
    CborString('Embodiment'): CborString('full-view'),
    CborString('FrameItems'): CborList([]),
  });

  var chk1 = CborMap({
    CborString('Checked'): const CborBool(true),
    CborString('Label'): CborString('Yes or no'),
  });

  var frame3 = CborMap({
    CborString('Embodiment'): CborString('dialog-view'),
    CborString('FrameItems'): CborList([chk1]),
  });

  return CborList(
      [const CborBool(true), group1, text1, frame1, frame2, frame3]);
}

CborValue buildSamplePartialUpdate() {
  var cmd1update = CborMap({
    CborString('Label'): CborString('A new label!'),
  });

  var pkey = CborList([
    const CborSmallInt(0),
    const CborSmallInt(0),
    const CborSmallInt(0),
  ]);

  return CborList([const CborBool(false), pkey, cmd1update]);
}

void nullEventHandler(EventType eventType, PKey pkey, CborMap fieldUpdates) {
  // Do nothing here
}

void main() {
  // TODO:  fix the following tests.

  /*
  /// This is just a smoke test for full update.  More testing will be done outside of unit tests.
  test('Correct primitive model is build from full update.', () {
    final model = PrimitiveModel(nullEventHandler);

    model.updateFromCbor(buildSampleFullUpdate());

    var background = model.backgroundPrimitives;
    var frameViews = model.topLevelViewFrames;
    expect(background.length, equals(2));

    expect(background[0], const TypeMatcher<Group>());
    expect(background[1], const TypeMatcher<Text>());

    expect(frameViews.length, equals(3));
    expect(frameViews[0], const TypeMatcher<Frame>());
    expect(frameViews[1], const TypeMatcher<Frame>());
    expect(frameViews[2], const TypeMatcher<Frame>());

    var group = background[0] as Group;
    expect(group.groupItems.length, equals(2));

    var item1 = group.groupItems[0];
    expect(item1, const TypeMatcher<Command>());

    var item2 = group.groupItems[1];
    expect(item2, const TypeMatcher<Command>());

    var cmd1 = item1 as Command;
    var cmd2 = item2 as Command;

    expect(cmd1.label, equals('Press Me!'));
    expect(cmd1.status, equals(1));
    expect(cmd2.label, equals('Click Here!'));
    expect(cmd2.status, equals(2));

    var text = background[1] as Text;
    expect(text.content, equals('Hello, world!'));

    var frame1 = frameViews[0];
    expect(frame1.frameItems, isEmpty);
    expect(frame1.showing, isTrue);

    var frame2 = frameViews[1];
    expect(frame2.frameItems, isEmpty);
    expect(frame2.showing, isFalse);

    var frame3 = frameViews[2];
    expect(frame3.frameItems.length, equals(1));
    expect(frame3.showing, isFalse);

    var chk = frame3.frameItems[0] as Check;
    expect(chk.checked, isTrue);
    expect(chk.label, equals('Yes or no'));
  });
  
  /// This is just a smoke test for partial update.  More testing will be done outside of unit tests.
  test('Simple partial update of a command.', () {
    final model = PrimitiveModel(nullEventHandler);

    model.updateFromCbor(buildSampleFullUpdate());
    model.updateFromCbor(buildSamplePartialUpdate());

    var group = model.backgroundPrimitives[0] as Group;
    var cmd = group.groupItems[0] as Command;

    expect(cmd.label, equals('A new label!'));
  });

  */
}
