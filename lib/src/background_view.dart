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
    var model = InheritedPrimitiveModel.of(context);

    List<pg.Primitive> backgroundItems = [];
    for (var element in model.topPrimitives) {
      if (element is pg.Frame) {
        var frame = element as pg.Frame;
        if (frame.isView) {
          continue;
        }
      }

      backgroundItems.add(element);
    }

    // TODO:  try incorporating InheritedPrimitiveModel that notifies on top-level updates

    return Scaffold(
      body: ListenableBuilder(
          listenable:
              InheritedPrimitiveModel.of(context).topLevelUpdateNotifier,
          builder: (BuildContext context, Widget? child) {
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
          }),
//      ),
    );
  }
}
