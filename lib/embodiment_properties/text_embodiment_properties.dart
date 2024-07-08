// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'embodiment_property_help.dart';
import 'package:google_fonts/google_fonts.dart';

class TextEmbodimentProperties {
  //String embodiment;
  Color? color;
  Color? backgroundColor;
  String? fontFamily;
  double? fontSize;
  double paddingRight;
  double paddingLeft;

  //String fontStyle;

/*
  static final Set<String> _embodimentChoices = {
    'regular',
    'full-view',
    'dialog-view'
  };
*/

//  static final Set<String> _colorChoices = {'red', 'blue', 'green'};

  static final Set<String> _fontFamilyChoices = {
    '',
    'Roboto',
  };

/*
  static final Set<String> _fontStyleChoices = {
    'left-to-right',
    'top-to-bottom'
  };
*/

  TextStyle buildTextStyle() {
    return TextStyle(
        backgroundColor: backgroundColor,
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily);
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
            -double.infinity, double.infinity, 20.0);
}
