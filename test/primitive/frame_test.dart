// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/command.dart';
import 'package:test/test.dart';
import 'package:app/primitive/frame.dart';
import 'package:app/primitive/pkey.dart';
import 'test_ctor_args.dart';
import 'test_cbor_samples.dart';

void main() {
  test('Default field settings.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = FrameImpl(args.get);

    expect(pimpl.frameItems.length, equals(0));
  });

  test('Update fields from CBOR.', () {
    var args = TestCtorArgs(cborForFrame());
    var pimpl = FrameImpl(args.get);

    expect(pimpl.frameItems.length, equals(2));
    expect(pimpl.frameItems[0].getParent(), equals(pimpl));
    expect(pimpl.frameItems[1].getParent(), equals(pimpl));
  });

  test('Locate descendant.', () {
    var args = TestCtorArgs(cborForFrame());
    var pimpl = FrameImpl(args.get);

    var pkey = PKey.empty().addIndex(0).addIndex(1);

    var desc = pimpl.locateDescendant(PKeyLocator(pkey)) as Command;
    expect(desc.label, equals("Click Here! (disable)"));
  });

  test('Is notification point.', () {
    var args = TestCtorArgs(cborEmpty());
    var pimpl = FrameImpl(args.get);

    expect(pimpl.isNotificationPoint, equals(true));
  });

  test('Implements abstract Frame class.', () {
    var args = TestCtorArgs(cborEmpty());
    Frame _ = FrameImpl(args.get);
  });
}
