// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'embodiment_interface.dart';
import 'embodiment_property_help.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'common_properties.dart';
import '../widgets/popup.dart';
import 'dart:core';

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
    _focusNode.addListener(onFocusChange);
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasPrimaryFocus);
    });

    //FocusManager.instance.addListener(onFocusChange);
  }

  void onFocusChange() {
    setState(
      () {
        _hasFocus = _focusNode.hasPrimaryFocus;
      },
    );
    if (_hasFocus) {
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    } else {
      storeValue(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void storeValue(String value) {
    // Do nothing if text hasn't changed
    if (value == widget.numfield.numericEntry) {
      return;
    }
    setState(
      () {
        widget.numfield.numericEntry = value;
      },
    );
    pg.logger.t('Default numeric field saved value $value');
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
          onSubmitted: (value) => storeValue(value),
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
  late FocusNode _focusNode;
  bool _hasFocus = false;

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
    _focusNode.addListener(onFocusChange);
  }

  void onFocusChange() {
    _hasFocus = _focusNode.hasPrimaryFocus;
    if (_hasFocus) {
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    } else {
      storeValue(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void storeValue(String value) {
    // Do nothing if text hasn't changed
    if (value == widget.numfield.numericEntry) {
      return;
    }
    setState(
      () {
        widget.numfield.numericEntry = value;
      },
    );
    pg.logger.t('Font size numeric field saved value $value');
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
        child: DropdownMenu<String>(
          enableSearch: false,
          enableFilter: false,
          controller: _controller,
          dropdownMenuEntries: items,
          menuHeight: 300,
          requestFocusOnTap: true,
          alignmentOffset: const Offset(-125, 1),
          inputFormatters: [_inputFmt],
          focusNode: _focusNode,
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
  late TextInputFormatter _inputFmt;
  late FocusNode _focusNode;
  final _allowedInputPattern = RegExp(r'^\s*(#)?[0-9a-fA-F]{0,8}\s*$');
  bool _hasFocus = false;
  late Color pickedColor;

  String prepareInitialValue() {
    var value = widget.numfield.numericEntry;
    if (_allowedInputPattern.hasMatch(value)) {
      return canonizeHexColorValue(normalizeHexColorValue(value));
    }
    return canonizeHexColorValue('#');
  }

  TextSelection _restrictTextSelection(
      TextSelection prevSelection, int newLength) {
    int min(int a, int b) => (a < b) ? a : b;
    return TextSelection(
        baseOffset: min(prevSelection.baseOffset, newLength),
        extentOffset: min(prevSelection.extentOffset, newLength));
  }

  @override
  void initState() {
    super.initState();

    _inputFmt = TextInputFormatter.withFunction(
      (TextEditingValue oldValue, TextEditingValue newValue) {
        var enteredText = newValue.text.trim();
        if (_allowedInputPattern.hasMatch(enteredText)) {
          String updatedText;

          // Entered text is empty
          if (enteredText.isEmpty) {
            updatedText = '';
            return newValue.copyWith(
              text: '',
              selection: const TextSelection(baseOffset: 0, extentOffset: 0),
            );

            // Entered (or pasted) a value without leading hash sign
          } else if (enteredText[0] != '#') {
            // Normalize the value and put in the hash sign
            updatedText = normalizeHexColorValue(enteredText);
            // Return the new value and adjust the selection
            return newValue.copyWith(
              text: updatedText,
              selection: TextSelection(
                  baseOffset: updatedText.length,
                  extentOffset: updatedText.length),
            );
            // All other cases
          } else {
            updatedText = normalizeHexColorValue(enteredText);
            return newValue.copyWith(
                text: updatedText,
                selection: _restrictTextSelection(
                    newValue.selection, updatedText.length));
          }
        }
        return oldValue;
      },
    );

    _controller = TextEditingController(text: prepareInitialValue());
    _focusNode = FocusNode();
    _focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// The current color value as a canonical hex string.
  String get currentColorValue =>
      canonizeHexColorValue(normalizeHexColorValue(_controller.text));

  /// The current color as a Color value.
  Color get currentColor =>
      Color(int.parse(currentColorValue.substring(1), radix: 16));

  void onFocusChange() {
    _hasFocus = _focusNode.hasPrimaryFocus;
    if (_hasFocus) {
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    } else {
      var currentValue = currentColorValue;
      storeColorValue(currentValue);
      _controller.text = currentValue;
    }
  }

  void storeColorValue(String value) {
    // Do nothing if text hasn't changed
    if (value == widget.numfield.numericEntry) {
      return;
    }
    setState(
      () {
        widget.numfield.numericEntry = value;
      },
    );
    pg.logger.t('Color numeric field saved value $value');
  }

  void updateColorField(Color color) {
    var colorValue =
        colorToHex(color, enableAlpha: true, includeHashSign: true);
    setState(() {
      _controller.text = colorValue;
      storeColorValue(colorValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var content = Popup(
      followerAnchor: Alignment.topCenter,
      flip: true,
      child: (context, controller) => Container(
          color: theme.colorScheme.surfaceContainer,
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => storeColorValue(currentColorValue),
            inputFormatters: [_inputFmt],
            focusNode: _focusNode,
            style: theme.textTheme.bodyLarge, // Same used for DropdownMenu
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.rectangle),
              prefixIconColor: currentColor,
              suffixIcon: IconButton(
                icon: const Icon(Icons.palette),
                onPressed: controller.show,
              ),
            ).applyDefaults(theme.inputDecorationTheme),
          )),
      follower: (context, controller) => PopupFollower(
        onDismiss: () {
          controller.hide();
          updateColorField(pickedColor);
          //       widget.onColorPicked(chosenColor);
        },
        child: Container(
          width: 400,
          height: 475,
          color: theme.colorScheme.surfaceContainer,
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: (color) {
              pickedColor = color;
            },
            portraitOnly: true,
          ),
          // Use Material color picker:
          //
          // child: MaterialPicker(
          //   pickerColor: pickerColor,
          //   onColorChanged: changeColor,
          //   showLabel: true, // only on portrait mode
          // ),
          //
          // Use Block color picker:
          //
          // child: BlockPicker(
          //   pickerColor: currentColor,
          //   onColorChanged: changeColor,
          // ),
          //
          // child: MultipleChoiceBlockPicker(
          //   pickerColors: currentColors,
          //   onColorsChanged: changeColors,
          // ),
        ),
      ),
    );

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

/*
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var content = Container(
        color: theme.colorScheme.surfaceContainer,
        child: TextField(
          controller: _controller,
          onSubmitted: (value) => storeColorValue(currentColorValue),
          inputFormatters: [_inputFmt],
          focusNode: _focusNode,
          style: theme.textTheme.bodyLarge, // Same used for DropdownMenu
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.rectangle),
            prefixIconColor: currentColor,
            suffixIcon: cp.ColorChooser(
              initialColor: currentColor,
              onColorPicked: updateColorField,
            ),
          ).applyDefaults(theme.inputDecorationTheme),
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
  */
}
