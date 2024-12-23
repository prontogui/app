import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'popup.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChoiceField extends StatefulWidget {
  const ChoiceField(
      {super.key,
      required this.onSubmitted,
      required this.choices,
      this.initialValue,
      this.popupChooserIcon});

  /// Handler for new values submitted after entering them.
  final void Function(String value) onSubmitted;

  /// Vaid choices that will appear in the popup chooser.
  final List<String> choices;

  /// The initial value (optional).
  final String? initialValue;

  /// The icon to display for the popup chooser button (optional).  It defaults
  /// to an ellipses.
  final Icon? popupChooserIcon;

  @override
  State<ChoiceField> createState() => _ChoiceFieldState();
}

class _ChoiceFieldState extends State<ChoiceField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late TextInputFormatter _inputFmt;
  late OverlayPortalController _popupController;
  late AutoScrollController _scrollController;

  //int _selectedItem = -1;
  final _selectedItem = ValueNotifier(-1);

  // Cached list of popup choices represented as widgets
  List<Widget>? _popupChoicesWidgets;

  // This field currently has focus.
  bool _hasFocus = false;

  // The last value submitted back via onSubmitted handler
  String? _submittedValue;

  String prepareInitialValue() {
    if (widget.initialValue != null) {
      if (widget.choices.contains(widget.initialValue)) {
        return widget.initialValue!;
      }
    }
    if (widget.choices.isNotEmpty) {
      return widget.choices[0];
    }
    return '';
  }

  String prepareSubmittedValue() {
    if (_submittedValue != null) {
      return _submittedValue!;
    }
    return prepareInitialValue();
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
      // If user left the field with an invalid/incomplete choice then revert
      // back to last saved value.
      if (!widget.choices.contains(_controller.text)) {
        setState(() {
          _controller.text = prepareSubmittedValue();
        });
      }
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

  void saveSelectedItem() {
    if (_selectedItem.value == -1) {
      return;
    }
    var value = widget.choices[_selectedItem.value];
    storeValue(value);
  }

  void updateField() {
    if (_selectedItem.value == -1) {
      return;
    }
    var value = widget.choices[_selectedItem.value];
    setState(() => _controller.text = value);
    storeValue(value);
  }

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: prepareInitialValue());
    _focusNode = FocusNode();
    _focusNode.addListener(onFocusChange);
    _inputFmt = TextInputFormatter.withFunction(
      (TextEditingValue oldValue, TextEditingValue newValue) {
        _popupController.show();
        setState(
          () {
            if (newValue.text.isEmpty) {
              _selectedItem.value = -1;
            } else {
              _selectedItem.value = widget.choices.indexWhere(
                (element) => element.startsWith(newValue.text),
              );
            }

            if (_selectedItem.value == -1) {
              _scrollController.scrollToIndex(0,
                  preferPosition: AutoScrollPosition.begin);
            } else {
              _scrollController.scrollToIndex(_selectedItem.value,
                  preferPosition: AutoScrollPosition.begin);
            }
          },
        );
        return newValue;
      },
    );
    _popupController = OverlayPortalController();
    _scrollController = AutoScrollController(axis: Axis.vertical);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(onFocusChange);
    _focusNode.dispose();
    _scrollController.dispose();
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
    _popupChoicesWidgets ??= widget.choices
        .map(
          (e) => Text(e),
        )
        .toList();

    return _popupChoicesWidgets!;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Popup(
        followerAnchor: Alignment.topCenter,
        flip: true,
        controller: _popupController,
        child: (context, controller) => Container(
              color: theme.colorScheme.surfaceContainer,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: chooserIcon,
                    onPressed: controller.show,
                  ),
                ).applyDefaults(theme.inputDecorationTheme),
                onSubmitted: (value) {
                  _popupController.hide();
                  saveSelectedItem();
                },
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
            child: buildPopupContent(context, controller, theme)));
  }

  Widget buildPopupContent(BuildContext context,
      OverlayPortalController controller, ThemeData theme) {
    var selectedColor = Colors.grey; // = theme.colorScheme.surfaceContainerLow;

    return ListenableBuilder(
      listenable: _selectedItem,
      builder: (context, child) {
        return CallbackShortcuts(
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
                // autofocus: true,
                child: Container(
                    width: 200,
                    height: 200,
                    color: theme.colorScheme.surfaceContainer,
                    child: Material(
                        child: ListView.builder(
                      controller: _scrollController,
                      itemCount: widget.choices.length,
                      itemBuilder: (context, index) => builderPopupItem(
                          context, index, controller, selectedColor),
                    )))));
      },
    );
  }

  Widget? builderPopupItem(BuildContext context, int index,
      OverlayPortalController controller, Color selectedColor) {
    if (index >= popupChoicesWidgets.length) {
      return null;
    }
    //print('builderPopupItem called');
    var item = popupChoicesWidgets[index];

    void saveValueAndHidePopup() {
      controller.hide();
      _selectedItem.value = index;
      updateField();
    }

    return AutoScrollTag(
        key: ValueKey(index),
        controller: _scrollController,
        index: index,
        child: CallbackShortcuts(
            bindings: <ShortcutActivator, VoidCallback>{
              const SingleActivator(LogicalKeyboardKey.enter):
                  saveValueAndHidePopup,
            },
            child: ListTile(
              title: item,
              selected: index == _selectedItem.value,
              isThreeLine: false,
              //selectedTileColor: Colors.red, //isSelected ? selectedColor : null,
              onTap: saveValueAndHidePopup,
            )));
  }
}
