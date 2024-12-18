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

/// Returns true if the hex color value is normalized.  It is normalized when
/// it begins with a hash sign #, is less than 9 digits total (including hash),
/// and only contains upper case hex digits.
bool isNormalizedHexColorValue(String value) {
  bool invalidDigits() {
    for (int i = 1; i < value.length; i++) {
      if (!'01234567890ABCDEF'.contains(value[i])) {
        return true;
      }
    }
    return false;
  }

  return !(value.isEmpty ||
      value.length > 9 ||
      value[0] != '#' ||
      invalidDigits());
}

/// Normalizes a hex color value according to definition describe in function
/// isNormalizedHexColorValue.
String normalizeHexColorValue(String value) {
  var value2 = value.trim().toUpperCase();
  return (value2.isEmpty || value2[0] != '#') ? '#$value2' : value2;
}

/// Canonizes an assumed-to-be normalized hex color value.  Canonized form
/// is a 9 character string starting with a hash sign, then Alpha, Red, Green,
/// and Blue components with 2 hex digits each.
String canonizeHexColorValue(String normalizedValue) {
  assert(isNormalizedHexColorValue(normalizedValue));

  // default to 100% for alpha and zero for RGB
  String alpha = 'FF';
  String red = '00';
  String green = '00';
  String blue = '00';

  String getComponent(int startingAt, bool twoDigits) {
    if (twoDigits) {
      return normalizedValue.substring(startingAt, startingAt + 2);
    } else {
      var digit = normalizedValue.substring(startingAt, startingAt + 1);
      return '0$digit';
    }
  }

  switch (normalizedValue.length) {
    case 2:
      red = getComponent(1, false);
    case 3:
      red = getComponent(1, true);
    case 4:
      red = getComponent(1, true);
      green = getComponent(3, false);
    case 5:
      red = getComponent(1, true);
      green = getComponent(3, true);
    case 6:
      red = getComponent(1, true);
      green = getComponent(3, true);
      blue = getComponent(5, false);
    case 7:
      red = getComponent(1, true);
      green = getComponent(3, true);
      blue = getComponent(5, true);
    case 8:
      alpha = getComponent(1, false);
      red = getComponent(2, true);
      green = getComponent(4, true);
      blue = getComponent(6, true);
    case 9:
      alpha = getComponent(1, true);
      red = getComponent(3, true);
      green = getComponent(5, true);
      blue = getComponent(7, true);
  }

  // Return the canonized form
  return '#$alpha$red$green$blue';
}
