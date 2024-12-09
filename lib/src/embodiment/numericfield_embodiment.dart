// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericFieldEmbodiment extends StatefulWidget {
  const NumericFieldEmbodiment(
      {super.key, required this.numfield, required this.parentWidgetType});

  final pg.NumericField numfield;
  final String parentWidgetType;

  @override
  State<NumericFieldEmbodiment> createState() => _NumericFieldEmbodimentState();
}

class _NumericFieldEmbodimentState extends State<NumericFieldEmbodiment> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  late RegExp _pattern;
  late TextInputFormatter _inputFmt;

  @override
  void initState() {
    super.initState();

    _pattern = RegExp(r'^[+-]?[0-9]*\.?[0-9]*$');

    _inputFmt = TextInputFormatter.withFunction(
      (TextEditingValue oldValue, TextEditingValue newValue) {
        return _pattern.hasMatch(newValue.text) ? newValue : oldValue;
      },
    );

    _controller = TextEditingController(text: widget.numfield.numericEntry);
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
    if (value == widget.numfield.numericEntry) {
      return;
    }

    widget.numfield.numericEntry = value;
  }

  Widget _buildForEditing(BuildContext context) {
    InputDecoration? decor;

    if (_hasFocus) {
      decor = const InputDecoration(border: OutlineInputBorder());
    }

    return Container(
        color: Colors.white,
        child: TextField(
          controller: _controller,
          decoration: decor,
          onSubmitted: (value) => saveText(value),
          focusNode: _focusNode,
          inputFormatters: [_inputFmt],
        ));
  }

  @override
  Widget build(BuildContext context) {
    // Add the following Flexible widget to avoid getting an exception during rendering.
    // See item #2 in the Problem Solving section in README.md file.

    if (widget.parentWidgetType == "Row" ||
        widget.parentWidgetType == "Column") {
      return Flexible(
        child: _buildForEditing(context),
      );
    }

    return _buildForEditing(context);
  }
}
