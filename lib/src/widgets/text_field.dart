import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'popup.dart';

/// A widget that provides a text input field.
///
/// The `TextEntryField` widget allows users to input text and has
/// several configurable options to govern how text is displayed and entered.
///
/// This widget accepts [initialValue] which is a string representation of the
/// text to edit.  When the user is finished editing, the new value is submitted back
/// via the provided handler [onSubmitted].
///
/// When the user is editing, the widget will restrict the total lenth of text
/// according to [maxLenth] and by [maxLines] (if not null).
///
/// In some cases it might be useful to provide choices for text to enter.
/// The [popupChoices] is a list of text strings, that the user can select from
/// by tapping a button next to the editing area.  The button can be customized
/// using the [popupChooserIcon] parameter.
///
class TextEntryField extends StatefulWidget {
  const TextEntryField(
      {super.key,
      required this.onSubmitted,
      this.initialValue,
      this.popupChoices,
      this.popupChooserIcon,
      this.maxLength,
      this.maxLines,
      this.minDisplayLines,
      this.maxDisplayLines,
      this.inputPattern,
      });

  /// Handler for new values submitted after entering them.
  final void Function(String value) onSubmitted;

  /// The initial value (optional).
  final String? initialValue;

  /// The maximum number of characters allowed (including whitespace).
  final int? maxLength;

  /// The maximum number of lines allowed.
  final int? maxLines;

  /// The minimum number of lines to display.
  final int? minDisplayLines;

  /// The maximum number of lines to display.
  final int? maxDisplayLines;

  /// Pattern that the text must follow.
  final String? inputPattern;

  /// Entries to show in the popup chooser (optional).  If this is null then
  /// popup chooser will be hidden.
  final List<String>? popupChoices;

  /// The icon to display for the popup chooser button (optional).  It defaults
  /// to an ellipses.
  final Icon? popupChooserIcon;

  @override
  State<TextEntryField> createState() => _TextEntryFieldState();
}

/// The state representation of [TextEntryField].
class _TextEntryFieldState extends State<TextEntryField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  RegExp? _allowedInputPattern;
  late TextInputFormatter _inputFmt;
  int _selectedItem = -1;

  // Cached list of popup choices represented as widgets.
  List<Widget>? _popupChoicesWidgets;

  // This field currently has focus.
  bool _hasFocus = false;

  // The last value submitted back via onSubmitted handler.  Null means that no
  // value has been submitted yet.
  String? _submittedValue;

  // Builds a regex for the allowed input pattern, taking into consideration
  // any constraints. If no patterm is specified then return null.
  RegExp? buildAllowedInputPattern() {
     var pattern = widget.inputPattern;
    if (pattern != null) {
      return RegExp(pattern);
    }
    return null;
  }
  
  /// Prepares the initial text (if provided to widget) to display while making
  /// sure it meets any constraints.  If no initialValue was provided then it defaults
  /// to empty text.
  String prepareInitialValue() {
    // Use the initial value?
    var value = widget.initialValue;

    if (value != null) {
      // TODO: check against length constraints....
      return checkAgainstConstraints(value).$2;
    }

    return '';
  }

  /// The numeric value (string) to use for editing.
  String get editingValue {
    if (_submittedValue != null) {
      return _submittedValue!;
    }
    return prepareInitialValue();
  }

  /// The numeric value (string) to use for displaying.
  String get displayValue {
    // For now, simply return the editing value. In the future, we might present the entered text
    // differently when not editing, as governed by widget settings.
    return editingValue;
  }

  /// Focus change handler for the text entry field.
  void onFocusChange() {
    setState(
      () {
        _hasFocus = _focusNode.hasPrimaryFocus;
      },
    );

    // If getting focus...
    if (_hasFocus) {
      // Show the edited value and select everything
      // TODO: add an 'autoSelect' setting to govern this behavior. Are there other possibilities
      // like select before first character or after last character?
      _controller.text = editingValue;
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    } else {
      // Store the edited value
      submitValue(_controller.text);

      // Show the display value and remove selection
      _controller.text = displayValue;
      _controller.selection =
          const TextSelection(baseOffset: -1, extentOffset: -1);
    }
  }

  /// Checks [text] against the min and max constraints. If [text] is within the max limits
  /// then it returns [text]. If [text] exceeds a limit then it clipped accordingly.
  (bool, String) checkAgainstConstraints(String text) {

    var maxLength = widget.maxLength;
    var maxLines = widget.maxLines;

    // Exceed max length (if specified)?
    if (maxLength != null && text.length > maxLength) {
      return (true, text.substring(0, maxLength));
    }

    // Exceeds max lines (if specified)?
    if (maxLines != null) {
      
      var allLines = text.split('\n');
      if (allLines.length > maxLines) {
        allLines.removeLast();
        return (true, allLines.join('\n'));
      }
    }

    // Was not constrained - return the original value.
    return (false, text);
  }

  /// Submits a value back to the handler provided to this widget.
  ///
  /// [value] must be a valid numeric string (as defined by allowed input pattern)
  /// or it can be empty.
  void submitValue(String value) {

    var submitValue = checkAgainstConstraints(value).$2;

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

  // Standard overrides

  @override
  void initState() {
    super.initState();

    _allowedInputPattern = buildAllowedInputPattern();

    _inputFmt = TextInputFormatter.withFunction(
      (TextEditingValue oldValue, TextEditingValue newValue) {
        var pattern = _allowedInputPattern;

        if (pattern != null && !pattern.hasMatch(newValue.text)) {
          return oldValue;
        }

        if (checkAgainstConstraints(newValue.text).$1) {
          return oldValue;
        }

        return newValue;
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
        : const Icon(Icons.arrow_drop_down);
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
