// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/src/embodiment/embodifier.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import '../embodiment_properties/frame_embodiment_properties.dart';

class FrameEmbodiment extends StatelessWidget {
  FrameEmbodiment(
      {super.key,
      required this.frame,
      required Map<String, dynamic>? embodimentMap,
      required this.parentWidgetType})
      : embodimentProps = FrameEmbodimentProperties.fromMap(embodimentMap);
  final pg.Frame frame;
  final FrameEmbodimentProperties embodimentProps;
  final String parentWidgetType;

  // Note:  when getting around to implementing a manual layout method, take a look
  // at PositionedDirectional class and Positioned widget.

  @override
  Widget build(BuildContext context) {
    if (embodimentProps.embodiment == "snackbar") {
      // This is an error
      return const SizedBox();
    }

    var content = buildRegularContent(context);

    // Is it a top-level primitive (i.e., a view)?
    if (parentWidgetType == "<Top>") {
      content = Scaffold(
        body: Center(child: content),
      );
    }

    return content;
  }

  Widget buildRegularContent(BuildContext context) {
    late Widget content;
    late bool wrapInExpanded;

    switch (embodimentProps.flowDirection) {
      case 'left-to-right':
        content = Row(
          children: InheritedEmbodifier.of(context)
              .buildPrimitiveList(context, frame.frameItems, "Row"),
        );

        wrapInExpanded = (parentWidgetType == "Column");

      case 'top-to-bottom':
        wrapInExpanded = true;

        content = Column(
          children: InheritedEmbodifier.of(context)
              .buildPrimitiveList(context, frame.frameItems, "Column"),
        );

        wrapInExpanded = (parentWidgetType == "Row");

      default:
        // TODO:  handle this in some way - log an error, display something indicating error, and/or throw an exception
        content = const SizedBox();

        wrapInExpanded = false;
    }

    if (embodimentProps.border == 'outline') {
      content = Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3.0),
        ),
        child: content,
      );

      content = Container(
        padding: const EdgeInsets.all(10.0),
        child: content,
      );
    }

    if (wrapInExpanded) {
      content = Expanded(child: content);
    }

    // Is it a top-level primitive (i.e., a view)?
    if (parentWidgetType == "<Top>") {
      content = Scaffold(
        body: Center(child: content),
      );
    }

    return content;
  }
}
