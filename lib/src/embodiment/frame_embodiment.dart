// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/src/embodiment/embodiment_help.dart';

import '../embodifier.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'snackbar_embodiment.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Frame', [
    EmbodimentManifestEntry(
        'default', FrameEmbodiment.fromArgs, FrameDefaultProperties.fromMap),
    EmbodimentManifestEntry(
        'full-view', FrameEmbodiment.fromArgs, FrameDefaultProperties.fromMap),
    EmbodimentManifestEntry('dialog-view', FrameEmbodiment.fromArgs,
        FrameDefaultProperties.fromMap),
    EmbodimentManifestEntry(
        'snackbar', SnackBarEmbodiment.fromArgs, FrameDefaultProperties.fromMap)
  ]);
}

class FrameEmbodiment extends StatelessWidget {
  FrameEmbodiment.fromArgs(this.args, {super.key})
      : frame = args.primitive as pg.Frame;

  final EmbodimentArgs args;
  final pg.Frame frame;

  // Note:  when getting around to implementing a manual layout method, take a look
  // at PositionedDirectional class and Positioned widget.

  Widget buildFlowLayout(BuildContext context, FrameDefaultProperties props) {
    late Widget content;
    bool verticalUnbounded = false;
    bool horizontalUnbounded = false;

    switch (props.flowDirection) {
      case FlowDirection.leftToRight:
        content = Row(
          children: InheritedEmbodifier.of(context).buildPrimitiveList(
              context, frame.frameItems,
              horizontalUnbounded: true),
        );
        verticalUnbounded = true;
//        horizontalUnbounded = true;

      case FlowDirection.topToBottom:
        content = Column(
          children: InheritedEmbodifier.of(context).buildPrimitiveList(
              context, frame.frameItems,
              verticalUnbounded: true),
        );
        horizontalUnbounded = true;
//        verticalUnbounded = true;
    }

    content = encloseWithPBMSAF(content, args,
        horizontalUnbounded: horizontalUnbounded,
        verticalUnbounded: verticalUnbounded);

    return content;
  }

  Widget buildPositionedLayout(BuildContext context) {
    late Widget content;

    content = Stack(
        children: InheritedEmbodifier.of(context).buildPrimitiveList(
            context, frame.frameItems,
            allowPositioned: true));

    content = encloseWithPBMSAF(content, args,
        horizontalUnbounded: true, verticalUnbounded: true);

    return content;
  }

  @override
  Widget build(BuildContext context) {
    var props = args.properties as FrameDefaultProperties;

    late Widget content;
    switch (props.layoutMethod) {
      case LayoutMethod.flow:
        content = buildFlowLayout(context, props);
      case LayoutMethod.positioned:
        content = buildPositionedLayout(context);
    }

    // Is it a top-level primitive (i.e., a view)?
    if (args.parentIsTopView) {
      content = Scaffold(
        body: content,
      );
    }

    return content;
  }
}
