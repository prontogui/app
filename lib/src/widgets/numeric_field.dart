import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'popup.dart';

class NumericField extends StatefulWidget {
  const NumericField(
      {super.key,
      required this.onSubmitted,
      this.initialValue,
      this.popupChoices,
      this.popupChooserIcon});

  /// Handler for new values submitted after entering them.
  final void Function(String value) onSubmitted;

  /// The initial value (optional).
  final String? initialValue;

  /// Entries to show in the popup chooser (optional).  If this is null then
  /// popup chooser will be hidden.
  final List<String>? popupChoices;

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

  // The last value submitted back via onSubmitted handler
  String? _submittedValue;

  String prepareInitialValue() {
    var value = widget.initialValue ?? '';
    if (_allowedInputPattern.hasMatch(value)) {
      return value;
    }
    return '0';
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

  void storeValue(String value) {
    // Do nothing if text hasn't changed
    if (_submittedValue != null && value == _submittedValue) {
      return;
    }
    _submittedValue = value;
    widget.onSubmitted(value);
  }

  void updateField() {
    if (_selectedItem == -1) {
      return;
    }
    var value = widget.popupChoices![_selectedItem];
    setState(() => _controller.text = value);
    storeValue(value);
  }

  @override
  void initState() {
    super.initState();

    _allowedInputPattern = RegExp(r'^[+-]?[0-9]*\.?[0-9]*$');

    _inputFmt = TextInputFormatter.withFunction(
      (TextEditingValue oldValue, TextEditingValue newValue) {
        return _allowedInputPattern.hasMatch(newValue.text)
            ? newValue
            : oldValue;
      },
    );

    _controller = TextEditingController(text: prepareInitialValue());
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
            onSubmitted: (value) => storeValue(value),
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
                  onSubmitted: (value) => storeValue(value),
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
                            itemBuilder: (context, index) => builderPopupItem(
                                context, index, controller, selectedColor),
                          )))))));
    }
  }

  Widget? builderPopupItem(BuildContext context, int index,
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
