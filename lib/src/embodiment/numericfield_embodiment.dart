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
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('NumericField', [
    EmbodimentManifestEntry('default', DefaultNumericFieldEmbodiment.fromArgs),
    EmbodimentManifestEntry(
        'font-size', FontSizeNumericFieldEmbodiment.fromArgs),
    EmbodimentManifestEntry('color', ColorNumericFieldEmbodiment.fromArgs)
  ]);
}

class DefaultNumericFieldEmbodiment extends StatelessWidget {
  DefaultNumericFieldEmbodiment.fromArgs(this.args, {super.key})
      : numfield = args.primitive as pg.NumericField,
        props = NumericFieldDefaultProperties.fromMap(
            args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.NumericField numfield;
  final NumericFieldDefaultProperties props;

  @override
  Widget build(BuildContext context) {
    late NegativeDisplayFormat displayNegativeFormat;
    switch (props.displayNegativeFormat) {
      case DisplayNegativeFormat.absolute:
        displayNegativeFormat = NegativeDisplayFormat.absolute;
      case DisplayNegativeFormat.minusSignPrefix:
        displayNegativeFormat = NegativeDisplayFormat.minusSignPrefix;
      case DisplayNegativeFormat.parens:
        displayNegativeFormat = NegativeDisplayFormat.parens;
    }

    var content = NumericField(
        initialValue: numfield.numericEntry,
        displayDecimalPlaces: props.displayDecimalPlaces,
        displayThousandths: props.displayThousandths,
        displayNegativeFormat: displayNegativeFormat,
        minValue: props.minValue,
        maxValue: props.maxValue,
        popupChoices: props.popupChoices,
        onSubmitted: (value) {
          numfield.numericEntry = value;
        });

    return encloseWithPBMSAF(content, props, args, horizontalUnbounded: true);
  }
}

class FontSizeNumericFieldEmbodiment extends StatelessWidget {
  FontSizeNumericFieldEmbodiment.fromArgs(this.args, {super.key})
      : numfield = args.primitive as pg.NumericField,
        props = CommonProperties.fromMap(args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.NumericField numfield;
  final CommonProperties props;

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

    return encloseWithPBMSAF(content, props, args, horizontalUnbounded: true);
  }
}

class ColorNumericFieldEmbodiment extends StatelessWidget {
  ColorNumericFieldEmbodiment.fromArgs(this.args, {super.key})
      : numfield = args.primitive as pg.NumericField,
        props = CommonProperties.fromMap(args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.NumericField numfield;
  final CommonProperties props;

  @override
  Widget build(BuildContext context) {
    var content = ColorField(
        initialValue: numfield.numericEntry,
        onSubmitted: (value) {
          numfield.numericEntry = value;
        });

    return encloseWithPBMSAF(content, props, args, horizontalUnbounded: true);
  }
}
