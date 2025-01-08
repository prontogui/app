// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'package:app/src/embodiment/embodiment_interface.dart';
import '../widgets/choice_field.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Choice', [
    EmbodimentManifestEntry('default', (args) {
      return DefaultChoiceEmbodiment(
          key: args.key, choice: args.primitive as pg.Choice);
    }),
    EmbodimentManifestEntry('button', (args) {
      return ButtonChoiceEmbodiment(
          key: args.key, choice: args.primitive as pg.Choice);
    }),
  ]);
}

class DefaultChoiceEmbodiment extends StatelessWidget {
  const DefaultChoiceEmbodiment({super.key, required this.choice});

  final pg.Choice choice;

  @override
  Widget build(BuildContext context) {
    var choiceLabels = choice.choiceLabels;
    return ChoiceField(
      choices: choice.choices,
      choiceLabels: choiceLabels.isNotEmpty ? choiceLabels : null,
      initialValue: choice.choice,
      onSubmitted: (value) {
        choice.choice = value;
      },
    );
  }
}

class ButtonChoiceEmbodiment extends StatefulWidget {
  const ButtonChoiceEmbodiment({super.key, required this.choice});

  final pg.Choice choice;

  List<String> get choices {
    return choice.choices;
  }

  List<String> get choiceLabels {
    return choice.choiceLabels;
  }

  @override
  State<ButtonChoiceEmbodiment> createState() {
    return _ButtonChoiceEmbodimentState();
  }
}

class _ButtonChoiceEmbodimentState extends State<ButtonChoiceEmbodiment> {
  // Whether we are working with labels as choices.
  bool get usingLabels {
    return widget.choiceLabels.length == widget.choices.length;
  }

  // The "nominal" choices.  Althought these come directly from widget.choices, this field
  // makes the code a little cleaner looking.
  List<String> get nominalChoices {
    return widget.choices;
  }

  // The "effective" choices to work with.  These are either nominal choices from
  // widget.choices or widget.choiceLabels, depending on whether the labels are provided and
  // they correspond 1:1 with nominal choices.
  List<String> get workingChoices {
    if (usingLabels) {
      return widget.choiceLabels;
    } else {
      return nominalChoices;
    }
  }

  // Convert an nominal choice value to a working choice.
  String nominalToWorkingChoice(String choice) {
    // Short circuit...
    if (!usingLabels) {
      return choice;
    }
    int index = nominalChoices.indexOf(choice);
    return widget.choiceLabels[index];
  }

  // Convert a working choice to a nominal choice.
  String workingChoiceToNominal(String workingChoice) {
    // Short circuit...
    if (!usingLabels) {
      return workingChoice;
    }
    int index = workingChoices.indexOf(workingChoice);
    return nominalChoices[index];
  }

  void setCurrentChoice(String newChoice) {
    setState(() {
      widget.choice.choice = workingChoiceToNominal(newChoice);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Invalid choice?
    if (!widget.choice.isChoiceValid) {
      // TODO:  handle this in a helpful, e.g. show an "error", log an error, throw an exception.
      return const SizedBox();
    }

    var choicesD = List<DropdownMenuItem<String>>.empty(growable: true);

    for (final element in workingChoices) {
      choicesD.add(DropdownMenuItem<String>(
        value: element,
        child: Text(element),
      ));
    }

    return DropdownButton<String>(
      items: choicesD,
      value: nominalToWorkingChoice(widget.choice.choice),
      onChanged: (value) {
        if (value == null) return;
        setCurrentChoice(value);
      },
    );
  }
}
