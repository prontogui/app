// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/embodiment_properties/text_embodiment_properties.dart';
import 'package:app/primitive/text.dart' as pri;
import 'package:flutter/material.dart';

class TextEmbodiment extends StatelessWidget {
  TextEmbodiment(
      {super.key,
      required this.text,
      required Map<String, dynamic>? embodimentMap})
      : embodimentProps = TextEmbodimentProperties.fromMap(embodimentMap);

  final pri.Text text;
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
