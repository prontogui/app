import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'popup.dart';

/// An entry field for specifying a color value and for choosing a value using
/// a popup picker.
///
/// This widget accepts [initialValue] which is a string representation of the
/// color to select.  When the user is finished editing the color value or
/// selecting one from the popup list, the new value is submitted back
/// via the provided handler [onSubmitted].
///
/// Color values are formatted as '#AARRGGBB' where it begins with a pound and
/// ARGB characters are hexadecimal digits for the Alpha, Red, Green, and Blue
/// component values.
class ColorField extends StatefulWidget {
  const ColorField({
    super.key,
    required this.onSubmitted,
    this.initialValue,
  });

  /// Handler for new color values submitted after entering or picking a color.
  final void Function(String value) onSubmitted;

  /// The initial color choice (optional).
  final String? initialValue;

  @override
  State<ColorField> createState() {
    return _ColorFieldState();
  }
}

/// The state representation of [ColorField].
class _ColorFieldState extends State<ColorField> {
  late TextEditingController _controller;
  late TextInputFormatter _inputFmt;
  late FocusNode _focusNode;
  final _allowedInputPattern = RegExp(r'^\s*(#)?[0-9a-fA-F]{0,8}\s*$');

  // This field currently has focus.
  bool _hasFocus = false;

  // The current color choice made by ColorPicker.  This is updated frequently
  // as the user navigates color choices via the picker.
  Color? _pickedColor;

  // The last value submitted back via onSubmitted handler
  String? _submittedValue;

  /// Prepares the initial value (if provided to widget) to display while making
  /// sure it is valid.  If no initialValue was provided then it defaults
  /// to #00000000 (black).
  String prepareInitialValue() {
    var value = widget.initialValue ?? '';
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
  void didUpdateWidget(covariant oldWidget) {
    _controller.text = prepareInitialValue();
    _submittedValue = null;
    _hasFocus = false;
    super.didUpdateWidget(oldWidget);
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
    if (_submittedValue != null && value == _submittedValue) {
      return;
    }
    _submittedValue = value;
    widget.onSubmitted(value);
  }

  void updateColorField() {
    var color = _pickedColor != null ? _pickedColor! : currentColor;
    var colorValue =
        colorToHex(color, enableAlpha: true, includeHashSign: true);
    setState(() => _controller.text = colorValue);
    storeColorValue(colorValue);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Popup(
        followerAnchor: Alignment.topCenter,
        flip: true,
        child: (context, controller) => Container(
            color: theme.colorScheme.surfaceContainer,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.rectangle),
                prefixIconColor: currentColor,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.palette),
                  onPressed: controller.show,
                ),
              ).applyDefaults(theme.inputDecorationTheme),
              onSubmitted: (value) => storeColorValue(currentColorValue),
              inputFormatters: [_inputFmt],
              focusNode: _focusNode,
              style: theme.textTheme.bodyLarge, // Same used for DropdownMenu
            )),
        follower: (context, controller) => PopupFollower(
            onDismiss: () {
              controller.hide();
              updateColorField();
            },
            child: CallbackShortcuts(
              bindings: <ShortcutActivator, VoidCallback>{
                const SingleActivator(LogicalKeyboardKey.enter): () {
                  controller.hide();
                  updateColorField();
                },
                const SingleActivator(LogicalKeyboardKey.escape): () {
                  controller.hide();
                },
              },
              child: Focus(
                autofocus: true,
                child: Container(
                  width: 400,
                  height: 475,
                  color: theme.colorScheme.surfaceContainer,
                  child: ColorPicker(
                    pickerColor: currentColor,
                    onColorChanged: (color) {
                      _pickedColor = color;
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
            )));
  }
}

/// Returns true if the hex color value is normalized.  It is normalized when
/// it begins with a hash sign #, is less than 9 digits total (including hash),
/// and only contains upper case hex digits.
bool isNormalizedHexColorValue(String value) {
  bool invalidDigits() {
    for (int i = 1; i < value.length; i++) {
      if (!'01234567890ABCDEF'.contains(value[i])) {
        return true;
      }
    }
    return false;
  }

  return !(value.isEmpty ||
      value.length > 9 ||
      value[0] != '#' ||
      invalidDigits());
}

/// Normalizes a hex color value according to definition describe in function
/// isNormalizedHexColorValue.
String normalizeHexColorValue(String value) {
  var value2 = value.trim().toUpperCase();
  return (value2.isEmpty || value2[0] != '#') ? '#$value2' : value2;
}

/// Canonizes an assumed-to-be normalized hex color value.  Canonized form
/// is a 9 character string starting with a hash sign, then Alpha, Red, Green,
/// and Blue components with 2 hex digits each.
String canonizeHexColorValue(String normalizedValue) {
  assert(isNormalizedHexColorValue(normalizedValue));

  // default to 100% for alpha and zero for RGB
  String alpha = 'FF';
  String red = '00';
  String green = '00';
  String blue = '00';

  String getComponent(int startingAt, bool twoDigits) {
    if (twoDigits) {
      return normalizedValue.substring(startingAt, startingAt + 2);
    } else {
      var digit = normalizedValue.substring(startingAt, startingAt + 1);
      return '0$digit';
    }
  }

  switch (normalizedValue.length) {
    case 2:
      red = getComponent(1, false);
    case 3:
      red = getComponent(1, true);
    case 4:
      red = getComponent(1, true);
      green = getComponent(3, false);
    case 5:
      red = getComponent(1, true);
      green = getComponent(3, true);
    case 6:
      red = getComponent(1, true);
      green = getComponent(3, true);
      blue = getComponent(5, false);
    case 7:
      red = getComponent(1, true);
      green = getComponent(3, true);
      blue = getComponent(5, true);
    case 8:
      alpha = getComponent(1, false);
      red = getComponent(2, true);
      green = getComponent(4, true);
      blue = getComponent(6, true);
    case 9:
      alpha = getComponent(1, true);
      red = getComponent(3, true);
      green = getComponent(5, true);
      blue = getComponent(7, true);
  }

  // Return the canonized form
  return '#$alpha$red$green$blue';
}
