// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:app/src/embodiment/embodifier.dart';
import 'package:flutter/material.dart';
import 'inherited_primitive_model.dart';

class BackgroundView extends StatelessWidget {
  const BackgroundView({super.key});

  @override
  Widget build(BuildContext context) {
    var embodifier = Embodifier.of(context);

    var topPrimitives = InheritedTopLevelPrimitives.of(context);

    List<pg.Primitive> backgroundItems = [];
    for (var element in topPrimitives) {
      if (element is pg.Frame) {
        // Defer to embodifier to know if this is a view-type frame
        if (embodifier.isView(element)) {
          continue;
        }
      }

      backgroundItems.add(element);
    }

    Widget buildInnerContent() {
      if (backgroundItems.isEmpty) {
        return const SizedBox();
      } else if (backgroundItems.length == 1) {
        return Center(
          child: Embodifier.of(context)
              .buildPrimitive(context, backgroundItems[0], "Center"),
        );
      } else {
        return Column(
          children: Embodifier.of(context)
              .buildPrimitiveList(context, backgroundItems, "Column"),
        );
      }
    }

    return Scaffold(body: buildInnerContent());
  }
}
