// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../embodifier.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'embodiment_help.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Group', [
    EmbodimentManifestEntry(
        'default', GroupDefaultEmbodiment.fromArgs, CommonProperties.fromMap),
  ]);
}

class GroupDefaultEmbodiment extends StatelessWidget {
  const GroupDefaultEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var group = args.primitive as pg.Group;

    if (group.groupItems.isEmpty || !group.visible) {
      return const SizedBox.shrink();
    }

    late Widget content;

    // Groups with only 1 item will degenerate to a SizedBox with just the item.  This
    // leads to immutable appearance of the primitive but also creates a notification
    // point at the Group level.  This can be handy to improve re-rendering performance
    // when only updating the child primitive because other children at the parent level
    // don't have to be re-rendered.  For a good example, look at the timer demo in
    // https://github.com/prontogui/goexamples
    if (group.groupItems.length == 1) {
      // TODO:  is SizedBox necessary or can we use a different widget or no widget??
      content = SizedBox(
          child: InheritedEmbodifier.of(context).buildPrimitive(
        context,
        group.groupItems[0],
      ));
    } else {
      List<pg.Primitive>? modelPrimitives;
      if (args.modelPrimitive != null) {
        var modelGroup = args.modelPrimitive as pg.Group;
        modelPrimitives = modelGroup.groupItems;
      }

      content = Row(
        children:
            // This is very elegant but we'll see how it performs.  Documentation says
            // stuff in .of method should work in O(1) time with a "small constant".
            // An alternative approach is to pass Embodifier into constructor of each
            // embodiment.
            InheritedEmbodifier.of(context).buildPrimitiveList(
                context, group.groupItems,
                modelPrimitives: modelPrimitives, horizontalUnbounded: true),
      );
    }

    return encloseWithPBMSAF(content, args, verticalUnbounded: true);
  }
}
