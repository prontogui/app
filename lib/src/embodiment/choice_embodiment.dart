// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'package:app/src/embodiment/embodiment_interface.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Choice', [
    EmbodimentManifestEntry('default', (args) {
      return ChoiceEmbodiment(
          key: args.key, choice: args.primitive as pg.Choice);
    }),
  ]);
}

class ChoiceEmbodiment extends StatefulWidget {
  const ChoiceEmbodiment({super.key, required this.choice});

  final pg.Choice choice;

  @override
  State<ChoiceEmbodiment> createState() {
    return _ChoiceEmbodimentState();
  }
}

class _ChoiceEmbodimentState extends State<ChoiceEmbodiment> {
  void setCurrentChoice(String newChoice) {
    setState(() {
      widget.choice.choice = newChoice;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Invalid choice?
    if (!widget.choice.isChoiceValid) {
      // TODO:  handle this in a helpful, e.g. show an "error", log an error, throw an excpection.
      return const SizedBox();
    }

    var choicesD = List<DropdownMenuItem<String>>.empty(growable: true);

    for (final element in widget.choice.choices) {
      choicesD.add(DropdownMenuItem<String>(
        value: element,
        child: Text(element),
      ));
    }

    // TODO:  convert this over to DropdownMenu for consistent look and feel with NumericField
    return DropdownButton<String>(
      items: choicesD,
      value: widget.choice.choice,
      onChanged: (value) {
        if (value == null) return;
        setCurrentChoice(value);
      },
    );
  }
}
