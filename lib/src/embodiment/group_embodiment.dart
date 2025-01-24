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

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Group', [
    EmbodimentManifestEntry('default', GroupEmbodiment.fromArgs),
  ]);
}

class GroupEmbodiment extends StatelessWidget {
  GroupEmbodiment.fromArgs(this.args, {super.key})
      : group = args.primitive as pg.Group,
        props = GroupEmbodimentProperties.fromMap(
            args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.Group group;
  final GroupEmbodimentProperties props;

  @override
  Widget build(BuildContext context) {
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
      // TODO:  is SizedBox necessary or can we use a different widget?
      content = SizedBox(
          child: InheritedEmbodifier.of(context)
              .buildPrimitive(context, EmbodimentArgs(group.groupItems[0])));
    } else {
      content = Row(
        children:
            // This is very elegant but we'll see how it performs.  Documentation says
            // stuff in .of method should work in O(1) time with a "small constant".
            // An alternative approach is to pass Embodifier into constructor of each
            // embodiment.
            InheritedEmbodifier.of(context)
                .buildPrimitiveList(context, group.groupItems),
      );
    }

    // NEXT:  why horizontalUnbounded: false, verticalUnbounded: true???
    return encloseWithSizingAndBounding(content, props, parentWidgetType,
        horizontalUnbounded: false, verticalUnbounded: true, useShrink: true);
  }
}

class GroupEmbodimentProperties extends CommonProperties {
  GroupEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap) {
    super.fromMap(embodimentMap);
  }
}
