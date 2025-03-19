import 'package:flutter/material.dart';

String getEnumStringProp(
    dynamic value, String defaultValue, Set<String> validEnums) {
  if (value.runtimeType != String) {
    throw Exception('embodiment property value is not a string');
  }
  var stringValue = value as String;
  if (!validEnums.contains(stringValue)) {
    throw Exception('invalid setting for embodiment property');
  }
  return stringValue;
}

T? getEnumProp<T extends Enum>(
    dynamic value, List<T> enumValues, Set<String> enumNames) {
  var enumString = getEnumStringProp(value, '', enumNames);
  if (enumString.isEmpty) {
    return null;
  }
  return enumValues.byName(enumString);
}

String? getStringProp(dynamic value) {
  if (value.runtimeType != String) {
    return null;
  }
  return value as String;
}

List<String>? getStringArrayProp(dynamic value) {
  if (value.runtimeType != List) {
    return null;
  }

  try {
    return List<String>.from(value);
  } catch (e) {
    return null;
  }
}

Color? getColorProp(dynamic value) {
  if (value.runtimeType != String) {
    return null;
  }

  var colorSpec = (value as String).toLowerCase();

  // Named color with optional swatch index?

  // Color specified as ARGB (e.g. "#FFFFFFFF")?
  if (colorSpec.startsWith("#") && colorSpec.length == 9) {
    var a = int.tryParse(colorSpec.substring(1, 3), radix: 16);
    var r = int.tryParse(colorSpec.substring(3, 5), radix: 16);
    var g = int.tryParse(colorSpec.substring(5, 7), radix: 16);
    var b = int.tryParse(colorSpec.substring(7), radix: 16);
    if (a == null || r == null || g == null || b == null) {
      return null;
    }

    return Color.fromARGB(a, r, g, b);
  }

  throw Exception('invalid property value');
}

double? getNumericProp(dynamic value,
    [double minValue = double.negativeInfinity,
    double maxValue = double.infinity]) {
  if (value.runtimeType != String) {
    return null;
  }

  var numericString = value as String;

  var n = double.tryParse(numericString);
  if (n == null) {
    return null;
  }
  if (n < minValue) {
    return minValue;
  }
  if (n > maxValue) {
    return maxValue;
  }
  return n;
}

int? getIntProp(dynamic value, int minValue, int maxValue) {
  if (value.runtimeType != String) {
    throw Exception('embodiment property value is not a string');
  }

  var numericString = value as String;

  var n = int.tryParse(numericString);
  if (n == null) {
    return null;
  }
  if (n < minValue) {
    return minValue;
  }
  if (n > maxValue) {
    return maxValue;
  }
  return n;
}

bool? getBoolProp(dynamic value) {
  if (value.runtimeType != String) {
    throw Exception('embodiment property value is not a string');
  }

  var boolString = value as String;

  var b = bool.tryParse(boolString);
  if (b == null) {
    return null;
  }

  return b;
}
