// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'embodiment_help.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Tristate', [
    EmbodimentManifestEntry(
        'default', TristateEmbodiment.fromArgs, CommonProperties.fromMap),
  ]);
}

class TristateEmbodiment extends StatefulWidget {
  TristateEmbodiment.fromArgs(this.args, {super.key})
      : tristate = args.primitive as pg.Tristate,
        props = args.properties as CommonProperties;

  final EmbodimentArgs args;
  final pg.Tristate tristate;
  final CommonProperties props;

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
    Widget content = Checkbox(
      value: widget.tristate.stateAsBool,
      onChanged: (bool? value) {
        setCurrentState(value);
      },
      tristate: true,
    );

    final label = widget.tristate.label;
    bool verticalUnbounded = false;

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

      content = Row(
        children: [content, richText],
      );
      verticalUnbounded = true;
    }

    return encloseWithPBMSAF(content, widget.args,
        verticalUnbounded: verticalUnbounded);
  }
}
