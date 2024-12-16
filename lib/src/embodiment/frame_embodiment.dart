// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../embodifier.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'package:app/src/embodiment/embodiment_interface.dart';
import 'common_properties.dart';
import 'embodiment_property_help.dart';
import 'snackbar_embodiment.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Frame', [
    EmbodimentManifestEntry('default', (args) {
      return FrameEmbodiment(
        key: args.key,
        frame: args.primitive as pg.Frame,
        props: FrameEmbodimentProperties.fromMap(args.embodimentMap),
        parentWidgetType: args.parentWidgetType,
      );
    }),
    EmbodimentManifestEntry('full-view', (args) {
      return FrameEmbodiment(
        key: args.key,
        frame: args.primitive as pg.Frame,
        props: FrameEmbodimentProperties.fromMap(args.embodimentMap),
        parentWidgetType: args.parentWidgetType,
      );
    }),
    EmbodimentManifestEntry('dialog-view', (args) {
      return FrameEmbodiment(
        key: args.key,
        frame: args.primitive as pg.Frame,
        props: FrameEmbodimentProperties.fromMap(args.embodimentMap),
        parentWidgetType: args.parentWidgetType,
      );
    }),
    EmbodimentManifestEntry('snackbar', (args) {
      return SnackBarEmbodiment(
        key: args.key,
        frame: args.primitive as pg.Frame,
        props: SnackBarEmbodimentProperties.fromMap(args.embodimentMap),
      );
    })
  ]);
}

class FrameEmbodiment extends StatelessWidget {
  const FrameEmbodiment(
      {super.key,
      required this.frame,
      required this.props,
      required this.parentWidgetType});

  final pg.Frame frame;
  final FrameEmbodimentProperties props;
  final String parentWidgetType;

  // Note:  when getting around to implementing a manual layout method, take a look
  // at PositionedDirectional class and Positioned widget.

  @override
  Widget build(BuildContext context) {
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

    switch (props.flowDirection) {
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

    if (props.border == 'outline') {
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

class FrameEmbodimentProperties extends CommonProperties {
  String layoutMethod;
  String flowDirection;
  String border;

  static final Set<String> _layoutMethodChoices = {
    'flow',
  };

  static final Set<String> _flowDirectionChoices = {
    'left-to-right',
    'top-to-bottom'
  };

  static final Set<String> _borderChoices = {
    'none',
    'outline',
  };

  /// General constructor for testing purposes.  In practice, other constructors
  /// should be called instead.
  @visibleForTesting
  FrameEmbodimentProperties(
      {this.layoutMethod = "", this.flowDirection = "", this.border = ""});

  FrameEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap)
      : layoutMethod = getEnumStringProp(
            embodimentMap, 'layoutMethod', 'flow', _layoutMethodChoices),
        flowDirection = getEnumStringProp(embodimentMap, 'flowDirection',
            'top-to-bottom', _flowDirectionChoices),
        border =
            getEnumStringProp(embodimentMap, 'border', 'none', _borderChoices) {
    super.initializeFromMap(embodimentMap);
  }
}
