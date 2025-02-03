// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'embodiment_help.dart';
import 'properties.dart' as p;

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Text', [
    EmbodimentManifestEntry('default', TextEmbodiment.fromArgs),
  ]);
}

E2? _convertEnum<E1 extends Enum, E2 extends Enum>(E1 from, List<E2> toEnums) {
  for (var e in toEnums) {
    if (e.name == from.name) {
      return e;
    }
  }
  return null;
}

class TextEmbodiment extends StatelessWidget {
  TextEmbodiment.fromArgs(this.args, {super.key})
      : text = args.primitive as pg.Text,
        props = p.TextDefaultProperties.fromMap(
            args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.Text text;
  final p.TextDefaultProperties props;

  TextStyle _buildTextStyle() {
    late FontWeight fontWeight;
    switch (props.fontWeight) {
      case p.FontWeight.normal:
        fontWeight = FontWeight.normal;
        break;
      case p.FontWeight.bold:
        fontWeight = FontWeight.bold;
        break;
      case p.FontWeight.w1:
        fontWeight = FontWeight.w100;
        break;
      case p.FontWeight.w2:
        fontWeight = FontWeight.w200;
        break;
      case p.FontWeight.w3:
        fontWeight = FontWeight.w300;
        break;
      case p.FontWeight.w4:
        fontWeight = FontWeight.w400;
        break;
      case p.FontWeight.w5:
        fontWeight = FontWeight.w500;
        break;
      case p.FontWeight.w6:
        fontWeight = FontWeight.w600;
        break;
      case p.FontWeight.w7:
        fontWeight = FontWeight.w700;
        break;
      case p.FontWeight.w8:
        fontWeight = FontWeight.w800;
        break;
      case p.FontWeight.w9:
        fontWeight = FontWeight.w900;
        break;
    }

    var fontStyle =
        _convertEnum<p.FontStyle, FontStyle>(props.fontStyle, FontStyle.values);
    return TextStyle(
      backgroundColor: props.backgroundColor,
      color: props.color,
      fontSize: props.fontSize,
      fontFamily: props.fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    var content = Text(
      text.content,
      style: _buildTextStyle(),
    );

    return encloseWithPBMSAF(content, props, args);
  }
}
