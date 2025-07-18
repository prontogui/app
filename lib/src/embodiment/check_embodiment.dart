// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/src/embodiment/embodiment_help.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'properties.dart';
import '../embodifier.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Check', [
    EmbodimentManifestEntry(
        'default', CheckEmbodiment.fromArgs, CommonProperties.fromMap),
  ]);
}

class CheckEmbodiment extends StatefulWidget {
  CheckEmbodiment.fromArgs(this.args, {super.key})
      : check = args.primitive as pg.Check;

  final EmbodimentArgs args;
  final pg.Check check;

  @override
  State<CheckEmbodiment> createState() {
    return _CheckEmbodimentState();
  }
}

class _CheckEmbodimentState extends State<CheckEmbodiment> {
  void setCurrentChecked(bool newChecked) {
    setState(() {
      widget.check.checked = newChecked;
    });
  }

  void nextState() {
    setState(() {
      widget.check.nextState();
    });
  }

  @override
  Widget build(BuildContext context) {
    var embodifier = InheritedEmbodifier.of(context);

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
    final labelItem = widget.check.labelItem;

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

