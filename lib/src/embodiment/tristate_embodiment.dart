// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TristateEmbodiment extends StatefulWidget {
  const TristateEmbodiment({super.key, required this.tristate});

  final pg.Tristate tristate;

  @override
  State<TristateEmbodiment> createState() {
    return _TristateEmbodimentState();
  }
}

class _TristateEmbodimentState extends State<TristateEmbodiment> {
  void setCurrentState(bool? newState) {
    setState(() {
      widget.tristate.stateAsBool = newState;
    });
  }

  void nextState() {
    setState(() {
      widget.tristate.nextState();
    });
  }

  @override
  Widget build(BuildContext context) {
    var cb = Checkbox(
      value: widget.tristate.stateAsBool,
      onChanged: (bool? value) {
        setCurrentState(value);
      },
      tristate: true,
    );

    final label = widget.tristate.label;

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
