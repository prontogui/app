// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/check.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CheckEmbodiment extends StatefulWidget {
  const CheckEmbodiment({super.key, required this.check});

  final Check check;

  @override
  State<CheckEmbodiment> createState() {
    return _CheckEmbodimentState();
  }
}

class _CheckEmbodimentState extends State<CheckEmbodiment> {
  void setCurrentChecked(bool newChecked) {
    setState(() {
      widget.check.updateChecked(newChecked);
    });
  }

  void nextState() {
    setState(() {
      widget.check.nextState();
    });
  }

  @override
  Widget build(BuildContext context) {
    var cb = Checkbox(
      value: widget.check.checked,
      onChanged: (bool? value) {
        if (value == null) {
          setCurrentChecked(false);
        } else {
          setCurrentChecked(value);
        }
      },
      tristate: false,
    );

    final label = widget.check.label;

    if (label.isNotEmpty) {
      // Use a RichText / TextSpan combo so user can click on the text to change state.
      var textSpan = TextSpan(
          text: label,
          style: DefaultTextStyle.of(context).style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              nextState();
            });

      var richText = RichText(text: textSpan);

      return Row(
        children: [cb, richText],
      );
    } else {
      return cb;
    }
  }
}
