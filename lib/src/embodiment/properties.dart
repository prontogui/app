import 'package:app/src/embodiment/property_help.dart';
import 'package:flutter/material.dart';

class PropertyName {
  static const animationPeriod = 'animationPeriod';
  static const backgroundColor = 'backgroundColor';
  static const borderAll = 'borderAll';
  static const borderBottom = 'borderBottom';
  static const borderColor = 'borderColor';
  static const borderLeft = 'borderLeft';
  static const borderRight = 'borderRight';
  static const borderTop = 'borderTop';
  static const color = 'color';
  static const displayDecimalPlaces = 'displayDecimalPlaces';
  static const displayNegativeFormat = 'displayNegativeFormat';
  static const displayThousandths = 'displayThousandths';
  static const flowDirection = 'flowDirection';
  static const fontFamily = 'fontFamily';
  static const fontSize = 'fontSize';
  static const fontStyle = 'fontStyle';
  static const fontWeight = 'fontWeight';
  static const height = 'height';
  static const horizontal = 'horizontal';
  static const horizontalAlignment = 'horizontalAlignment';
  static const itemHeight = 'itemHeight';
  static const itemWidth = 'itemWidth';
  static const layoutMethod = 'layoutMethod';
  static const left = 'left';
  static const marginAll = 'marginAll';
  static const marginBottom = 'marginBottom';
  static const marginLeft = 'marginLeft';
  static const marginRight = 'marginRight';
  static const marginTop = 'marginTop';
  static const maxValue = 'maxValue';
  static const minValue = 'minValue';
  static const paddingAll = 'paddingAll';
  static const paddingBottom = 'paddingBottom';
  static const paddingLeft = 'paddingLeft';
  static const paddingRight = 'paddingRight';
  static const paddingTop = 'paddingTop';
  static const popupChoices = 'popupChoices';
  static const right = 'right';
  static const size = 'size';
  static const snackbarBehavior = 'snackbarBehavior';
  static const snackbarDuration = 'snackbarDuration';
  static const snackbarShowCloseIcon = 'snackbarShowCloseIcon';
  static const tabHeight = 'tabHeight';
  static const top = 'top';
  static const verticalAlignment = 'verticalAlignment';
  static const width = 'width';
}

Color? _getColorT(Map<String, dynamic>? propertyMap, String propertyName) {
  if (propertyMap == null) {
    // Return default
    return null;
  }
  var cacheItem = propertyMap[propertyName];
  if (cacheItem == null) {
    // Return default
    return null;
  }
  assert(cacheItem is Color);
  return cacheItem as Color;
}

double? _getDoubleT(Map<String, dynamic>? propertyMap, String propertyName) {
  if (propertyMap == null) {
    // Return default
    return null;
  }
  var cacheItem = propertyMap[propertyName];
  if (cacheItem == null) {
    // Return default
    return null;
  }
  assert(cacheItem is double);
  return cacheItem as double;
}

bool _getYesNoT(
    Map<String, dynamic>? propertyMap, String propertyName, bool defaultValue) {
  if (propertyMap == null) {
    // Return default
    return defaultValue;
  }
  var cacheItem = propertyMap[propertyName];
  if (cacheItem == null) {
    // Return default
    return defaultValue;
  }
  assert(cacheItem is bool);
  return cacheItem as bool;
}

int _getIntT(
    Map<String, dynamic>? propertyMap, String propertyName, int defaultValue) {
  if (propertyMap == null) {
    // Return default
    return defaultValue;
  }
  var cacheItem = propertyMap[propertyName];
  if (cacheItem == null) {
    // Return default
    return defaultValue;
  }
  assert(cacheItem is int);
  return cacheItem as int;
}

String? _getStringT(Map<String, dynamic>? propertyMap, String propertyName) {
  if (propertyMap == null) {
    // Return default
    return null;
  }
  var cacheItem = propertyMap[propertyName];
  if (cacheItem == null) {
    // Return default
    return null;
  }
  assert(cacheItem is String);
  return cacheItem as String;
}

List<String>? _getStringArrayT(
    Map<String, dynamic>? propertyMap, String propertyName) {
  if (propertyMap == null) {
    // Return default
    return null;
  }
  var cacheItem = propertyMap[propertyName];
  if (cacheItem == null) {
    // Return default
    return null;
  }
  assert(cacheItem is List<String>);
  return cacheItem as List<String>;
}

T _getEnumT<T>(
    Map<String, dynamic>? propertyMap, T defaultValue, String propertyName) {
  if (propertyMap == null) {
    // Return default
    return defaultValue;
  }
  var cacheItem = propertyMap[propertyName];
  if (cacheItem == null) {
    // Return default
    return defaultValue;
  }
  assert(cacheItem is T);
  return cacheItem as T;
}

//
// Enumerations section
//

enum FlowDirection { leftToRight, topToBottom }

Set<String> _namesofFlowDirection = {'leftToRight', 'topToBottom'};

enum HorizontalAlignment { left, center, right, expand }

Set<String> _namesofHorizontalAlignment = {'left', 'center', 'right', 'expand'};

enum VerticalAlignment { top, middle, bottom, expand }

Set<String> _namesofVerticalAlignment = {'top', 'middle', 'bottom', 'expand'};

enum SnackbarBehavior { fixed, floating }

Set<String> _namesofSnackbarBehavior = {'fixed', 'floating'};

// Note:  this class is temporary until we have codegen for this file.  Codegen
// will generate each sub-class in here without a base class, at the expense of
//
void _mapCommonProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.borderAll:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.borderBottom:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.borderColor:
      propertyMap[name] = getColorProp(value);
    case PropertyName.borderLeft:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.borderRight:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.borderTop:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.height:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.horizontalAlignment:
      propertyMap[name] = getEnumProp<HorizontalAlignment>(
          value, HorizontalAlignment.values, _namesofHorizontalAlignment);
    case PropertyName.left:
      propertyMap[name] = getNumericProp(value);
    case PropertyName.marginAll:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.marginBottom:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.marginLeft:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.marginRight:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.marginTop:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.paddingAll:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.paddingBottom:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.paddingLeft:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.paddingRight:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.paddingTop:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.right:
      propertyMap[name] = getNumericProp(value);
    case PropertyName.top:
      propertyMap[name] = getNumericProp(value);
    case PropertyName.verticalAlignment:
      propertyMap[name] = getEnumProp<VerticalAlignment>(
          value, VerticalAlignment.values, _namesofVerticalAlignment);
    case PropertyName.width:
      propertyMap[name] = getNumericProp(value, 0);
  }
}

void _mapFrameDefaultProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.flowDirection:
      propertyMap[name] = getEnumProp<FlowDirection>(
          value, FlowDirection.values, _namesofFlowDirection);

    case PropertyName.displayDecimalPlaces:
      // CONSTRAINTS GO HERE...THESE NEED TO COME FROM SPEC
      propertyMap[name] = getIntProp(value, -15, 15);
    case PropertyName.displayThousandths:
      propertyMap[name] = getBoolProp(value);

    case PropertyName.popupChoices:
      propertyMap[name] = getStringArrayProp(value);
  }
}

void _mapFrameSnackbarProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.snackbarBehavior:
      propertyMap[name] = getEnumProp<SnackbarBehavior>(
          value, SnackbarBehavior.values, _namesofSnackbarBehavior);
    case PropertyName.snackbarDuration:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.snackbarShowCloseIcon:
      propertyMap[name] = getBoolProp(value);
  }
}

void _mapIconDefaultProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.color:
      propertyMap[name] = getColorProp(propertyMap);
    case PropertyName.size:
      propertyMap[name] = getNumericProp(value, 0);
  }
}

// ALSO GENERATES DUPLICATES:  _mapListCardProperty, _mapListPropertyProperty
void _mapListNormalProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.horizontal:
      propertyMap[name] = getBoolProp(value);
    case PropertyName.itemHeight:
      propertyMap[name] = getNumericProp(value, 0);
    case PropertyName.itemWidth:
      propertyMap[name] = getNumericProp(value, 0);
  }
}

void _mapListTabbedProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.animationPeriod:
      propertyMap[name] = getIntProp(value, 0, 5000);
    case PropertyName.tabHeight:
      propertyMap[name] = getNumericProp(value, 0);
  }
}

void _mapTextProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.backgroundColor:
      propertyMap[name] = getColorProp(value);
    case PropertyName.fontFamily:
      propertyMap[name] = getStringProp(value);
  }
}

class PropertyAccessBase {
  PropertyAccessBase();
  PropertyAccessBase.commonOnly(Map<String, dynamic>? embodimentMap) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      _propertyMap = null;
      return;
    }
    _propertyMap = <String, dynamic>{};
    for (var kv in embodimentMap.entries) {
      _mapCommonProperty(_propertyMap!, kv.key, kv.value);
    }
  }

  Map<String, dynamic>? _propertyMap;
}

mixin CommonPropertyAccess on PropertyAccessBase {
  double? get borderAll => _getDoubleT(_propertyMap, PropertyName.borderAll);
  double? get borderBottom =>
      _getDoubleT(_propertyMap, PropertyName.borderBottom);
  Color? get borderColor => _getColorT(_propertyMap, PropertyName.borderColor);
  double? get borderLeft => _getDoubleT(_propertyMap, PropertyName.borderLeft);
  double? get borderRight =>
      _getDoubleT(_propertyMap, PropertyName.borderRight);
  double? get borderTop => _getDoubleT(_propertyMap, PropertyName.borderTop);
  double? get height => _getDoubleT(_propertyMap, PropertyName.height);
  HorizontalAlignment get horizontalAlignment => _getEnumT<HorizontalAlignment>(
      _propertyMap, HorizontalAlignment.left, PropertyName.horizontal);
  double? get left => _getDoubleT(_propertyMap, PropertyName.left);
  double? get marginAll => _getDoubleT(_propertyMap, PropertyName.marginAll);
  double? get marginBottom =>
      _getDoubleT(_propertyMap, PropertyName.marginBottom);
  double? get marginLeft => _getDoubleT(_propertyMap, PropertyName.marginLeft);
  double? get marginRight =>
      _getDoubleT(_propertyMap, PropertyName.marginRight);
  double? get marginTop => _getDoubleT(_propertyMap, PropertyName.marginTop);
  double? get paddingAll => _getDoubleT(_propertyMap, PropertyName.paddingAll);
  double? get paddingBottom =>
      _getDoubleT(_propertyMap, PropertyName.paddingBottom);
  double? get paddingLeft =>
      _getDoubleT(_propertyMap, PropertyName.paddingLeft);
  double? get paddingRight =>
      _getDoubleT(_propertyMap, PropertyName.paddingRight);
  double? get paddingTop => _getDoubleT(_propertyMap, PropertyName.paddingTop);
  double? get right => _getDoubleT(_propertyMap, PropertyName.right);
  double? get top => _getDoubleT(_propertyMap, PropertyName.top);
  VerticalAlignment get verticalAlignment => _getEnumT<VerticalAlignment>(
      _propertyMap, VerticalAlignment.top, PropertyName.verticalAlignment);
  double? get width => _getDoubleT(_propertyMap, PropertyName.width);
}

mixin FrameDefaultPropertyAccess on PropertyAccessBase {
  FlowDirection get flowDirection => _getEnumT<FlowDirection>(
      _propertyMap, FlowDirection.leftToRight, PropertyName.flowDirection);
}

mixin FrameSnackbarPropertyAccess on PropertyAccessBase {
  SnackbarBehavior get snackbarBehavior => _getEnumT<SnackbarBehavior>(
      _propertyMap, SnackbarBehavior.fixed, PropertyName.snackbarBehavior);
  double? get snackbarDuration =>
      _getDoubleT(_propertyMap, PropertyName.snackbarDuration);
  bool get snackbarShowCloseIcon =>
      _getYesNoT(_propertyMap, PropertyName.snackbarShowCloseIcon, false);
}

mixin IconDefaultPropertyAccess on PropertyAccessBase {
  Color? get color => _getColorT(_propertyMap, PropertyName.color);
  double? get size => _getDoubleT(_propertyMap, PropertyName.size);
}

mixin ListNormalPropertyAccess on PropertyAccessBase {
  bool get horizontal =>
      _getYesNoT(_propertyMap, PropertyName.horizontal, false);
  double? get itemHeight => _getDoubleT(_propertyMap, PropertyName.itemHeight);
  double? get itemWidth => _getDoubleT(_propertyMap, PropertyName.itemWidth);
}

mixin ListCardPropertyAccess on PropertyAccessBase {
  bool get horizontal =>
      _getYesNoT(_propertyMap, PropertyName.horizontal, false);
  double? get itemHeight => _getDoubleT(_propertyMap, PropertyName.itemHeight);
  double? get itemWidth => _getDoubleT(_propertyMap, PropertyName.itemWidth);
}

mixin ListPropertyPropertyAccess on PropertyAccessBase {
  bool get horizontal =>
      _getYesNoT(_propertyMap, PropertyName.horizontal, false);
  double? get itemHeight => _getDoubleT(_propertyMap, PropertyName.itemHeight);
  double? get itemWidth => _getDoubleT(_propertyMap, PropertyName.itemWidth);
}

mixin ListTabbedPropertyAccess on PropertyAccessBase {
  int get animationPeriod =>
      _getIntT(_propertyMap, PropertyName.animationPeriod, 0);
  double? get tabHeight => _getDoubleT(_propertyMap, PropertyName.tabHeight);
}

class CommonProperties extends PropertyAccessBase with CommonPropertyAccess {
  CommonProperties.fromMap(Map<String, dynamic>? embodimentMap) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      _propertyMap = null;
      return;
    }
    _propertyMap = <String, dynamic>{};
    for (var kv in embodimentMap.entries) {
      _mapCommonProperty(_propertyMap!, kv.key, kv.value);
    }
  }
}

class FrameDefaultProperties extends PropertyAccessBase
    with CommonPropertyAccess, FrameDefaultPropertyAccess {
  FrameDefaultProperties.fromMap(Map<String, dynamic>? embodimentMap) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      _propertyMap = null;
      return;
    }
    _propertyMap = <String, dynamic>{};
    for (var kv in embodimentMap.entries) {
      _mapCommonProperty(_propertyMap!, kv.key, kv.value);
      _mapFrameDefaultProperty(_propertyMap!, kv.key, kv.value);
    }
  }
}

class FrameSnackbarProperties extends PropertyAccessBase
    with CommonPropertyAccess, FrameSnackbarPropertyAccess {
  FrameSnackbarProperties.fromMap(Map<String, dynamic>? embodimentMap) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      _propertyMap = null;
      return;
    }
    _propertyMap = <String, dynamic>{};
    for (var kv in embodimentMap.entries) {
      _mapCommonProperty(_propertyMap!, kv.key, kv.value);
      _mapFrameSnackbarProperty(_propertyMap!, kv.key, kv.value);
    }
  }
}

class IconDefaultProperties extends PropertyAccessBase
    with CommonPropertyAccess, IconDefaultPropertyAccess {
  IconDefaultProperties.fromMap(Map<String, dynamic>? embodimentMap) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      _propertyMap = null;
      return;
    }
    _propertyMap = <String, dynamic>{};
    for (var kv in embodimentMap.entries) {
      _mapCommonProperty(_propertyMap!, kv.key, kv.value);
      _mapIconDefaultProperty(_propertyMap!, kv.key, kv.value);
    }
  }
}

// ALSO GENERATES DUPLICATES ListCardProperties, ListPropertyProperties
class ListNormalProperties extends PropertyAccessBase
    with CommonPropertyAccess, ListNormalPropertyAccess {
  ListNormalProperties.fromMap(Map<String, dynamic>? embodimentMap) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      _propertyMap = null;
      return;
    }
    _propertyMap = <String, dynamic>{};
    for (var kv in embodimentMap.entries) {
      _mapCommonProperty(_propertyMap!, kv.key, kv.value);
      _mapListNormalProperty(_propertyMap!, kv.key, kv.value);
    }
  }
}

// ALSO GENERATES DUPLICATES ListCardProperties, ListPropertyProperties
class ListTabbedProperties extends PropertyAccessBase
    with CommonPropertyAccess, ListTabbedPropertyAccess {
  ListTabbedProperties.fromMap(Map<String, dynamic>? embodimentMap) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      _propertyMap = null;
      return;
    }
    _propertyMap = <String, dynamic>{};
    for (var kv in embodimentMap.entries) {
      _mapCommonProperty(_propertyMap!, kv.key, kv.value);
      _mapListTabbedProperty(_propertyMap!, kv.key, kv.value);
    }
  }
}

/*

  // DEFAULTS GO IN THESE FUNCTIONS

  Color? get backgroundColor =>
      _getColorT(_propertyMap, PropertyName.backgroundColor);

  int? get displayDecimalPlaces =>
      _getIntT(_propertyMap, PropertyName.displayDecimalPlaces, -15);

  bool get displayThousandths =>
      _getYesNoT(_propertyMap, PropertyName.displayThousandths, false);

  FlowDirection get flowDirection => _getEnumT(
      _propertyMap, FlowDirection.leftToRight, PropertyName.flowDirection);

  String? get fontFamily => _getStringT(_propertyMap, PropertyName.fontFamily);

  List<String>? get popupChoices =>
      _getStringArrayT(_propertyMap, PropertyName.popupChoices);

  double? get width => _getDoubleT(_propertyMap, PropertyName.width);
  */
