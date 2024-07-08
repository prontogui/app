// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/embodiment/embodifier.dart';
import 'package:app/primitive/frame.dart';
import 'package:flutter/material.dart';
import '../embodiment_properties/frame_embodiment_properties.dart';

class FrameEmbodiment extends StatelessWidget {
  FrameEmbodiment(
      {super.key,
      required this.frame,
      required Map<String, dynamic>? embodimentMap})
      : embodimentProps = FrameEmbodimentProperties.fromMap(embodimentMap);

  final Frame frame;
  final FrameEmbodimentProperties embodimentProps;

  // Note:  when getting around to implementing a manual layout method, take a look
  // at PositionedDirectional class and Positioned widget.

  @override
  Widget build(BuildContext context) {
    late Widget childContent;

    switch (embodimentProps.flowDirection) {
      case 'left-to-right':
        childContent = Row(
          children:
              // This is very elegant but we'll see how it performs.  Documentation says
              // stuff in .of method should work in O(1) time with a "small constant".
              // An alternative approach is to pass Embodifier into constructor of each
              // embodiment.
              Embodifier.of(context)
                  .buildPrimitiveList(context, frame.frameItems),
        );
      case 'top-to-bottom':
        childContent = Column(
          children: Embodifier.of(context)
              .buildPrimitiveList(context, frame.frameItems),
        );
      default:
        // TODO:  handle this in some way - log an error, display something indicating error, and/or throw an exception
        childContent = const SizedBox();
    }

    if (embodimentProps.embodiment == "other") {
      return childContent;
    } else {
      return Scaffold(
        body: Center(child: childContent),
      );
    }
  }
}
