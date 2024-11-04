// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/src/embodiment/embodifier.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';

class GroupEmbodiment extends StatelessWidget {
  const GroupEmbodiment({super.key, required this.group});

  final pg.Group group;

  @override
  Widget build(BuildContext context) {
    if (group.groupItems.isEmpty) {
      return const SizedBox();
    }

    // Groups with only 1 item will degenerate to a SizedBox with just the item.  This
    // leads to immutable appearance of the primitive but also creates a notification
    // point at the Group level.  This can be handy to improve re-rendering performance
    // when only updating the child primitive because other children at the parent level
    // don't have to be re-rendered.  For a good example, look at the timer demo in
    // https://github.com/prontogui/goexamples
    if (group.groupItems.length == 1) {
      return SizedBox(
          child: Embodifier.of(context)
              .buildPrimitive(context, group.groupItems[0], "SizedBox"));
    }

    return Row(
      children:
          // This is very elegant but we'll see how it performs.  Documentation says
          // stuff in .of method should work in O(1) time with a "small constant".
          // An alternative approach is to pass Embodifier into constructor of each
          // embodiment.
          Embodifier.of(context)
              .buildPrimitiveList(context, group.groupItems, "Row"),
    );
  }
}
