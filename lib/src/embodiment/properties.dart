import 'package:app/src/embodiment/property_help.dart';
import 'package:flutter/material.dart';

class PropertyName {
  static const allowEmptyValue = 'allowEmptyValue';
  static const animationPeriod = 'animationPeriod';
  static const backgroundColor = 'backgroundColor';
  static const borderAll = 'borderAll';
  static const borderBottom = 'borderBottom';
  static const borderColor = 'borderColor';
  static const borderLeft = 'borderLeft';
  static const borderRight = 'borderRight';
  static const borderTop = 'borderTop';
  static const bottom = 'bottom';
  static const color = 'color';
  static const displayDecimalPlaces = 'displayDecimalPlaces';
  static const displayNegativeFormat = 'displayNegativeFormat';
  static const displayThousandths = 'displayThousandths';
  static const embodiment = 'embodiment';
  static const flowDirection = 'flowDirection';
  static const fontFamily = 'fontFamily';
  static const fontSize = 'fontSize';
  static const fontStyle = 'fontStyle';
  static const fontWeight = 'fontWeight';
  static const height = 'height';
  static const horizontal = 'horizontal';
  static const horizontalAlignment = 'horizontalAlignment';
  static const horizontalTextAlignment = 'horizontalTextAlignment';
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
  static const verticalTextAlignment = 'verticalTextAlignment';
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

enum HorizontalTextAlignment { left, center, right, justify }

Set<String> _namesofHorizontalTextAlignment = {
  'left',
  'center',
  'right',
  'justify'
};

enum VerticalTextAlignment { top, middle, bottom }

Set<String> _namesofVerticalTextAlignment = {'top', 'middle', 'bottom'};

Set<String> _namesofVerticalAlignment = {'top', 'middle', 'bottom', 'expand'};

enum SnackbarBehavior { fixed, floating }

Set<String> _namesofSnackbarBehavior = {'fixed', 'floating'};

enum DisplayNegativeFormat { absolute, minusSignPrefix, parens }

Set<String> _namesofDisplayNegativeFormat = {
  'absolute',
  'minusSignPrefix',
  'parens'
};

enum FontStyle { normal, italic }

Set<String> _namesofFontStyle = {'normal', 'italic'};

enum FontWeight { normal, bold, w1, w2, w3, w4, w5, w6, w7, w8, w9 }

Set<String> _namesofFontWeight = {
  'normal',
  'bold',
  'w1',
  'w2',
  'w3',
  'w4',
  'w5',
  'w6',
  'w7',
  'w8',
  'w9'
};

enum LayoutMethod { flow, positioned }

Set<String> _namesofLayoutMethod = {'flow', 'positioned'};

// Note:  this class is temporary until we have codegen for this file.
bool _mapCommonProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.backgroundColor:
      propertyMap[name] = getColorProp(value);
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
    case PropertyName.bottom:
      propertyMap[name] = getNumericProp(value);
    case PropertyName.embodiment:
      propertyMap[name] = getStringProp(value);
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
    default:
      return false;
  }
  return true;
}

void _mapFrameDefaultProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.flowDirection:
      propertyMap[name] = getEnumProp<FlowDirection>(
          value, FlowDirection.values, _namesofFlowDirection);
    case PropertyName.layoutMethod:
      propertyMap[name] = getEnumProp<LayoutMethod>(
          value, LayoutMethod.values, _namesofLayoutMethod);
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

void _mapListDefaultProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.horizontal:
      propertyMap[name] = getBoolProp(value);
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

void _mapTreeDefaultProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {}
}

void _mapNumericFieldDefaultProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.allowEmptyValue:
      propertyMap[name] = getBoolProp(value);
    case PropertyName.displayDecimalPlaces:
      propertyMap[name] = getIntProp(value, -15, 15);
    case PropertyName.displayNegativeFormat:
      propertyMap[name] = getEnumProp<DisplayNegativeFormat>(
          value, DisplayNegativeFormat.values, _namesofDisplayNegativeFormat);
    case PropertyName.displayThousandths:
      propertyMap[name] = getBoolProp(value);
    case PropertyName.minValue:
      propertyMap[name] = getNumericProp(value);
    case PropertyName.maxValue:
      propertyMap[name] = getNumericProp(value);
    case PropertyName.popupChoices:
      propertyMap[name] = getStringArrayProp(value);
  }
}

void _mapNumericFieldColorProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.allowEmptyValue:
      propertyMap[name] = getBoolProp(value);
  }
}

void _mapTextDefaultProperty(
    Map<String, dynamic> propertyMap, String name, dynamic value) {
  switch (name) {
    case PropertyName.color:
      propertyMap[name] = getColorProp(value);
    case PropertyName.fontFamily:
      propertyMap[name] = getStringProp(value);
    case PropertyName.fontSize:
      propertyMap[name] = getNumericProp(value);
    case PropertyName.fontStyle:
      propertyMap[name] =
          getEnumProp<FontStyle>(value, FontStyle.values, _namesofFontStyle);
    case PropertyName.fontWeight:
      propertyMap[name] =
          getEnumProp<FontWeight>(value, FontWeight.values, _namesofFontWeight);
    case PropertyName.horizontalTextAlignment:
      propertyMap[name] = getEnumProp<HorizontalTextAlignment>(value,
          HorizontalTextAlignment.values, _namesofHorizontalTextAlignment);
    case PropertyName.verticalTextAlignment:
      propertyMap[name] = getEnumProp<VerticalTextAlignment>(
          value, VerticalTextAlignment.values, _namesofVerticalTextAlignment);
  }
}

class Properties {
  Properties({Properties? initialProperties}) : areCommonProps = false {
    if (initialProperties != null) {
      var initialPropertyMap = initialProperties.propertyMap;
      if (initialPropertyMap != null) {
        propertyMap = Map<String, dynamic>.of(initialPropertyMap);
        areCommonProps = initialProperties.areCommonProps;
      }
    }
  }

  bool areCommonProps;
  Map<String, dynamic>? propertyMap;
}

mixin CommonPropertyAccess on Properties {
  bool? _isPadding;
  bool? _isBorder;
  bool? _isMargin;
  bool? _isSizing;
  bool? _isPositioning;

  bool get isPadding {
    _isPadding ??= (paddingAll != null ||
        paddingLeft != null ||
        paddingRight != null ||
        paddingTop != null ||
        paddingBottom != null);

    return _isPadding!;
  }

  bool get isBorder {
    _isBorder ??= (borderAll != null ||
        borderLeft != null ||
        borderRight != null ||
        borderTop != null ||
        borderBottom != null);

    return _isBorder!;
  }

  bool get isMargin {
    _isMargin = _isMargin ??= (marginAll != null ||
        marginLeft != null ||
        marginRight != null ||
        marginTop != null ||
        marginBottom != null);
    return _isMargin!;
  }

  bool get isSizing {
    _isSizing ??= (width != null || height != null);
    return _isSizing!;
  }

  bool get isPositioning {
    _isPositioning ??=
        (left != null || right != null || top != null || bottom != null);
    return _isPositioning!;
  }

  Color? get backgroundColor =>
      _getColorT(propertyMap, PropertyName.backgroundColor);
  double? get borderAll => _getDoubleT(propertyMap, PropertyName.borderAll);
  double? get borderBottom =>
      _getDoubleT(propertyMap, PropertyName.borderBottom);
  Color? get borderColor => _getColorT(propertyMap, PropertyName.borderColor);
  double? get borderLeft => _getDoubleT(propertyMap, PropertyName.borderLeft);
  double? get borderRight => _getDoubleT(propertyMap, PropertyName.borderRight);
  double? get borderTop => _getDoubleT(propertyMap, PropertyName.borderTop);
  double? get bottom => _getDoubleT(propertyMap, PropertyName.bottom);
  String? get embodiment => _getStringT(propertyMap, PropertyName.embodiment);
  double? get height => _getDoubleT(propertyMap, PropertyName.height);
  HorizontalAlignment get horizontalAlignment => _getEnumT<HorizontalAlignment>(
      propertyMap, HorizontalAlignment.left, PropertyName.horizontalAlignment);
  double? get left => _getDoubleT(propertyMap, PropertyName.left);
  double? get marginAll => _getDoubleT(propertyMap, PropertyName.marginAll);
  double? get marginBottom =>
      _getDoubleT(propertyMap, PropertyName.marginBottom);
  double? get marginLeft => _getDoubleT(propertyMap, PropertyName.marginLeft);
  double? get marginRight => _getDoubleT(propertyMap, PropertyName.marginRight);
  double? get marginTop => _getDoubleT(propertyMap, PropertyName.marginTop);
  double? get paddingAll => _getDoubleT(propertyMap, PropertyName.paddingAll);
  double? get paddingBottom =>
      _getDoubleT(propertyMap, PropertyName.paddingBottom);
  double? get paddingLeft => _getDoubleT(propertyMap, PropertyName.paddingLeft);
  double? get paddingRight =>
      _getDoubleT(propertyMap, PropertyName.paddingRight);
  double? get paddingTop => _getDoubleT(propertyMap, PropertyName.paddingTop);
  double? get right => _getDoubleT(propertyMap, PropertyName.right);
  double? get top => _getDoubleT(propertyMap, PropertyName.top);
  VerticalAlignment get verticalAlignment => _getEnumT<VerticalAlignment>(
      propertyMap, VerticalAlignment.middle, PropertyName.verticalAlignment);
  double? get width => _getDoubleT(propertyMap, PropertyName.width);
}

mixin FrameDefaultPropertyAccess on Properties {
  FlowDirection get flowDirection => _getEnumT<FlowDirection>(
      propertyMap, FlowDirection.topToBottom, PropertyName.flowDirection);
  LayoutMethod get layoutMethod => _getEnumT<LayoutMethod>(
      propertyMap, LayoutMethod.flow, PropertyName.layoutMethod);
}

mixin FrameSnackbarPropertyAccess on Properties {
  SnackbarBehavior get snackbarBehavior => _getEnumT<SnackbarBehavior>(
      propertyMap, SnackbarBehavior.fixed, PropertyName.snackbarBehavior);
  double? get snackbarDuration =>
      _getDoubleT(propertyMap, PropertyName.snackbarDuration);
  bool get snackbarShowCloseIcon =>
      _getYesNoT(propertyMap, PropertyName.snackbarShowCloseIcon, false);
}

mixin IconDefaultPropertyAccess on Properties {
  Color? get color => _getColorT(propertyMap, PropertyName.color);
  double? get size => _getDoubleT(propertyMap, PropertyName.size);
}

mixin ListDefaultPropertyAccess on Properties {
  bool get horizontal =>
      _getYesNoT(propertyMap, PropertyName.horizontal, false);
//  double? get itemHeight => _getDoubleT(_propertyMap, PropertyName.itemHeight);
//  double? get itemWidth => _getDoubleT(_propertyMap, PropertyName.itemWidth);
}

mixin ListCardPropertyAccess on Properties {
  bool get horizontal =>
      _getYesNoT(propertyMap, PropertyName.horizontal, false);
}

mixin ListPropertyPropertyAccess on Properties {
  bool get horizontal =>
      _getYesNoT(propertyMap, PropertyName.horizontal, false);
}

mixin ListTabbedPropertyAccess on Properties {
  int get animationPeriod =>
      _getIntT(propertyMap, PropertyName.animationPeriod, 0);
  double? get tabHeight => _getDoubleT(propertyMap, PropertyName.tabHeight);
}

mixin TreeDefaultPropertyAccess on Properties {}

mixin NumericFieldDefaultPropertyAccess on Properties {
  bool get allowEmptyValue =>
      _getYesNoT(propertyMap, PropertyName.allowEmptyValue, false);
  int get displayDecimalPlaces =>
      _getIntT(propertyMap, PropertyName.displayDecimalPlaces, -15);
  DisplayNegativeFormat get displayNegativeFormat => _getEnumT(
      propertyMap,
      DisplayNegativeFormat.minusSignPrefix,
      PropertyName.displayNegativeFormat);
  bool get displayThousandths =>
      _getYesNoT(propertyMap, PropertyName.displayThousandths, false);
  double? get maxValue => _getDoubleT(propertyMap, PropertyName.maxValue);
  double? get minValue => _getDoubleT(propertyMap, PropertyName.minValue);
  List<String>? get popupChoices =>
      _getStringArrayT(propertyMap, PropertyName.popupChoices);
}

mixin NumericFieldColorPropertyAccess on Properties {
  bool get allowEmptyValue =>
      _getYesNoT(propertyMap, PropertyName.allowEmptyValue, false);
}

mixin TextDefaultPropertyAccess on Properties {
  Color? get color => _getColorT(propertyMap, PropertyName.color);
  String? get fontFamily => _getStringT(propertyMap, PropertyName.fontFamily);
  double? get fontSize => _getDoubleT(propertyMap, PropertyName.fontSize);
  FontStyle get fontStyle => _getEnumT<FontStyle>(
      propertyMap, FontStyle.normal, PropertyName.fontStyle);
  FontWeight get fontWeight => _getEnumT<FontWeight>(
      propertyMap, FontWeight.normal, PropertyName.fontWeight);
  HorizontalTextAlignment get horizontalTextAlignment => _getEnumT(propertyMap,
      HorizontalTextAlignment.center, PropertyName.horizontalTextAlignment);
  VerticalTextAlignment get verticalTextAlignment => _getEnumT(propertyMap,
      VerticalTextAlignment.middle, PropertyName.verticalTextAlignment);
}

class NothingProperties extends Properties {
  NothingProperties.fromMap(Map<String, dynamic>? embodimentMap,
      {super.initialProperties}) {
    return;
  }
}

class CommonProperties extends Properties with CommonPropertyAccess {
  CommonProperties.fromMap(Map<String, dynamic>? embodimentMap,
      {super.initialProperties}) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      return;
    }
    propertyMap ??= {};
    for (var kv in embodimentMap.entries) {
      areCommonProps |= _mapCommonProperty(propertyMap!, kv.key, kv.value);
    }
  }
}

class FrameDefaultProperties extends Properties
    with CommonPropertyAccess, FrameDefaultPropertyAccess {
  FrameDefaultProperties.fromMap(Map<String, dynamic>? embodimentMap,
      {super.initialProperties}) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      return;
    }
    propertyMap ??= {};
    for (var kv in embodimentMap.entries) {
      areCommonProps |= _mapCommonProperty(propertyMap!, kv.key, kv.value);
      _mapFrameDefaultProperty(propertyMap!, kv.key, kv.value);
    }
  }
}

class FrameSnackbarProperties extends Properties
    with CommonPropertyAccess, FrameSnackbarPropertyAccess {
  FrameSnackbarProperties.fromMap(Map<String, dynamic>? embodimentMap,
      {super.initialProperties}) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      return;
    }
    propertyMap ??= {};
    for (var kv in embodimentMap.entries) {
      areCommonProps |= _mapCommonProperty(propertyMap!, kv.key, kv.value);
      _mapFrameSnackbarProperty(propertyMap!, kv.key, kv.value);
    }
  }
}

class IconDefaultProperties extends Properties
    with CommonPropertyAccess, IconDefaultPropertyAccess {
  IconDefaultProperties.fromMap(Map<String, dynamic>? embodimentMap,
      {super.initialProperties}) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      return;
    }
    propertyMap ??= {};
    for (var kv in embodimentMap.entries) {
      areCommonProps |= _mapCommonProperty(propertyMap!, kv.key, kv.value);
      _mapIconDefaultProperty(propertyMap!, kv.key, kv.value);
    }
  }
}

class ListDefaultProperties extends Properties
    with CommonPropertyAccess, ListDefaultPropertyAccess {
  ListDefaultProperties.fromMap(Map<String, dynamic>? embodimentMap,
      {super.initialProperties}) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      return;
    }
    propertyMap ??= {};
    for (var kv in embodimentMap.entries) {
      areCommonProps |= _mapCommonProperty(propertyMap!, kv.key, kv.value);
      _mapListDefaultProperty(propertyMap!, kv.key, kv.value);
    }
  }
}

// ALSO GENERATES DUPLICATES ListCardProperties, ListPropertyProperties
class ListTabbedProperties extends Properties
    with CommonPropertyAccess, ListTabbedPropertyAccess {
  ListTabbedProperties.fromMap(Map<String, dynamic>? embodimentMap,
      {super.initialProperties}) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      return;
    }
    propertyMap ??= {};
    for (var kv in embodimentMap.entries) {
      areCommonProps |= _mapCommonProperty(propertyMap!, kv.key, kv.value);
      _mapListTabbedProperty(propertyMap!, kv.key, kv.value);
    }
  }
}

class TreeDefaultProperties extends Properties
    with CommonPropertyAccess, TreeDefaultPropertyAccess {
  TreeDefaultProperties.fromMap(Map<String, dynamic>? embodimentMap,
      {super.initialProperties}) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      return;
    }
    propertyMap ??= {};
    for (var kv in embodimentMap.entries) {
      areCommonProps |= _mapCommonProperty(propertyMap!, kv.key, kv.value);
      _mapTreeDefaultProperty(propertyMap!, kv.key, kv.value);
    }
  }
}

class NumericFieldDefaultProperties extends Properties
    with CommonPropertyAccess, NumericFieldDefaultPropertyAccess {
  NumericFieldDefaultProperties.fromMap(Map<String, dynamic>? embodimentMap,
      {super.initialProperties}) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      return;
    }
    propertyMap ??= {};
    for (var kv in embodimentMap.entries) {
      areCommonProps |= _mapCommonProperty(propertyMap!, kv.key, kv.value);
      _mapNumericFieldDefaultProperty(propertyMap!, kv.key, kv.value);
    }
  }
}

class NumericFieldColorProperties extends Properties
    with CommonPropertyAccess, NumericFieldDefaultPropertyAccess {
  NumericFieldColorProperties.fromMap(Map<String, dynamic>? embodimentMap,
      {super.initialProperties}) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      return;
    }
    propertyMap ??= {};
    for (var kv in embodimentMap.entries) {
      areCommonProps |= _mapCommonProperty(propertyMap!, kv.key, kv.value);
      _mapNumericFieldColorProperty(propertyMap!, kv.key, kv.value);
    }
  }
}

class TextDefaultProperties extends Properties
    with CommonPropertyAccess, TextDefaultPropertyAccess {
  TextDefaultProperties.fromMap(Map<String, dynamic>? embodimentMap,
      {super.initialProperties}) {
    if (embodimentMap == null || embodimentMap.isEmpty) {
      return;
    }
    propertyMap ??= {};
    for (var kv in embodimentMap.entries) {
      areCommonProps |= _mapCommonProperty(propertyMap!, kv.key, kv.value);
      _mapTextDefaultProperty(propertyMap!, kv.key, kv.value);
    }
  }
}

class EmbodimentProperty {
  static String getFromMap(Map<String, dynamic>? embodimentMap) {
    if (embodimentMap == null) {
      // Return default
      return '';
    }
    var item = embodimentMap[PropertyName.embodiment];
    if (item == null || item is! String) {
      // Return default
      return '';
    }

    return item;
  }
}
