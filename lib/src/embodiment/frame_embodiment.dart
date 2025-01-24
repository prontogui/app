// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/src/embodiment/embodiment_help.dart';

import '../embodifier.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'common_properties.dart';
import 'embodiment_property_help.dart';
import 'snackbar_embodiment.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Frame', [
    EmbodimentManifestEntry('default', FrameEmbodiment.fromArgs),
    EmbodimentManifestEntry('full-view', FrameEmbodiment.fromArgs),
    EmbodimentManifestEntry('dialog-view', FrameEmbodiment.fromArgs),
    EmbodimentManifestEntry('snackbar', SnackBarEmbodiment.fromArgs)
  ]);
}

class FrameEmbodiment extends StatelessWidget {
  FrameEmbodiment.fromArgs(this.args, {super.key})
      : frame = args.primitive as pg.Frame,
        props = FrameEmbodimentProperties.fromMap(
            args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.Frame frame;
  final FrameEmbodimentProperties props;

  // Note:  when getting around to implementing a manual layout method, take a look
  // at PositionedDirectional class and Positioned widget.
  @override
  Widget build(BuildContext context) {
    var content = buildRegularContent(context);

    return content;
  }

  Widget buildRegularContent(BuildContext context) {
    late Widget content;
    // late bool wrapInExpanded;
    bool verticalUnbounded = false;
    bool horizontalUnbounded = false;

    switch (props.flowDirection) {
      case 'left-to-right':
        content = Row(
          children: InheritedEmbodifier.of(context)
              .buildPrimitiveList(context, frame.frameItems),
        );
        horizontalUnbounded = true;

      case 'top-to-bottom':
        content = Column(
          children: InheritedEmbodifier.of(context)
              .buildPrimitiveList(context, frame.frameItems),
        );
        verticalUnbounded = true;

      default:
        // TODO:  handle this in some way - log an error, display something indicating error, and/or throw an exception
        content = const SizedBox();
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

    content = encloseWithSizingAndBounding(content, props, parentWidgetType,
        horizontalUnbounded: horizontalUnbounded,
        verticalUnbounded: verticalUnbounded,
        useExpanded: true);

    // Is it a top-level primitive (i.e., a view)?
    if (args.parentIsTopView) {
      content = Scaffold(
        body: content,
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
    super.fromMap(embodimentMap);
  }
}
