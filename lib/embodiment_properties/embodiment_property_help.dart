// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

String getEnumStringProp(Map<String, dynamic>? embodimentMap,
    String propertyName, String defaultValue, Set<String> validEnums) {
  if (embodimentMap == null) {
    return defaultValue;
  }
  var value = embodimentMap[propertyName];
  if (value == null) {
    return defaultValue;
  }
  if (value.runtimeType != String) {
    throw Exception('embodiment property value is not a string');
  }
  var stringValue = value as String;
  if (!validEnums.contains(stringValue)) {
    throw Exception('invalid setting for embodiment property');
  }
  return stringValue;
}

Color? getColorProp(Map<String, dynamic>? embodimentMap, String propertyName) {
  if (embodimentMap == null) {
    return null;
  }
  var value = embodimentMap[propertyName];
  if (value == null) {
    return null;
  }
  if (value.runtimeType != String) {
    throw Exception(
        'embodiment property value for $propertyName is not a string');
  }

  var colorSpec = (value as String).toLowerCase();

  // Named color with optional swatch index?

  // Color specified as ARGB (e.g. "argb:0xFFFFFFFF")?
  if (colorSpec.startsWith("argb:0x") && colorSpec.length == 15) {
    var a = int.tryParse(colorSpec.substring(7, 9), radix: 16);
    var r = int.tryParse(colorSpec.substring(9, 11), radix: 16);
    var g = int.tryParse(colorSpec.substring(11, 13), radix: 16);
    var b = int.tryParse(colorSpec.substring(13), radix: 16);
    if (a == null || r == null || g == null || b == null) {
      return null;
    }

    return Color.fromARGB(a, r, g, b);
  }

  throw Exception('invalid property value for $propertyName');
}

FontWeight? getFontWeight(Map<String, dynamic>? embodimentMap) {
  if (embodimentMap == null) {
    return null;
  }
  var value = embodimentMap['fontWeight'];
  if (value == null) {
    return null;
  }
  if (value.runtimeType != String) {
    throw Exception('embodiment property value for fontWeight is not a string');
  }

  var fontWeightSpec = (value as String).toLowerCase();

  switch (fontWeightSpec) {
    case 'normal':
      return FontWeight.normal;
    case 'bold':
      return FontWeight.bold;
    case 'w1':
      return FontWeight.w100;
    case 'w2':
      return FontWeight.w200;
    case 'w3':
      return FontWeight.w300;
    case 'w4':
      return FontWeight.w400;
    case 'w5':
      return FontWeight.w500;
    case 'w6':
      return FontWeight.w600;
    case 'w7':
      return FontWeight.w700;
    case 'w8':
      return FontWeight.w800;
    case 'w9':
      return FontWeight.w900;
  }

  throw Exception('invalid property value for fontWeight');
}

double? getNumericProp(Map<String, dynamic>? embodimentMap, String propertyName,
    double minValue, double maxValue) {
  if (embodimentMap == null) {
    return null;
  }
  var value = embodimentMap[propertyName];
  if (value == null) {
    return null;
  }
  if (value.runtimeType != String) {
    throw Exception('embodiment property value is not a string');
  }

  var numericString = value as String;

  var n = double.tryParse(numericString);
  if (n == null || n < minValue || n > maxValue) {
    return null;
  }

  return n;
}

double getNumericPropOrDefault(
    Map<String, dynamic>? embodimentMap,
    String propertyName,
    double minValue,
    double maxValue,
    double defaultValue) {
  var n = getNumericProp(embodimentMap, propertyName, minValue, maxValue);

  if (n == null) {
    return defaultValue;
  }

  return n;
}
