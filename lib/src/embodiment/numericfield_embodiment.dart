// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/src/embodiment/embodiment_interface.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common_properties.dart';

class DefaultEmbodimentProperties with CommonProperties {
  DefaultEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap) {
    super.initializeFromMap(embodimentMap);
  }
}

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('NumericField', [
    EmbodimentManifestEntry('default', (args) {
      return DefaultNumericFieldEmbodiment(args);
    }),
    EmbodimentManifestEntry('font-size', (args) {
      return FontSizeNumericFieldEmbodiment(args);
    }),
    EmbodimentManifestEntry('color', (args) {
      return ColorNumericFieldEmbodiment(args);
    })
  ]);
}

class DefaultNumericFieldEmbodiment extends StatefulWidget {
  DefaultNumericFieldEmbodiment(this.args)
      : numfield = args.primitive as pg.NumericField,
        embodimentProps =
            DefaultEmbodimentProperties.fromMap(args.embodimentMap),
        super(key: args.key);

  final EmbodimentArgs args;
  final pg.NumericField numfield;
  final DefaultEmbodimentProperties embodimentProps;

  @override
  State<DefaultNumericFieldEmbodiment> createState() {
    return _DefaultEmbodimentState();
  }
}

class _DefaultEmbodimentState extends State<DefaultNumericFieldEmbodiment> {
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
      setState(() => _hasFocus = _focusNode.hasPrimaryFocus);
    });

    //FocusManager.instance.addListener(onFocusChange);
  }

  void onFocusChange() {
    saveText(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    //FocusManager.instance.removeListener(onFocusChange);
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

  @override
  Widget build(BuildContext context) {
    InputDecoration? decor;

    if (_hasFocus) {
      decor = const InputDecoration(border: OutlineInputBorder());
    }

    var content = Container(
        color: Colors.white,
        child: TextField(
          controller: _controller,
          decoration: decor,
          onSubmitted: (value) => saveText(value),
          focusNode: _focusNode,
          inputFormatters: [_inputFmt],
        ));

    // Add the following Flexible widget to avoid getting an exception during rendering.
    // See item #2 in the Problem Solving section in README.md file.

    if (widget.args.parentWidgetType == "Row" ||
        widget.args.parentWidgetType == "Column") {
      return Flexible(
        child: content,
      );
    }

    return content;
  }
}

class FontSizeNumericFieldEmbodiment extends StatefulWidget {
  FontSizeNumericFieldEmbodiment(this.args)
      : numfield = args.primitive as pg.NumericField,
        embodimentProps =
            NumericFieldEmbodimentProperties.fromMap(args.embodimentMap),
        super(key: args.key);

  final EmbodimentArgs args;
  final pg.NumericField numfield;
  final NumericFieldEmbodimentProperties embodimentProps;

  @override
  State<FontSizeNumericFieldEmbodiment> createState() {
    return _FontSizeEmbodimentState();
  }
}

class _FontSizeEmbodimentState extends State<FontSizeNumericFieldEmbodiment> {
  late TextEditingController _controller;
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
  }

  void onFocusChange() {
    saveText(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
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

  @override
  Widget build(BuildContext context) {
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

    var content = Container(
        color: Colors.white,
        //  decoration: decor,
        child: DropdownMenu<String>(
          enableSearch: false,
          controller: _controller,
          dropdownMenuEntries: items,
          menuHeight: 400,
        ));

    // Add the following Flexible widget to avoid getting an exception during rendering.
    // See item #2 in the Problem Solving section in README.md file.

    if (widget.args.parentWidgetType == "Row" ||
        widget.args.parentWidgetType == "Column") {
      return Flexible(
        child: content,
      );
    }

    return content;
  }
}

class ColorNumericFieldEmbodiment extends StatefulWidget {
  ColorNumericFieldEmbodiment(this.args)
      : numfield = args.primitive as pg.NumericField,
        embodimentProps =
            NumericFieldEmbodimentProperties.fromMap(args.embodimentMap),
        super(key: args.key);

  final EmbodimentArgs args;
  final pg.NumericField numfield;
  final NumericFieldEmbodimentProperties embodimentProps;

  @override
  State<ColorNumericFieldEmbodiment> createState() {
    return _ColorEmbodimentState();
  }
}

class _ColorEmbodimentState extends State<ColorNumericFieldEmbodiment> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.numfield.numericEntry);
  }

  void onFocusChange() {
    saveText(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
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

  // See https://www.rapidtables.com/web/color/RGB_Color.html for good reference.
  static const _colorRecords = <(String value, Color color, String label)>[
    ('0x00000000', Colors.black, 'Black'),
    ('0x00FFFFFF', Colors.white, 'White'),
    ('0x00FF0000', Colors.red, 'Red')
  ];

  @override
  Widget build(BuildContext context) {
    var items = _colorRecords.map(
      (e) {
        return DropdownMenuEntry<String>(
            value: e.$1,
            label: e.$3,
            leadingIcon: Icon(Icons.rectangle, color: e.$2));
      },
    ).toList();

    // TODO:  generalize this code
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

    var content = Container(
        color: Colors.white,
        child: DropdownMenu<String>(
          controller: _controller,
          dropdownMenuEntries: items,
          menuHeight: 400,
          leadingIcon: leadingIcon,
        ));

    // Add the following Flexible widget to avoid getting an exception during rendering.
    // See item #2 in the Problem Solving section in README.md file.

    if (widget.args.parentWidgetType == "Row" ||
        widget.args.parentWidgetType == "Column") {
      return Flexible(
        child: content,
      );
    }

    return content;
  }
}
