// Copyright 2025 ProntoGUI, LLC.
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
    EmbodimentManifestEntry(
        'default', TextEmbodiment.fromArgs, p.TextDefaultProperties.fromMap),
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
  const TextEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  TextStyle _buildTextStyle(p.TextDefaultProperties props) {
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
      //backgroundColor: props.backgroundColor,
      color: props.color,
      fontSize: props.fontSize,
      fontFamily: props.fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: 1.0, // needed for centering the text vertically
      leadingDistribution: TextLeadingDistribution
          .even, // needed for centering the text vertically
    );
  }

  Widget _buildFullyAlignedText(pg.Text text, p.TextDefaultProperties props) {
    late TextAlign textAlign;
    late double alignX;
    late double alignY;

    switch (props.horizontalTextAlignment) {
      case p.HorizontalTextAlignment.left:
        textAlign = TextAlign.left;
        alignX = -1.0;
        break;
      case p.HorizontalTextAlignment.center:
        textAlign = TextAlign.center;
        alignX = 0.0;
        break;
      case p.HorizontalTextAlignment.right:
        textAlign = TextAlign.right;
        alignX = 1.0;
        break;
      case p.HorizontalTextAlignment.justify:
        textAlign = TextAlign.justify;
        alignX = 0.0;
        break;
    }

    switch (props.verticalTextAlignment) {
      case p.VerticalTextAlignment.top:
        alignY = -1.0;
        break;
      case p.VerticalTextAlignment.middle:
        alignY = 0.0;
        break;
      case p.VerticalTextAlignment.bottom:
        alignY = 1.0;
        break;
    }

    return Align(
      alignment: Alignment(alignX, alignY),
      child: Text(
        text.content,
        style: _buildTextStyle(props),
        textAlign: textAlign,
      ),
    );
  }

  Widget _buildSimpleAlignedText(pg.Text text, p.TextDefaultProperties props) {
    late TextAlign textAlign;

    switch (props.horizontalTextAlignment) {
      case p.HorizontalTextAlignment.left:
        textAlign = TextAlign.left;
        break;
      case p.HorizontalTextAlignment.center:
        textAlign = TextAlign.center;
        break;
      case p.HorizontalTextAlignment.right:
        textAlign = TextAlign.right;
        break;
      case p.HorizontalTextAlignment.justify:
        textAlign = TextAlign.justify;
        break;
    }

    return Text(
      text.content,
      style: _buildTextStyle(props),
      textAlign: textAlign,
    );
  }

  @override
  Widget build(BuildContext context) {
    var text = args.primitive as pg.Text;
    var props = args.properties as p.TextDefaultProperties;

    if (args.noEnclosures) {
      return _buildSimpleAlignedText(text, props);
    }

    return encloseWithPBMSAF(_buildFullyAlignedText(text, props), args);
  }
}
