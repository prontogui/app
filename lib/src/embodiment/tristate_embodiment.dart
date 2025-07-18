// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'embodiment_help.dart';
import 'properties.dart';
import '../embodifier.dart';

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
    var embodifier = InheritedEmbodifier.of(context);

    Widget cb = Checkbox(
      value: widget.tristate.stateAsBool,
      onChanged: (bool? value) {
        setCurrentState(value);
      },
      tristate: true,
    );

    final label = widget.tristate.label;
    final labelItem = widget.tristate.labelItem;

    List<Widget> itemElements = [];

    if (labelItem != null) {
      itemElements.add( _embodifyLabelItem(context, embodifier, labelItem));
    }

    if (label.isNotEmpty) {
      itemElements.add(Text(label));
    }

    // Trivial case where just a checkbox by itself with no associated item?
    if (itemElements.isEmpty) {
      return encloseWithPBMSAF(itemElements[0], widget.args);
    }

    late Widget itemContent;

    if (itemElements.length == 1) {
      itemContent = GestureDetector(child: itemElements[0], onTap: () => nextState(),);
    } else {
      itemContent = GestureDetector(child: Row(children: itemElements,), onTap: () => nextState(),);
    }

    var content = Row(mainAxisSize: MainAxisSize.min, children: [cb, itemContent]);

    return encloseWithPBMSAF(content, widget.args, verticalUnbounded: true);

  }
}

// The allowed primitives for the label item
const Set<String> _allowedTypesForLabelItem = {
  'Icon',
  'Image',
  'Text'
};

Widget _embodifyLabelItem(BuildContext context, Embodifier embodifier, pg.Primitive item) {

  // Only certain primitives are supported
  if (!_allowedTypesForLabelItem.contains(item.describeType)) {
    // TODO:  show something better for error case.  Perhaps log an error also.
    return const SizedBox(
      child: Text("?"),
    );
  }

  return embodifier.buildPrimitive(context, item);
}


