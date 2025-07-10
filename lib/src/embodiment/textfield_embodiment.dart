// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'embodiment_help.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import '../widgets/text_field.dart';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'properties.dart';

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

    var content = TextEntryField(
      initialText: textfield.textEntry,
      minDisplayLines: props.minDisplayLines,
      maxDisplayLines: props.maxDisplayLines,
      maxLength: props.maxLength,
      maxLines: props.maxLines,
      hideText: props.hideText,
      hidingCharacter: props.hidingCharacter,
      onSubmitted: (text) {
        textfield.textEntry = text;
      },
    );

    return encloseWithPBMSAF(content, args, horizontalUnbounded: true);
  }
}

/*
OLD CODE - DELETE ONCE EVERYTHING WORKING

// TODO:  refactor this code and separate the functionality into TextField widget,
// like done with NumericField, ColorField, etc.
class TextFieldEmbodiment extends StatefulWidget {
  TextFieldEmbodiment.fromArgs(this.args, {super.key})
      : textfield = args.primitive as pg.TextField,
        props = args.properties as TextFieldDefaultProperties;

  final EmbodimentArgs args;
  final pg.TextField textfield;
  final TextFieldDefaultProperties props;

  @override
  State<TextFieldEmbodiment> createState() => _TextFieldEmbodimentState();
}

class _TextFieldEmbodimentState extends State<TextFieldEmbodiment> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;
  late TextInputFormatter _inputFmt;

  String _applyConstraints(String text) {
    var props = widget.props;

    if (text.length > props.maxLength)
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _applyConstraints(widget.textfield.textEntry));
    _focusNode = FocusNode();
    _focusNode.addListener(onFocusChange);

    _inputFmt = TextInputFormatter.withFunction(
      (TextEditingValue oldValue, TextEditingValue newValue) {
        return TextEditingValue(text: _applyConstraints(newValue.text), selection: newValue.selection);
      },
    );
  }

  void onFocusChange() {
    setState(() => _hasFocus = _focusNode.hasFocus);
    // Save text changes upon losing focus
    if (!_hasFocus) {
      saveText(_controller.text);
    }
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    _hasFocus = false;
    _controller.text = widget.textfield.textEntry;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(onFocusChange);
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

  @override
  Widget build(BuildContext context) {
    var props = widget.props;
    var theme = Theme.of(context);
    
    InputDecoration? decor;

//    if (_hasFocus) {
      decor = InputDecoration(border: OutlineInputBorder(), ).applyDefaults(theme.inputDecorationTheme);
//    }

    var content = TextField(
      controller: _controller,
      decoration: decor,
      inputFormatters: [_inputFmt],
      onSubmitted: (value) => saveText(value),
      focusNode: _focusNode,
      maxLines: props.maxDisplayLines,
      minLines: props.minDisplayLines,
    );

    return encloseWithPBMSAF(content, widget.args, horizontalUnbounded: true);
  }
}


*/
