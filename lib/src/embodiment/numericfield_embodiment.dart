// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/src/embodiment/embodiment_common.dart';

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
    EmbodimentManifestEntry('default', DefaultNumericFieldEmbodiment.fromArgs,
        NumericFieldDefaultProperties.fromMap),
    EmbodimentManifestEntry('font-size',
        FontSizeNumericFieldEmbodiment.fromArgs, CommonProperties.fromMap),
    EmbodimentManifestEntry('color', ColorNumericFieldEmbodiment.fromArgs,
        NumericFieldColorProperties.fromMap)
  ]);
}

class DefaultNumericFieldEmbodiment extends StatelessWidget {
  const DefaultNumericFieldEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var numfield = args.primitive as pg.NumericField;
    var props = args.properties as NumericFieldDefaultProperties;

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
        allowEmptyValue: props.allowEmptyValue,
        focusSelection: adaptFocusSelection(props.focusSelection),
        onSubmitted: (value) {
          numfield.numericEntry = value;
        });

    return encloseWithPBMSAF(content, args, horizontalUnbounded: true);
  }
}

class FontSizeNumericFieldEmbodiment extends StatelessWidget {
  const FontSizeNumericFieldEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

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
    var numfield = args.primitive as pg.NumericField;
    var props = args.properties as CommonProperties;

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

    return encloseWithPBMSAF(content, args, horizontalUnbounded: true);
  }
}

class ColorNumericFieldEmbodiment extends StatelessWidget {
  const ColorNumericFieldEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var numfield = args.primitive as pg.NumericField;
    var props = args.properties as NumericFieldColorProperties;

    var content = ColorField(
        initialValue: numfield.numericEntry,
        allowEmptyValue: props.allowEmptyValue,
        onSubmitted: (value) {
          numfield.numericEntry = value;
        });

    return encloseWithPBMSAF(content, args, horizontalUnbounded: true);
  }
}
