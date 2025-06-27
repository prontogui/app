import 'package:flutter/material.dart';

String getEnumStringProp(
    dynamic value, String defaultValue, Set<String> validEnums) {
  if (value is! String) {
    throw Exception('embodiment property value is not a string');
  }

  if (!validEnums.contains(value)) {
    throw Exception('invalid setting for embodiment property');
  }
  return value;
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
  if (value is! String) {
    return null;
  }
  return value;
}

List<String>? getStringArrayProp(dynamic value) {
  if (value is! List) {
    return null;
  }

  try {
    return List<String>.from(value);
  } catch (e) {
    return null;
  }
}

List<Map<String, dynamic>>? getMapArrayProp(dynamic value) {
  if (value is! List || value.isEmpty || value[0] is! Map) {
    return null;
  }

  try {
    return List<Map<String, dynamic>>.from(value);
  } catch (e) {
    return null;
  }
}

Color? getColorProp(dynamic value) {
  if (value is! String) {
    return null;
  }

  var colorSpec = value.toLowerCase();

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
  
  late double n;

  if (value is int) {
    n = value.toDouble();
  } else if (value is double) {
    n = value;
  } else if (value is String) {
    var parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      throw Exception('embodiment property value is invalid - cannot parse as a number');
    }
    n = parsedValue;
  } else {
    throw Exception('embodiment property value is not a number');
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

  late int n;

  if (value is int) {
    n = value;
  } else if (value is String) {
    var parsedValue = int.tryParse(value);
    if (parsedValue == null) {
      throw Exception('embodiment property value is invalid - cannot parse as an integer');
    }
    n = parsedValue;
  } else {
    throw Exception('embodiment property value is not an integer');
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

  late bool b;

  if (value is bool) {
    b = value;
  } else if (value is String) {
    var parsedValue = bool.tryParse(value);
    if (parsedValue == null) {
      throw Exception('embodiment property value is invalid - cannot parse as a boolean');
    }
    b = parsedValue;
  } else {
    throw Exception('embodiment property value is not a string');
  }

  return b;
}
