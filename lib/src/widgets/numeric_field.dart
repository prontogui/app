import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericField extends StatefulWidget {
  const NumericField({super.key, required this.onSubmitted, this.initialValue});

  /// Handler for new values submitted after entering them.
  final void Function(String value) onSubmitted;

  /// The initial value (optional).
  final String? initialValue;

  @override
  State<NumericField> createState() => _NumericFieldState();
}

class _NumericFieldState extends State<NumericField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late RegExp _allowedInputPattern;
  late TextInputFormatter _inputFmt;

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
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasPrimaryFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    _controller.text = prepareInitialValue();
    _submittedValue = null;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration? decor;

    if (_hasFocus) {
      decor = const InputDecoration(border: OutlineInputBorder());
    }

    return Container(
        color: Colors.white,
        child: TextField(
          controller: _controller,
          decoration: decor,
          onSubmitted: (value) => storeValue(value),
          focusNode: _focusNode,
          inputFormatters: [_inputFmt],
        ));
  }
}
