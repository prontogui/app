// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/ctor_args.dart';
import 'package:app/primitive/pkey.dart';
import 'package:app/top_level_coordinator.dart';
import 'package:app/primitive/frame.dart';
import 'package:app/primitive/primitive.dart';
import 'package:test/test.dart';
import './primitive/test_primitive.dart';
import 'package:cbor/cbor.dart';

void main() {
  test('Dialog sequence comparison #1', () {
    var c = testproxyCompareDialogSequences([0, 1], [0, 1, 2]);
    expect(c.keeping, equals([0, 1]));
  });

  test('Dialog sequence comparison #2', () {
    var c = testproxyCompareDialogSequences([0, 1], [2, 1, 4]);
    expect(c.keeping, equals([]));
    expect(c.adding, equals([2, 1, 4]));
  });

  test('Dialog sequence comparison #3', () {
    var c = testproxyCompareDialogSequences([], [2, 1, 4]);
    expect(c.keeping, equals([]));
    expect(c.adding, equals([2, 1, 4]));
  });

  test('Dialog sequence comparison #4', () {
    var c = testproxyCompareDialogSequences([3, 7, 8], [2, 1, 4]);
    expect(c.keeping, equals([]));
    expect(c.adding, equals([2, 1, 4]));
  });

  test('Dialog sequence comparison #5', () {
    var c = testproxyCompareDialogSequences([1, 3, 9], [1, 1, 4]);
    expect(c.keeping, equals([1]));
    expect(c.adding, equals([1, 4]));
  });

  test('Dialog sequence comparison #6', () {
    var c = testproxyCompareDialogSequences([1, 3, 9], []);
    expect(c.keeping, equals([]));
    expect(c.adding, equals([]));
  });

  test('Analyze showings #1', () {
    var f1 = TestFrame(false, 'full-view');
    var f2 = TestFrame(false, 'full-view');
    var f3 = TestFrame(true, 'full-view');

    var sa = testproxyAnalyzeShowings([f1, f2, f3]);

    expect(sa.showing, equals(2));
    expect(sa.dlglist, isEmpty);
  });

  test('Analyze showings #2', () {
    var f1 = TestFrame(false, 'other');
    var f2 = TestFrame(false, 'other');
    var f3 = TestFrame(true, 'other');
    var f4 = TestFrame(true, 'dialog-view');
    var f5 = TestFrame(false, 'dialog-view');
    var f6 = TestFrame(true, 'dialog-view');

    var sa = testproxyAnalyzeShowings([f1, f2, f3, f4, f5, f6]);

    expect(sa.showing, equals(-1));
    expect(sa.dlglist, equals([3, 5]));
  });

  test('Analyze showings #3', () {
    var f1 = TestFrame(false, 'other');
    var f2 = TestFrame(false, 'other');
    var f3 = TestFrame(true, 'other');
    var f4 = TestFrame(false, 'dialog-view');
    var f5 = TestFrame(false, 'dialog-view');
    var f6 = TestFrame(false, 'dialog-view');

    var sa = testproxyAnalyzeShowings([f1, f2, f3, f4, f5, f6]);

    expect(sa.showing, equals(-1));
    expect(sa.dlglist, isEmpty);
  });

  test('Analyze showings #4', () {
    var f1 = TestFrame(false, 'other');
    var f2 = TestFrame(true, 'full-view');
    var f3 = TestFrame(true, 'other');
    var f4 = TestFrame(false, 'dialog-view');
    var f5 = TestFrame(true, 'dialog-view');
    var f6 = TestFrame(false, 'dialog-view');

    var sa = testproxyAnalyzeShowings([f1, f2, f3, f4, f5, f6]);

    expect(sa.showing, equals(1));
    expect(sa.dlglist, equals([4]));
  });
}

Primitive TestFrame(bool showing, String embodiment) {
  var testParent = TestPrimitive();
  void testHandler(EventType, PKey, CborMap) {}
  var cbor = CborMap({
    CborString('Embodiment'): CborString(embodiment),
    CborString('Showing'): CborBool(showing),
    CborString('FrameItems'): CborList([]),
  });
  var args = CtorArgs.once(testParent, testHandler, cbor, PKey.empty());
  return FrameImpl(args);
}
