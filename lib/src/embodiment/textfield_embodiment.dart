// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';

class TextFieldEmbodiment extends StatefulWidget {
  const TextFieldEmbodiment(
      {super.key, required this.textfield, required this.parentWidgetType});

  final pg.TextField textfield;
  final String parentWidgetType;

  @override
  State<TextFieldEmbodiment> createState() => _TextFieldEmbodimentState();
}

class _TextFieldEmbodimentState extends State<TextFieldEmbodiment> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.textfield.textEntry);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
      // Save text changes upon losing focus
      if (!_hasFocus) {
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
    // Do nothing if text hasn't changed
    if (value == widget.textfield.textEntry) {
      return;
    }

    widget.textfield.textEntry = value;
  }

  Widget _buildForEditing(BuildContext context) {
    InputDecoration? decor;

    if (_hasFocus) {
      decor = const InputDecoration(border: OutlineInputBorder());
    }

    return TextField(
      controller: _controller,
      decoration: decor,
      onSubmitted: (value) => saveText(value),
      focusNode: _focusNode,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Add the following Expanded widget to avoid getting an exception during rendering.
    // See item #2 in the Problem Solving section in README.md file.

    if (widget.parentWidgetType == "Row" ||
        widget.parentWidgetType == "Column") {
      return Flexible(
        child: _buildForEditing(context),
      );
/*
      return SizedBox(
        width: 300,
        height: 100,
        child: _buildForEditing(context),
      );
*/
    }

    return _buildForEditing(context);
  }
}
