// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'embodiment_property_help.dart';
import 'embodiment_interface.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Text', [
    EmbodimentManifestEntry('default', (args) {
      return TextEmbodiment(
          key: args.key,
          text: args.primitive as pg.Text,
          props: TextEmbodimentProperties.fromMap(args.embodimentMap));
    }),
  ]);
}

class TextEmbodiment extends StatelessWidget {
  const TextEmbodiment({super.key, required this.text, required this.props});

  final pg.Text text;
  final TextEmbodimentProperties props;

  @override
  Widget build(BuildContext context) {
    var textChild = Text(
      text.content,
      style: props.buildTextStyle(),
    );

    return props.incorporatedPadding(textChild);
  }
}

class TextEmbodimentProperties {
  //String embodiment;
  Color? color;
  Color? backgroundColor;
  String? fontFamily;
  double? fontSize;
  FontWeight? fontWeight;
  double paddingRight;
  double paddingLeft;

  //String fontStyle;

  static final Set<String> _fontFamilyChoices = {
    '',
    'Roboto',
  };

  TextStyle buildTextStyle() {
    return TextStyle(
      backgroundColor: backgroundColor,
      color: color,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
    );
  }

  Widget incorporatedPadding(Widget child) {
    if (paddingLeft != 0.0 || paddingRight != 0.0) {
      return Padding(
        padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
        child: child,
      );
    }

    return child;
  }

  /// General constructor for testing purposes.  In practice, other constructors
  /// should be called instead.
  @visibleForTesting
  TextEmbodimentProperties()
      : paddingLeft = 0.0,
        paddingRight = 0.0;

  TextEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap)
      : backgroundColor = getColorProp(embodimentMap, 'backgroundColor'),
        color = getColorProp(embodimentMap, 'color'),
        fontSize = getNumericProp(embodimentMap, 'fontSize', 0.1, 100.0),
        fontFamily = getEnumStringProp(
            embodimentMap, 'fontFamily', '', _fontFamilyChoices),
        paddingLeft = getNumericPropOrDefault(embodimentMap, "paddingLeft",
            -double.infinity, double.infinity, 20.0),
        paddingRight = getNumericPropOrDefault(embodimentMap, "paddingRight",
            -double.infinity, double.infinity, 20.0),
        fontWeight = getFontWeight(embodimentMap);
}
