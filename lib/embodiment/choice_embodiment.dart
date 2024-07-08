// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/choice.dart';
import 'package:flutter/material.dart';

class ChoiceEmbodiment extends StatefulWidget {
  const ChoiceEmbodiment({super.key, required this.choice});

  final Choice choice;

  @override
  State<ChoiceEmbodiment> createState() {
    return _ChoiceEmbodimentState();
  }
}

class _ChoiceEmbodimentState extends State<ChoiceEmbodiment> {
  void setCurrentChoice(String newChoice) {
    setState(() {
      widget.choice.updateChoice(newChoice);
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
