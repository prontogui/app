// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'embodiment_help.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import '../widgets/text_field.dart' as tef;
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'properties.dart';
import 'embodiment_common.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('TextField', [
    EmbodimentManifestEntry(
        'default', TextFieldEmbodiment.fromArgs, TextFieldDefaultProperties.fromMap),
  ]);
}

class TextFieldEmbodiment extends StatelessWidget {
  TextFieldEmbodiment.fromArgs(this.args, {super.key})
      : textfield = args.primitive as pg.TextField,
        props = args.properties as TextFieldDefaultProperties;

  final EmbodimentArgs args;
  final pg.TextField textfield;
  final TextFieldDefaultProperties props;

  @override
  Widget build(BuildContext context) {

    var content = tef.TextEntryField(
      initialText: textfield.textEntry,
      minDisplayLines: props.minDisplayLines,
      maxDisplayLines: props.maxDisplayLines,
      maxLength: props.maxLength,
      maxLines: props.maxLines,
      hideText: props.hideText,
      hidingCharacter: props.hidingCharacter,
      focusSelection: adaptFocusSelection(props.focusSelection),
      onSubmitted: (text) {
        textfield.textEntry = text;
      },
    );

    return encloseWithPBMSAF(content, args, horizontalUnbounded: true);
  }
}
