// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/src/embodiment_properties/text_embodiment_properties.dart';
import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;

class TextEmbodiment extends StatelessWidget {
  TextEmbodiment(
      {super.key,
      required this.text,
      required Map<String, dynamic>? embodimentMap})
      : embodimentProps = TextEmbodimentProperties.fromMap(embodimentMap);

  final pg.Text text;
  final TextEmbodimentProperties embodimentProps;

  @override
  Widget build(BuildContext context) {
    var textChild = Text(
      text.content,
      style: embodimentProps.buildTextStyle(),
    );

    return embodimentProps.incorporatedPadding(textChild);
  }
}
