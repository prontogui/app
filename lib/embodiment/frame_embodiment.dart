// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/embodiment/embodifier.dart';
import 'package:app/primitive/frame.dart';
import 'package:app/primitive/primitive.dart';
import 'package:app/primitive/model.dart';
import 'package:flutter/material.dart';
import '../embodiment_properties/frame_embodiment_properties.dart';

class FrameEmbodiment extends StatelessWidget {
  FrameEmbodiment(
      {super.key,
      required this.frame,
      required Map<String, dynamic>? embodimentMap,
      required this.parentWidgetType})
      : embodimentProps = FrameEmbodimentProperties.fromMap(embodimentMap);

  final Frame frame;
  final FrameEmbodimentProperties embodimentProps;
  final String parentWidgetType;

  // Note:  when getting around to implementing a manual layout method, take a look
  // at PositionedDirectional class and Positioned widget.

  @override
  Widget build(BuildContext context) {
    late Widget childContent;

    switch (embodimentProps.flowDirection) {
      case 'left-to-right':
        var contentRow = Row(
          children:
              // This is very elegant but we'll see how it performs.  Documentation says
              // stuff in .of method should work in O(1) time with a "small constant".
              // An alternative approach is to pass Embodifier into constructor of each
              // embodiment.
              Embodifier.of(context)
                  .buildPrimitiveList(context, frame.frameItems, "Row"),
        );

        if (parentWidgetType == "Column" || parentWidgetType == "Row") {
          childContent = Flexible(child: contentRow);
        } else {
          childContent = contentRow;
        }

      case 'top-to-bottom':
        var columnContent = Column(
          //mainAxisSize: MainAxisSize.min,
          children: Embodifier.of(context)
              .buildPrimitiveList(context, frame.frameItems, "Column"),
        );

        if (parentWidgetType == "Column" || parentWidgetType == "Row") {
          childContent = Flexible(child: columnContent);
        } else {
          childContent = columnContent;
        }

      default:
        // TODO:  handle this in some way - log an error, display something indicating error, and/or throw an exception
        childContent = const SizedBox();
    }

    assert(frame is Primitive);
    var framePrimitive = frame as Primitive;

    // Is it a top-level primitive (i.e., a view)?
    if (framePrimitive.getParent() is PrimitiveModel) {
      return Scaffold(
        body: Center(child: childContent),
      );
    }

    return childContent;
  }
}
