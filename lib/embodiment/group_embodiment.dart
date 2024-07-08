// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/embodiment/embodifier.dart';
import 'package:app/primitive/group.dart';
import 'package:flutter/material.dart';

class GroupEmbodiment extends StatelessWidget {
  const GroupEmbodiment({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          // This is very elegant but we'll see how it performs.  Documentation says
          // stuff in .of method should work in O(1) time with a "small constant".
          // An alternative approach is to pass Embodifier into constructor of each
          // embodiment.
          Embodifier.of(context).buildPrimitiveList(context, group.groupItems),
    );
  }
}
