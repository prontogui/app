// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
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

String getStringProp(Map<String, dynamic>? embodimentMap, String propertyName,
    String defaultValue) {
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
  return value as String;
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

  // Color specified as ARGB (e.g. "0xFFFFFFFF")?
  if (colorSpec.startsWith("0x") && colorSpec.length == 10) {
    var a = int.tryParse(colorSpec.substring(2, 4), radix: 16);
    var r = int.tryParse(colorSpec.substring(4, 6), radix: 16);
    var g = int.tryParse(colorSpec.substring(6, 8), radix: 16);
    var b = int.tryParse(colorSpec.substring(8), radix: 16);
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

FontStyle? getFontStyle(Map<String, dynamic>? embodimentMap) {
  if (embodimentMap == null) {
    return null;
  }
  var value = embodimentMap['fontStyle'];
  if (value == null) {
    return null;
  }
  if (value.runtimeType != String) {
    throw Exception('embodiment property value for fontStyle is not a string');
  }

  var fontStyleSpec = (value as String).toLowerCase();

  switch (fontStyleSpec) {
    case '':
    case 'normal':
      return FontStyle.normal;
    case 'italic':
      return FontStyle.italic;
  }

  throw Exception('invalid property value for fontStyle');
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

int? getIntProp(Map<String, dynamic>? embodimentMap, String propertyName,
    int minValue, int maxValue) {
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

  var n = int.tryParse(numericString);
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

int getIntPropOrDefault(Map<String, dynamic>? embodimentMap,
    String propertyName, int minValue, int maxValue, int defaultValue) {
  var n = getIntProp(embodimentMap, propertyName, minValue, maxValue);

  if (n == null) {
    return defaultValue;
  }

  return n;
}

bool getBoolPropOrDefault(Map<String, dynamic>? embodimentMap,
    String propertyName, bool defaultValue) {
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

  var boolString = value as String;

  var b = bool.tryParse(boolString);
  if (b == null) {
    return defaultValue;
  }

  return b;
}

SnackBarBehavior? getSnackBarBehavior(
    Map<String, dynamic>? embodimentMap, String propertyName) {
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

  var snackBarBehaviorSpec = (value as String).toLowerCase();

  switch (snackBarBehaviorSpec) {
    case 'fixed':
      return SnackBarBehavior.fixed;
    case 'floating':
      return SnackBarBehavior.floating;
  }

  throw Exception('invalid property value for $propertyName');
}
