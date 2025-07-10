import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'popup.dart';

// The default character to use when hiding input.
const String _defaultHidingCharacter = '*';

/// A widget that provides a text input field.
///
/// The `TextEntryField` widget allows users to input text and has
/// several configurable options to govern how text is displayed and entered.
///
/// This widget accepts [initialText] which is a string representation of the
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
      this.initialText,
      this.popupChoices,
      this.popupChooserIcon,
      this.maxLength,
      this.maxLines,
      this.minDisplayLines,
      this.maxDisplayLines,
      this.inputPattern,
      this.hideText = false,
      this.hidingCharacter,
      });

  /// Handler for new values submitted after entering them.
  final void Function(String value) onSubmitted;

  /// The initial text to display. If not provided then the field will be empty of text.
  final String? initialText;

  /// The maximum number of characters allowed (including whitespace).
  final int? maxLength;

  /// The maximum number of lines allowed. This is optional. For performance reasons,
  /// especially when entering large amounts of text, this should be set to null
  /// if there's no need limit the number of lines.
  final int? maxLines;

  /// The minimum number of lines to display.
  final int? minDisplayLines;

  /// The maximum number of lines to display.
  final int? maxDisplayLines;

  /// Pattern that the text must follow. This should be a regular expression that can
  /// be used with RegExp. For performance reasons, this should be set to null when there's
  /// no need to constrain the text input. Be advised that using an inputPattern with large
  /// amounts of text could be pathologically slow, so use this feature with caution and
  /// use the maxLength and maxLines to constrain the text size if feasible.
  /// 
  /// Refer to Flutter docs for more details on performance: https://api.flutter.dev/flutter/dart-core/RegExp-class.html
  final String? inputPattern;

  /// Entries to show in the popup chooser (optional).  If this is null then
  /// popup chooser will be hidden.
  final List<String>? popupChoices;

  /// The icon to display for the popup chooser button (optional).  It defaults
  /// to an ellipses.
  final Icon? popupChooserIcon;

  // Hide the text displayed and entered into the field. This is useful for sensitive information like passwords.
  final bool hideText;

  /// The character to use when hiding text with [hideText] turned on. This defaults to the asterisk * character.
  final String? hidingCharacter;

  @override
  State<TextEntryField> createState() => _TextEntryFieldState();
}

/// The state representation of [TextEntryField].
class _TextEntryFieldState extends State<TextEntryField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  RegExp? _allowedInputRegex;
  String? _allowedInputRegexSource;
  late TextInputFormatter _inputFmt;
  int _selectedItem = -1;

  // Cached list of popup choices represented as widgets.
  List<Widget>? _popupChoicesWidgets;

  // This field currently has focus.
  bool _hasFocus = false;

  // The last value submitted back via onSubmitted handler.  Null means that no
  // value has been submitted yet.
  String? _submittedText;

  // Builds a regex for the allowed input pattern.
  void buildAllowedInputPattern() {
    var pattern = widget.inputPattern;
    if (pattern != null) {
      // Has pattern changed since last time we built a regex?
      if (_allowedInputRegexSource != null && pattern == _allowedInputRegexSource) {
        return;
      }
      _allowedInputRegexSource = pattern;
      _allowedInputRegex = RegExp(pattern);
      return;
    }
    _allowedInputRegex = null;
    _allowedInputRegexSource = null;
  }
  
  /// Prepares the initial text (if provided to widget) to display while making
  /// sure it meets any constraints.  If no initialValue was provided then it defaults
  /// to empty text.
  String prepareInitialText() {
    // Use the initial value?
    var text = widget.initialText;

    if (text != null) {
      return checkAgainstConstraints(text).$2;
    }

    return '';
  }

  /// The string to use for editing text (not editing).
  String get editingText {
    if (_submittedText != null) {
      return _submittedText!;
    }
    return prepareInitialText();
  }

  /// The string to use for displaying text (not editing).
  String get displayText {
    // For now, simply return the editing text. In the future, we might present the entered text
    // differently when not editing, as governed by widget settings.
    return editingText;
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
      // Show the edited text and select everything
      // TODO: add an 'autoSelect' setting to govern this behavior. Are there other possibilities
      // like select before first character or after last character?
      _controller.text = editingText;
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    } else {
      // Store the edited value
      submitText(_controller.text);

      // Show the display value and remove selection
      _controller.text = displayText;
      _controller.selection =
          const TextSelection(baseOffset: -1, extentOffset: -1);
    }
  }

  /// Checks [text] against the min and max constraints. If [text] is within the max limits
  /// then it returns [text]. If [text] exceeds a limit then it clipped accordingly.
  (bool, String) checkAgainstConstraints(String text) {

    var constrained = false;
    var maxLength = widget.maxLength;
    var maxLines = widget.maxLines;

    // Exceed max length (if specified)?
    if (maxLength != null && text.length > maxLength) {
      constrained = true;
      text = text.substring(0, maxLength);
    }

    // Exceeds max lines (if specified)?
    if (maxLines != null) {
      
      var allLines = text.split('\n');
      if (allLines.length > maxLines) {
        constrained = true;
        allLines.removeLast();
        text = allLines.join('\n');
      }
    }

    var pattern = _allowedInputRegex;

    if (pattern != null && !pattern.hasMatch(text)) {
      constrained = true;
      // Policy for now: return empty string if no regex match.
      text = '';
    }

    return (constrained, text);
  }

  /// Submits the edited text back to the handler provided to this widget.
  ///
  /// [text] must be a valid text string (as defined by constraints)
  /// or it can be empty. If the text hasn't changed from the last time
  /// it was submitted then no callback is made.
  void submitText(String text) {

    var submitValue = checkAgainstConstraints(text).$2;

    // Do nothing if text hasn't changed
    if (_submittedText != null && submitValue == _submittedText) {
      return;
    }
    _submittedText = submitValue;
    widget.onSubmitted(submitValue);
  }

  /// Updates the edited text in the field with the current selection in the popup choices.
  void updateField() {
    if (_selectedItem == -1) {
      return;
    }
    var text = widget.popupChoices![_selectedItem];
    setState(() => _controller.text = text);
    submitText(text);
  }

  // Standard overrides

  @override
  void initState() {
    super.initState();

    buildAllowedInputPattern();

    _inputFmt = TextInputFormatter.withFunction(
      (TextEditingValue oldValue, TextEditingValue newValue) {
        if (checkAgainstConstraints(newValue.text).$1) {
          return oldValue;
        }
        return newValue;
      },
    );

    _controller = TextEditingController(text: displayText);
    _focusNode = FocusNode();
    _focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    _allowedInputRegex = null;
    _allowedInputRegexSource = null;
    _controller.dispose();
    _focusNode.removeListener(onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    buildAllowedInputPattern();
    _hasFocus = false;
    _controller.text = prepareInitialText();
    _submittedText = null;
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

    Widget buildTextField(OverlayPortalController? controller) {
    
      late InputDecoration decoration;

      if (controller == null) {
        decoration = InputDecoration(
          border: _hasFocus ? const OutlineInputBorder() : null,
        );
      } else {
        decoration = InputDecoration(
          border: const OutlineInputBorder(),
          suffixIcon: widget.popupChoices != null
              ? IconButton(
                  icon: chooserIcon,
                  onPressed: controller.show,
                )
              : null,
        );
      }

      decoration.applyDefaults(theme.inputDecorationTheme);

      var hc = widget.hidingCharacter;

      return TextField(
        controller: _controller,
        decoration: decoration,
        onSubmitted: (value) => submitText(value),
        focusNode: _focusNode,
        inputFormatters: [_inputFmt],
        minLines: widget.minDisplayLines,
        maxLines: widget.maxDisplayLines,
        obscureText: widget.hideText,
        obscuringCharacter: hc != null && hc.isNotEmpty ? hc[0] : _defaultHidingCharacter,
        );
    }

    if (widget.popupChoices == null) {

      return Container(
          color: theme.colorScheme.surfaceContainer,
          child: buildTextField(null));

    } else {
      var selectedColor =
          Colors.grey; // = theme.colorScheme.surfaceContainerLow;

      return Popup(
          followerAnchor: Alignment.topCenter,
          flip: true,
          child: (context, controller) => Container(
                color: theme.colorScheme.surfaceContainer,
                child: buildTextField(controller),
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
