// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/src/embodiment/embodiment_interface.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'common_properties.dart';
import '../widgets/color_picker.dart' as cp;

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('NumericField', [
    EmbodimentManifestEntry('default', (args) {
      return DefaultNumericFieldEmbodiment(
        key: args.key,
        numfield: args.primitive as pg.NumericField,
        props:
            DefaultNumericFieldEmbodimentProperties.fromMap(args.embodimentMap),
        parentWidgetType: args.parentWidgetType,
      );
    }),
    EmbodimentManifestEntry('font-size', (args) {
      return FontSizeNumericFieldEmbodiment(
        key: args.key,
        numfield: args.primitive as pg.NumericField,
        props:
            FontSizeNumericFielEmbodimentProperties.fromMap(args.embodimentMap),
        parentWidgetType: args.parentWidgetType,
      );
    }),
    EmbodimentManifestEntry('color', (args) {
      return ColorNumericFieldEmbodiment(
        key: args.key,
        numfield: args.primitive as pg.NumericField,
        props:
            ColorNumericFieldEmbodimentProperties.fromMap(args.embodimentMap),
        parentWidgetType: args.parentWidgetType,
      );
    })
  ]);
}

class DefaultNumericFieldEmbodiment extends StatefulWidget {
  const DefaultNumericFieldEmbodiment(
      {super.key,
      required this.numfield,
      required this.props,
      required this.parentWidgetType});

  final pg.NumericField numfield;
  final DefaultNumericFieldEmbodimentProperties props;
  final String parentWidgetType;

  @override
  State<DefaultNumericFieldEmbodiment> createState() {
    return _DefaultEmbodimentState();
  }
}

class DefaultNumericFieldEmbodimentProperties with CommonProperties {
  DefaultNumericFieldEmbodimentProperties.fromMap(
      Map<String, dynamic>? embodimentMap) {
    super.initializeFromMap(embodimentMap);
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

    if (widget.parentWidgetType == "Row" ||
        widget.parentWidgetType == "Column") {
      return Flexible(
        child: content,
      );
    }

    return content;
  }
}

class FontSizeNumericFieldEmbodiment extends StatefulWidget {
  const FontSizeNumericFieldEmbodiment(
      {super.key,
      required this.numfield,
      required this.props,
      required this.parentWidgetType});

  final pg.NumericField numfield;
  final FontSizeNumericFielEmbodimentProperties props;
  final String parentWidgetType;

  @override
  State<FontSizeNumericFieldEmbodiment> createState() {
    return _FontSizeEmbodimentState();
  }
}

class FontSizeNumericFielEmbodimentProperties with CommonProperties {
  FontSizeNumericFielEmbodimentProperties.fromMap(
      Map<String, dynamic>? embodimentMap) {
    super.initializeFromMap(embodimentMap);
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

    if (widget.parentWidgetType == "Row" ||
        widget.parentWidgetType == "Column") {
      return Flexible(
        child: content,
      );
    }

    return content;
  }
}

class ColorNumericFieldEmbodiment extends StatefulWidget {
  const ColorNumericFieldEmbodiment(
      {super.key,
      required this.numfield,
      required this.props,
      required this.parentWidgetType});

  final pg.NumericField numfield;
  final ColorNumericFieldEmbodimentProperties props;
  final String parentWidgetType;

  @override
  State<ColorNumericFieldEmbodiment> createState() {
    return _ColorEmbodimentState();
  }
}

class ColorNumericFieldEmbodimentProperties with CommonProperties {
  ColorNumericFieldEmbodimentProperties.fromMap(
      Map<String, dynamic>? embodimentMap) {
    super.initializeFromMap(embodimentMap);
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
    ('0x00000000', Colors.black, ''),
    ('0x00FFFFFF', Colors.white, ''),
    ('0x00FF0000', Colors.red, '')
  ];

  @override
  Widget build(BuildContext context) {
    var items = _colorRecords.map(
      (e) {
        return DropdownMenuEntry<String>(
          value: e.$1,
          label: e.$3,
          leadingIcon: Icon(Icons.rectangle, color: e.$2),
        );
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
        child: Row(
          children: [
            SizedBox(
                width: 100,
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) => saveText(value),
                )),
            const cp.ColorPicker(),
            /*
            DropdownMenu<String>(
              //controller: _controller,
              width: 100,
              dropdownMenuEntries: items,
              menuHeight: 100,
              leadingIcon: leadingIcon,
              label: const SizedBox.shrink(),
              enableFilter: false,
              enableSearch: false,
              onSelected: (value) {
                setState(
                  () {},
                );
              },
            )
            */
          ],
        ));

    // Add the following Flexible widget to avoid getting an exception during rendering.
    // See item #2 in the Problem Solving section in README.md file.

    if (widget.parentWidgetType == "Row" ||
        widget.parentWidgetType == "Column") {
      return Flexible(
        child: content,
      );
    }

    return content;
  }
}
