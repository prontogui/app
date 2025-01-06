import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'popup.dart';
import 'dart:math';

enum NegativeDisplayFormat { absolute, minusSignPrefix, parens }

/// A widget that provides a numeric input field.
///
/// The `NumericField` widget allows users to input numeric values and has
/// several configurable options to govern how the values are displayed,
/// minimum and maximum value constraints, and a popup list of predefined
/// numeric choices.  An initial value can be provided and when values are
/// entered, they are 'submitted' back to the caller using a supplied function.
///

class NumericField extends StatefulWidget {
  const NumericField(
      {super.key,
      required this.onSubmitted,
      this.initialValue,
      this.displayDecimalPlaces,
      this.displayNegativeFormat,
      this.displayThousandths,
      this.minValue,
      this.maxValue,
      this.popupChoices,
      this.popupChooserIcon})
      : assert(minValue == null || maxValue == null || maxValue > minValue,
            'maxValue must be greater than minValue');

  /// Handler for new values submitted after entering them.
  final void Function(String value) onSubmitted;

  /// The initial value (optional).
  final String? initialValue;

  /// Entries to show in the popup chooser (optional).  If this is null then
  /// popup chooser will be hidden.
  final List<String>? popupChoices;

  /// The number of decimal places to show for the displayed value.  0 - 20 will
  /// display 0 through 20 fractional digits accordingly.  -1 to -20 will display
  /// optional 1 - 20 fractional digits accordingly based on the fractional digits
  /// availabled in the value.
  final int? displayDecimalPlaces;

  /// How negative numbers will be formatted for display.
  final NegativeDisplayFormat? displayNegativeFormat;

  /// Display thousandths separators.
  final bool? displayThousandths;

  /// Minimum constraint for submitted values. A value is rejected upon submission,
  /// and [minValue] is submitted instead, if the entered value is less than [minValue].
  /// Setting this [minValue] to null disables this constraint.
  ///
  /// Note:  [minValue] must be less than [maxValue] or an exception is thrown.
  final double? minValue;

  /// Maximum constraint for submitted values. A value is rejected upon submission,
  /// and [maxValue] is submitted instead, if the entered value is greater than [maxValue].
  /// Setting this [maxValue] to null disables this constraint.
  ///
  /// Note:  [maxValue] must be greater than [minValue] or an exception is thrown.
  final double? maxValue;

  /// The icon to display for the popup chooser button (optional).  It defaults
  /// to an ellipses.
  final Icon? popupChooserIcon;

  @override
  State<NumericField> createState() => _NumericFieldState();
}

class _NumericFieldState extends State<NumericField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late RegExp _allowedInputPattern;
  late TextInputFormatter _inputFmt;
  int _selectedItem = -1;

  // Cached list of popup choices represented as widgets
  List<Widget>? _popupChoicesWidgets;

  // This field currently has focus.
  bool _hasFocus = false;

  // The last value submitted back via onSubmitted handler.  Null means that no
  // value has been submitted yet.
  String? _submittedValue;

  // Builds a regex for the allowed input pattern, taking into consideration
  // any constraints.
  RegExp buildAllowedInputPattern() {
    var minValue = widget.minValue;
    var maxValue = widget.maxValue;
    late String pattern;

    if (minValue != null && minValue >= 0.0) {
      // Pattern for positive-only numbers
      pattern = r'^[+]?[0-9]*\.?[0-9]*$';
    } else if (maxValue != null && maxValue < 0.0) {
      // Pattern for negative-only numbers
      pattern = r'^-[0-9]*\.?[0-9]*$';
    } else {
      // Pattern for all numbers
      pattern = r'^[+-]?[0-9]*\.?[0-9]*$';
    }

    return RegExp(pattern);
  }

  String prepareInitialValue() {
    var value = widget.initialValue;
    if (value != null && value.isNotEmpty) {
      if (_allowedInputPattern.hasMatch(value)) {
        return value;
      }
    }
    return '0';
  }

  String get editingValue {
    if (_submittedValue != null) {
      return _submittedValue!;
    }
    return prepareInitialValue();
  }

  String get displayValue {
    return formatNumericValue(editingValue, widget.displayDecimalPlaces,
        widget.displayNegativeFormat, widget.displayThousandths);
  }

  void onFocusChange() {
    setState(
      () {
        _hasFocus = _focusNode.hasPrimaryFocus;
      },
    );

    // If getting focus...
    if (_hasFocus) {
      // Show the edited value
      _controller.text = editingValue;
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    } else {
      // Store the edited value
      submitValue(_controller.text);

      // Show the display value
      _controller.text = displayValue;
      _controller.selection =
          const TextSelection(baseOffset: -1, extentOffset: -1);
    }
  }

  /// Checks [value] against the min and max constraints.  Clips the value if
  /// necessary, otherwise returns [value].
  String checkAgainstConstraints(String value) {
    var minValue = widget.minValue;
    var maxValue = widget.maxValue;

    // Need to check against a constraint?
    if (minValue != null || maxValue != null) {
      var valueD = double.parse(value);

      // Less than min constraint?
      if (minValue != null && valueD < minValue) {
        return minValue.toString();

        // Greater than max constraint?
      } else if (maxValue != null && valueD > maxValue) {
        return maxValue.toString();
      }
    }

    // Default to original value
    return value;
  }

  /// Submits a value back to the handler provided to this widget.
  ///
  /// [value] must be a valid numeric string (as defined by allowed input pattern)
  /// or it can be empty.
  void submitValue(String value) {
    // Make sure value isn't empty
    if (value.isEmpty) {
      value = '0';
    }

    var submitValue = checkAgainstConstraints(value);

    // Do nothing if text hasn't changed
    if (_submittedValue != null && submitValue == _submittedValue) {
      return;
    }
    _submittedValue = submitValue;
    widget.onSubmitted(submitValue);
  }

  /// Updates the edited value in the text field with the current selection in
  /// the popup choices.
  void updateField() {
    if (_selectedItem == -1) {
      return;
    }
    var value = widget.popupChoices![_selectedItem];
    setState(() => _controller.text = value);
    submitValue(value);
  }

  @override
  void initState() {
    super.initState();

    _allowedInputPattern = buildAllowedInputPattern();

    _inputFmt = TextInputFormatter.withFunction(
      (TextEditingValue oldValue, TextEditingValue newValue) {
        return _allowedInputPattern.hasMatch(newValue.text)
            ? newValue
            : oldValue;
      },
    );

    _controller = TextEditingController(text: displayValue);
    _focusNode = FocusNode();
    _focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    _allowedInputPattern = buildAllowedInputPattern();
    _hasFocus = false;
    _controller.text = prepareInitialValue();
    _submittedValue = null;
    _popupChoicesWidgets = null;
    super.didUpdateWidget(oldWidget);
  }

  Icon get chooserIcon {
    return widget.popupChooserIcon != null
        ? widget.popupChooserIcon!
        : const Icon(Icons.more);
  }

  List<Widget> get popupChoicesWidgets {
    _popupChoicesWidgets ??= widget.popupChoices == null
        ? List<Widget>.empty(growable: false)
        : widget.popupChoices!
            .map(
              (e) => Text(e),
            )
            .toList();

    return _popupChoicesWidgets!;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if (widget.popupChoices == null) {
      return Container(
          color: theme.colorScheme.surfaceContainer,
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: _hasFocus ? const OutlineInputBorder() : null,
            ),
            onSubmitted: (value) => submitValue(value),
            focusNode: _focusNode,
            inputFormatters: [_inputFmt],
          ));
    } else {
      var selectedColor =
          Colors.grey; // = theme.colorScheme.surfaceContainerLow;

      return Popup(
          followerAnchor: Alignment.topCenter,
          flip: true,
          child: (context, controller) => Container(
                color: theme.colorScheme.surfaceContainer,
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: widget.popupChoices != null
                        ? IconButton(
                            icon: chooserIcon,
                            onPressed: controller.show,
                          )
                        : null,
                  ).applyDefaults(theme.inputDecorationTheme),
                  onSubmitted: (value) => submitValue(value),
                  focusNode: _focusNode,
                  style: theme.textTheme.bodyLarge,
                  inputFormatters: [_inputFmt],
                ),
              ),
          follower: (context, controller) => PopupFollower(
              onDismiss: () {
                controller.hide();
                updateField();
              },
              child: CallbackShortcuts(
                  bindings: <ShortcutActivator, VoidCallback>{
                    const SingleActivator(LogicalKeyboardKey.enter): () {
                      controller.hide();
                      updateField();
                    },
                    const SingleActivator(LogicalKeyboardKey.escape): () {
                      controller.hide();
                    },
                  },
                  child: Focus(
                      autofocus: true,
                      child: Container(
                          width: 200,
                          height: 200,
                          color: theme.colorScheme.surfaceContainer,
                          child: Material(
                              child: ListView.builder(
                            itemBuilder: (context, index) => _builderPopupItem(
                                context, index, controller, selectedColor),
                          )))))));
    }
  }

  /// Builds a single item to display in the popup choices.
  Widget? _builderPopupItem(BuildContext context, int index,
      OverlayPortalController controller, Color selectedColor) {
    if (index >= popupChoicesWidgets.length) {
      return null;
    }

    var item = popupChoicesWidgets[index];

    //var isSelected = index == _selectedItem;

    void saveValueAndHidePopup() {
      controller.hide();
      _selectedItem = index;
      updateField();
    }

    return CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.enter):
              saveValueAndHidePopup,
        },
        child: ListTile(
          title: item,
          //selected: isSelected,
          isThreeLine: false,
          //selectedTileColor: Colors.red, //isSelected ? selectedColor : null,
          onTap: saveValueAndHidePopup,
        ));
  }
}

/// Interprets the widget settings and formats a numeric value accordingly.
///
/// [value] must be a valid numeric string (as defined by allowed input pattern).
String formatNumericValue(String value,
    [int? decimalPlaces,
    NegativeDisplayFormat? negativeFormat,
    bool? thousandthsSeparators]) {
  late int dp;

  // Default value of negativeFormat specification
  negativeFormat ??= NegativeDisplayFormat.minusSignPrefix;

  if (decimalPlaces == null) {
    dp = getPrecisionOfNumericValue(value);
  } else if (decimalPlaces < 0) {
    var precision = getPrecisionOfNumericValue(value);
    dp = min(precision, -decimalPlaces);
  } else {
    dp = decimalPlaces;
  }

  var floatValue = double.parse(value);
  var absValue = floatValue.abs();
  var absNumericValue = absValue.toStringAsFixed(dp);

  if (thousandthsSeparators != null && thousandthsSeparators) {
    absNumericValue = addThousandthsSeparators(absNumericValue);
  }

  if (floatValue >= 0) {
    return absNumericValue;
  } else {
    switch (negativeFormat) {
      case NegativeDisplayFormat.absolute:
        return absNumericValue;
      case NegativeDisplayFormat.minusSignPrefix:
        return '-$absNumericValue';
      case NegativeDisplayFormat.parens:
        return '($absNumericValue)';
    }
  }
}

/// Returns the precision that is present in a numeric value.
///
/// [value] must be a valid numeric string (as defined by allowed input pattern).
int getPrecisionOfNumericValue(String value) {
  var dploc = value.indexOf('.');
  if (dploc == -1) {
    return 0;
  }

  bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

  int precision = 0;
  for (var i = dploc + 1; i < value.length && isDigit(value, i); i++) {
    precision++;
  }
  return precision;
}

/// Returns a numeric value by adding thousandths separators to [value].
///
/// [value] must be a valid numeric string (as defined by allowed input pattern).
String addThousandthsSeparators(String value) {
  // Prep for internationalization later
  const separator = ',';
  const decimalPoint = '.';

  // Break numeric value apart into whole and fraction
  var pieces = value.split(decimalPoint);
  var wholePart = pieces[0];
  var fractionPart = pieces.length > 1 ? '$decimalPoint${pieces[1]}' : '';

  // Build a new whole portion that has separators
  String newWholePart = '';

  // For each character in wholePart working backward
  for (var count = 0, next = wholePart.length - 1;
      count < wholePart.length;
      count++, next--) {
    // Prepend a separator?
    if (count > 1 && (count % 3 == 0)) {
      newWholePart = '${wholePart[next]}$separator$newWholePart';
    } else {
      newWholePart = '${wholePart[next]}$newWholePart';
    }
  }

  // Recombine new whole part and existing faction part
  return '$newWholePart$fractionPart';
}
