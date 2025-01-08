import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'popup.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

/// Field for entering a string choice from a list of choices.  User can click a
/// button to pulldown the list of choices to choose from
///
/// Note:  this keeps the same look as other field widgets.
class ChoiceField extends StatefulWidget {
  const ChoiceField(
      {super.key,
      required this.onSubmitted,
      required this.choices,
      this.choiceLabels,
      this.initialValue,
      this.popupChooserIcon});

  /// Handler for new values submitted after entering them.  [value] is a valid
  /// choice from [choices] field.
  final void Function(String value) onSubmitted;

  /// Vaid choices that will appear in the popup chooser.
  final List<String> choices;

  /// Optional labels to display for each choice.  Each element corresponds to
  /// the associated element in [choices].  These labels are ignored if length of
  /// [choiceLabels] does not match [choices].
  final List<String>? choiceLabels;

  /// The initial value (optional).
  final String? initialValue;

  /// The icon to display for the popup chooser button (optional).  It defaults
  /// to an down arrow.
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

  // The currently selected item or -1 if entered value is not a valid item.
  final _selectedItem = ValueNotifier(-1);

  // Cached list of popup choices represented as widgets
  List<Widget>? _popupChoicesWidgets;

  // This field currently has focus.
  bool _hasFocus = false;

  // The last value submitted back via onSubmitted handler
  String? _submittedValue;

  // Whether we are working with labels as choices.
  bool get usingLabels {
    var choiceLabels = widget.choiceLabels;
    return choiceLabels != null && choiceLabels.length == widget.choices.length;
  }

  // The "nominal" choices.  Althought these come directly from widget.choices, this field
  // makes the code a little cleaner looking.
  List<String> get nominalChoices {
    return widget.choices;
  }

  // The "effective" choices to work with.  These are either nominal choices from
  // widget.choices or widget.choiceLabels, depending on whether the labels are provided and
  // they correspond 1:1 with nominal choices.
  List<String> get workingChoices {
    if (usingLabels) {
      return widget.choiceLabels!;
    } else {
      return nominalChoices;
    }
  }

  // Convert an nominal choice value to a working choice.
  String nominalToWorkingChoice(String choice) {
    // Short circuit...
    if (!usingLabels) {
      return choice;
    }
    int index = nominalChoices.indexOf(choice);
    return widget.choiceLabels![index];
  }

  // Convert a working choice to a nominal choice.
  String workingChoiceToNominal(String workingChoice) {
    // Short circuit...
    if (!usingLabels) {
      return workingChoice;
    }
    int index = workingChoices.indexOf(workingChoice);
    return nominalChoices[index];
  }

  // Returns the initial choice text to present.
  String prepareInitialValue() {
    if (widget.initialValue != null) {
      if (nominalChoices.contains(widget.initialValue)) {
        return nominalToWorkingChoice(widget.initialValue!);
      }
    }
    if (workingChoices.isNotEmpty) {
      return workingChoices[0];
    }
    return '';
  }

  /// Returns the initial selected item index for the initial value or -1
  /// if no initial value provided or is not found in choices.
  int prepareInitialSelectedItem() {
    if (widget.initialValue == null) {
      return -1;
    }
    return nominalChoices.indexWhere(
      (element) => element.startsWith(widget.initialValue!),
    );
  }

  /// Returns the most recently submitted (valid) choice value, otherwise, the
  /// initial value.
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
      // Select the entire contents of text field
      _controller.selection =
          TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    } else {
      // If user left the field with an invalid/incomplete choice then revert
      // back to last saved value.
      if (!workingChoices.contains(_controller.text)) {
        setState(() {
          _controller.text = prepareSubmittedValue();
        });
      }
    }
  }

  /// Submits or saves the choice value to the provided handler for this widget.
  void submitValue(String value) {
    // Do nothing if text hasn't changed
    if (_submittedValue != null && value == _submittedValue) {
      return;
    }
    _submittedValue = value;
    widget.onSubmitted(workingChoiceToNominal(value));
  }

  /// Submits or saves the selected item in pulldown list to the provided handler
  /// for this widget.
  void submitSelectedItem() {
    if (_selectedItem.value == -1) {
      return;
    }
    var value = workingChoices[_selectedItem.value];
    submitValue(value);
  }

  void updateField() {
    if (_selectedItem.value == -1) {
      return;
    }
    var value = workingChoices[_selectedItem.value];
    setState(() => _controller.text = value);
    submitValue(value);
  }

  @override
  void initState() {
    super.initState();
    _selectedItem.value = prepareInitialSelectedItem();
    _controller = TextEditingController(text: prepareInitialValue());
    _focusNode = FocusNode();
    _focusNode.addListener(onFocusChange);
    _inputFmt = TextInputFormatter.withFunction(
      (TextEditingValue oldValue, TextEditingValue newValue) {
        _popupController.show();
        setState(
          () {
            // Update the selectedItem to a valid choice or -1 if field is incomplete
            if (newValue.text.isEmpty) {
              _selectedItem.value = -1;
            } else {
              _selectedItem.value = workingChoices.indexWhere(
                (element) => element.startsWith(newValue.text),
              );
            }

            // Scroll the list accordingly (if its showing)
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
    _selectedItem.value = prepareInitialSelectedItem();
    _controller.text = prepareInitialValue();
    _submittedValue = null;
    _popupChoicesWidgets = null;
    super.didUpdateWidget(oldWidget);
  }

  /// Returns the Icon to use for button to pull down list.
  Icon get chooserIcon {
    return widget.popupChooserIcon != null
        ? widget.popupChooserIcon!
        : const Icon(Icons.arrow_drop_down);
  }

  /// Returns a list of widgets to display for the choices.  This is built lazily
  /// and cached for subsequent calls.
  List<Widget> get popupChoicesWidgets {
    _popupChoicesWidgets ??= workingChoices
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
                  submitSelectedItem();
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

  /// Build the content to show in the popup view.
  Widget buildPopupContent(BuildContext context,
      OverlayPortalController controller, ThemeData theme) {
    var selectedColor = Colors.grey; // = theme.colorScheme.surfaceContainerLow;

    return ListenableBuilder(
      // Rebuilds whenever selected item changes
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
                child: Container(
                    width: 200,
                    height: 200,
                    color: theme.colorScheme.surfaceContainer,
                    child: Material(
                        child: ListView.builder(
                      controller: _scrollController,
                      itemCount: workingChoices.length,
                      itemBuilder: (context, index) => builderPopupItem(
                          context, index, controller, selectedColor),
                    )))));
      },
    );
  }

  /// Generates a widget for a single item in the popup list.
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
