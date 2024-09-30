// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/textfield.dart' as pri;
import 'package:flutter/material.dart';

class TextFieldEmbodiment extends StatefulWidget {
  const TextFieldEmbodiment({super.key, required this.textfield});

  final pri.TextField textfield;

  @override
  State<TextFieldEmbodiment> createState() => _TextFieldEmbodimentState();
}

class _TextFieldEmbodimentState extends State<TextFieldEmbodiment> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.textfield.textEntry);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTextField(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onSubmitted: (value) => widget.textfield.enterText(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Add the following Expanded widget to avoid getting an exception during rendering.
    // See item #2 in the Problem Solving section in README.md file.
    return Flexible(
      child: _buildTextField(context),
    );
  }
}
