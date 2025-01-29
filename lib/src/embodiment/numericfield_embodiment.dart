// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'embodiment_help.dart';
import 'embodiment_manifest.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import '../widgets/color_field.dart';
import '../widgets/numeric_field.dart';
import 'dart:core';
import 'embodiment_args.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('NumericField', [
    EmbodimentManifestEntry('default', DefaultNumericFieldEmbodiment.fromArgs),
    EmbodimentManifestEntry(
        'font-size', FontSizeNumericFieldEmbodiment.fromArgs),
    EmbodimentManifestEntry('color', ColorNumericFieldEmbodiment.fromArgs)
  ]);
}

class DefaultNumericFieldEmbodimentProperties with CommonProperties {
  int? displayDecimalPlaces;
  double? minValue;
  double? maxValue;
  NegativeDisplayFormat? displayNegativeFormat;
  bool? displayThousandths;
  List<String>? popupChoices;

  DefaultNumericFieldEmbodimentProperties.fromMap(
      Map<String, dynamic>? embodimentMap) {
    super.fromMap(embodimentMap);

    displayDecimalPlaces =
        getIntProp(embodimentMap, 'displayDecimalPlaces', -20, 20);
    minValue = getNumericProp(
        embodimentMap, 'minValue', double.negativeInfinity, double.infinity);
    maxValue = getNumericProp(
        embodimentMap, 'maxValue', double.negativeInfinity, double.infinity);
    displayNegativeFormat = getEnumProp<NegativeDisplayFormat>(embodimentMap,
        'displayNegativeFormat', null, NegativeDisplayFormat.values);
    displayThousandths =
        getBoolPropOrDefault(embodimentMap, 'displayThousandths', false);
    popupChoices = getStringArrayProp(embodimentMap, 'popupChoices');
  }
}

class DefaultNumericFieldEmbodiment extends StatelessWidget {
  DefaultNumericFieldEmbodiment.fromArgs(this.args, {super.key})
      : numfield = args.primitive as pg.NumericField,
        props = DefaultNumericFieldEmbodimentProperties.fromMap(
            args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.NumericField numfield;
  final DefaultNumericFieldEmbodimentProperties props;

  @override
  Widget build(BuildContext context) {
    var field = NumericField(
        initialValue: numfield.numericEntry,
        displayDecimalPlaces: props.displayDecimalPlaces,
        displayThousandths: props.displayThousandths,
        displayNegativeFormat: props.displayNegativeFormat,
        minValue: props.minValue,
        maxValue: props.maxValue,
        popupChoices: props.popupChoices,
        onSubmitted: (value) {
          numfield.numericEntry = value;
        });

    if (parentWidgetType == "Row" || parentWidgetType == "Column") {
      return Flexible(
        child: field,
      );
    }

    return field;
  }
}

class FontSizeNumericFielEmbodimentProperties with CommonProperties {
  FontSizeNumericFielEmbodimentProperties.fromMap(
      Map<String, dynamic>? embodimentMap) {
    super.fromMap(embodimentMap);
  }
}

class FontSizeNumericFieldEmbodiment extends StatelessWidget {
  FontSizeNumericFieldEmbodiment.fromArgs(this.args, {super.key})
      : numfield = args.primitive as pg.NumericField,
        props = FontSizeNumericFielEmbodimentProperties.fromMap(
            args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.NumericField numfield;
  final FontSizeNumericFielEmbodimentProperties props;

  static const _fontChoices = [
    '8',
    '9',
    '10',
    '11',
    '12',
    '14',
    '16',
    '20',
    '24',
    '28',
    '32',
    '35',
    '40',
    '44',
    '54',
    '60',
    '68',
    '72',
    '80',
    '88',
    '96'
  ];

  @override
  Widget build(BuildContext context) {
    var content = NumericField(
      initialValue: numfield.numericEntry,
      onSubmitted: (value) {
        numfield.numericEntry = value;
      },
      displayDecimalPlaces: 1,
      minValue: 0.1,
      maxValue: 1000,
      popupChoices: _fontChoices,
      popupChooserIcon: const Icon(Icons.numbers),
    );

    return encloseWithSizingAndBounding(content, props, parentWidgetType,
        horizontalUnbounded: true, verticalUnbounded: true, useExpanded: true);
  }
}

class ColorNumericFieldEmbodimentProperties with CommonProperties {
  ColorNumericFieldEmbodimentProperties.fromMap(
      Map<String, dynamic>? embodimentMap) {
    super.fromMap(embodimentMap);
  }
}

class ColorNumericFieldEmbodiment extends StatelessWidget {
  ColorNumericFieldEmbodiment.fromArgs(this.args, {super.key})
      : numfield = args.primitive as pg.NumericField,
        props = ColorNumericFieldEmbodimentProperties.fromMap(
            args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.NumericField numfield;
  final ColorNumericFieldEmbodimentProperties props;

  @override
  Widget build(BuildContext context) {
    var field = ColorField(
        initialValue: numfield.numericEntry,
        onSubmitted: (value) {
          numfield.numericEntry = value;
        });

    if (parentWidgetType == "Row" || parentWidgetType == "Column") {
      return Flexible(
        child: field,
      );
    }

    return field;
  }
}
