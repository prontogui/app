// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/model.dart';
import 'package:app/primitive/primitive.dart';
import 'package:app/primitive/frame.dart';
import 'package:app/embodiment/embodifier.dart';
import 'package:flutter/material.dart';

class BackgroundView extends StatelessWidget {
  const BackgroundView({super.key});

  @override
  Widget build(BuildContext context) {
    var model = InheritedPrimitiveModel.of(context);

    List<Primitive> backgroundItems = [];
    for (var element in model.topPrimitives) {
      if (element is Frame) {
        var frame = element as Frame;
        if (frame.isView) {
          continue;
        }
      }

      backgroundItems.add(element);
    }

    return Scaffold(
//      body: Center(
      body: ListenableBuilder(
          listenable:
              InheritedPrimitiveModel.of(context).topLevelUpdateNotifier,
          builder: (BuildContext context, Widget? child) {
            return Column(
              children: Embodifier.of(context)
                  .buildPrimitiveList(context, backgroundItems),
            );
          }),
//      ),
    );
  }
}
