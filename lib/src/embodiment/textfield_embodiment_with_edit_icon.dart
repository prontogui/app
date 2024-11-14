// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';

class TextFieldEmbodiment extends StatefulWidget {
  const TextFieldEmbodiment({super.key, required this.textfield});

  final pg.TextField textfield;

  @override
  State<TextFieldEmbodiment> createState() => _TextFieldEmbodimentState();
}

class _TextFieldEmbodimentState extends State<TextFieldEmbodiment> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  var _editing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.textfield.textEntry);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        saveText(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void saveText(String value) {
    setState(() {
      widget.textfield.textEntry = value;
    });
  }

  void endEditing() {
    setState(() {
      _editing = false;
    });
  }

  Widget _buildForEditing(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onSubmitted: (value) => saveText(value),
      onEditingComplete: () => endEditing(),
      focusNode: _focusNode,
    );
  }

  Widget _buildForNotEditing(BuildContext context) {
    return Row(
      children: [
        Text(widget.textfield.textEntry),
        IconButton(
          onPressed: () {
            setState(() {
              _editing = true;
            });
          },
          icon: const Icon(Icons.edit),
          iconSize: 16,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      // Originally I added an Expanded widget here to avoid getting an exception during rendering.
      // See item #2 in the Problem Solving section in README.md file.
      // I have since changed to a Flexible widget [aj]
      return _buildForEditing(context);
    } else {
      return _buildForNotEditing(context);
    }
  }
}
