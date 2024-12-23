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
    return ChoiceField(
      choices: choice.choices,
      initialValue: choice.choice,
      onSubmitted: (value) {
        choice.choice = value;
      },
    );
  }
}
/*
class DefaultChoiceEmbodiment extends StatefulWidget {
  const DefaultChoiceEmbodiment({super.key, required this.choice});

  final pg.Choice choice;

  @override
  State<DefaultChoiceEmbodiment> createState() {
    return _DefaultChoiceEmbodimentState();
  }
}

class _DefaultChoiceEmbodimentState extends State<DefaultChoiceEmbodiment> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String? _lastSearchValue;

  void setCurrentChoice(String? newChoice) {
    if (newChoice != null) {
      widget.choice.choice = newChoice;
    }
  }

  String prepareInitialValue() {
    if (widget.choice.isChoiceValid) {
      return widget.choice.choice;
    }
    if (widget.choice.choices.isNotEmpty) {
      return widget.choice.choices[0];
    }
    return '';
  }

  String prepareSearchedValue() {
    if (_lastSearchValue != null) {
      return _lastSearchValue!;
    }
    return prepareInitialValue();
  }

  void onFocusChange() {
    if (_focusNode.hasPrimaryFocus) {
      _lastSearchValue = null;
    } else {
      // If user left the field with an invalid/incomplete choice then revert
      // back to last saved value.
      if (!widget.choice.choices.contains(_controller.text)) {
        setState(() {
          _controller.text = prepareSearchedValue();
          _lastSearchValue = null;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: prepareInitialValue());
    _focusNode = FocusNode();
    _focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    _controller.text = prepareInitialValue();
    _lastSearchValue = null;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var choicesD = widget.choice.choices
        .map(
          (e) => DropdownMenuEntry(
            value: e,
            label: e,
          ),
        )
        .toList();

    return Container(
        color: theme.colorScheme.surfaceContainer,
        child: DropdownMenu<String>(
          focusNode: _focusNode,
          controller: _controller,
          initialSelection: _controller.text,
          dropdownMenuEntries: choicesD,
          onSelected: (value) => setCurrentChoice(value),
          // Use the search callback to grab the item selected as a result
          // of typing something into text field.  Keep the semantics of the
          // default search handler, as if this field was set to null.
          searchCallback: (entries, query) {
            if (query.isEmpty) {
              return null;
            }
            final int index =
                entries.indexWhere((entry) => entry.label.startsWith(query));

            if (index == -1) {
              _lastSearchValue = null;
            } else {
              _lastSearchValue = entries[index].value;
            }

            return index != -1 ? index : null;
          },
        ));
  }
}
*/

class ButtonChoiceEmbodiment extends StatefulWidget {
  const ButtonChoiceEmbodiment({super.key, required this.choice});

  final pg.Choice choice;

  @override
  State<ButtonChoiceEmbodiment> createState() {
    return _ButtonChoiceEmbodimentState();
  }
}

class _ButtonChoiceEmbodimentState extends State<ButtonChoiceEmbodiment> {
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
