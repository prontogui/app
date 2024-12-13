// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../embodiment_properties/numericfield_embodiment_properties.dart';

class NumericFieldEmbodiment extends StatefulWidget {
  NumericFieldEmbodiment(
      {super.key,
      required this.numfield,
      required Map<String, dynamic>? embodimentMap,
      required this.parentWidgetType})
      : embodimentProps =
            NumericFieldEmbodimentProperties.fromMap(embodimentMap);

  final pg.NumericField numfield;
  final String parentWidgetType;
  final NumericFieldEmbodimentProperties embodimentProps;

  @override
  State<NumericFieldEmbodiment> createState() => _NumericFieldEmbodimentState();
}

class _NumericFieldEmbodimentState extends State<NumericFieldEmbodiment> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasFocus = false;
  String? _selectedFont = "";
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
    _controller.addListener(
      () {
        print('current value = ${_controller.text}');
      },
    );
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasPrimaryFocus);
      // Save text changes upon losing focus

      /*
      if (!_hasFocus) {
        saveText(_controller.text);
      }
      */
    });

    FocusManager.instance.addListener(onFocusChange);
  }

  void onFocusChange() {
    saveText(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    FocusManager.instance.removeListener(onFocusChange);
    super.dispose();
  }

  void saveText(String value) {
    // Do nothing if text hasn't changed
    if (value == widget.numfield.numericEntry) {
      return;
    }
    print('saved value = $value');
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

  Widget _buildForFontSize(BuildContext context) {
    Decoration? decor;

    if (_hasFocus) {
      decor = BoxDecoration(border: Border.all(width: 3));
    }

    var items = [
      8,
      9,
      10,
      11,
      12,
      14,
      16,
      20,
      24,
      28,
      32,
      35,
      40,
      44,
      54,
      60,
      68,
      72,
      80,
      88,
      96
    ].map(
      (e) {
        return DropdownMenuEntry<String>(
            value: e.toString(), label: e.toString());
      },
    ).toList();

    return Container(
        color: Colors.white,
        //  decoration: decor,
        child: DropdownMenu<String>(
          controller: _controller,
          dropdownMenuEntries: items,
          menuHeight: 400,
          //focusNode: _focusNode,
          onSelected: (String? value) {
            setState(() {
              _selectedFont = value;
            });
          },
        ));
  }

  // See https://www.rapidtables.com/web/color/RGB_Color.html for good reference.
  static const _colorRecords = <(String value, Color color, String label)>[
    ('0x00000000', Colors.black, 'Black'),
    ('0x00FFFFFF', Colors.white, 'White'),
    ('0x00FF0000', Colors.red, 'Red')
  ];

  Widget _buildForColor(BuildContext context) {
    var items = _colorRecords.map(
      (e) {
        return DropdownMenuEntry<String>(
            value: e.$1,
            label: e.$3,
            leadingIcon: Icon(Icons.rectangle, color: e.$2));
      },
    ).toList();

    Icon? leadingIcon;
    switch (_controller.text) {
      case 'Black':
        var color = _colorRecords[0];
        leadingIcon = Icon(Icons.rectangle, color: color.$2);
      case 'White':
        var color = _colorRecords[1];
        leadingIcon = Icon(Icons.rectangle, color: color.$2);
      case 'Red':
        var color = _colorRecords[2];
        leadingIcon = Icon(Icons.rectangle, color: color.$2);
      default:
        leadingIcon = const Icon(Icons.rectangle_outlined, color: Colors.grey);
    }

    return Container(
        color: Colors.white,
        child: DropdownMenu<String>(
          controller: _controller,
          dropdownMenuEntries: items,
          menuHeight: 400,
          leadingIcon: leadingIcon,
          //focusNode: _focusNode,
          onSelected: (String? value) {
            setState(() {
              print('Dropdown value = $value');
              _selectedFont = value;
            });
          },
        ));
  }

  Widget _build(BuildContext context) {
    switch (widget.embodimentProps.embodiment) {
      case 'default':
        return _buildForEditing(context);
      case 'font-size':
        return _buildForFontSize(context);
      case 'color':
        return _buildForColor(context);
      default:
        return _buildForEditing(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Add the following Flexible widget to avoid getting an exception during rendering.
    // See item #2 in the Problem Solving section in README.md file.

    if (widget.parentWidgetType == "Row" ||
        widget.parentWidgetType == "Column") {
      return Flexible(
        child: _build(context),
      );
    }

    return _build(context);
  }
}
