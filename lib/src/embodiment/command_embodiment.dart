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
  return EmbodimentPackageManifest('Command', [
    EmbodimentManifestEntry('default', ElevatedButtonCommandEmbodiment.fromArgs,
        CommonProperties.fromMap),
    EmbodimentManifestEntry('outlined-button',
        OutlinedButtonCommandEmbodiment.fromArgs, CommonProperties.fromMap),
  ]);
}

class ElevatedButtonCommandEmbodiment extends StatelessWidget {
  const ElevatedButtonCommandEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  Widget _buildAsHidden(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    var command = args.primitive as pg.Command;
    var embodifier = InheritedEmbodifier.of(context);

    // Is the command hidden?
    if (command.status == 2) {
      return _buildAsHidden(context);
    }

    final label = command.label;
    final labelItem = command.labelItem;

    List<Widget> itemElements = [];

    if (labelItem != null) {
      itemElements.add( _embodifyLabelItem(context, embodifier, labelItem));
    }

    if (label.isNotEmpty) {
      itemElements.add(Text(label));
    }

    late Widget? innerContent;

    if (itemElements.isEmpty) {
      innerContent = null;
    } else if (itemElements.length == 1) {
      innerContent = itemElements[0];
    } else {
      // Note: for some reason, ElevatedButton expands to biggest vertical space possible when labelItem is an Image. The 
      // following is a work-around. This behavior doesn't happen then labelItem is null, Text, or Icon.
      innerContent = FittedBox(fit: BoxFit.fitHeight, child: Row(mainAxisSize: MainAxisSize.min, children: itemElements)) ;
    }

    var content = ElevatedButton(
      onPressed: command.issueNow,
      child: innerContent,
    );

    return encloseWithPBMSAF(content, args);
  }
}

class OutlinedButtonCommandEmbodiment extends StatelessWidget {
  const OutlinedButtonCommandEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  Widget _buildAsHidden(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    var command = args.primitive as pg.Command;
    var embodifier = InheritedEmbodifier.of(context);

    // Is the command hidden?
    if (command.status == 2) {
      return _buildAsHidden(context);
    }


    final label = command.label;
    final labelItem = command.labelItem;

    List<Widget> itemElements = [];

    if (labelItem != null) {
      itemElements.add( _embodifyLabelItem(context, embodifier, labelItem));
    }

    if (label.isNotEmpty) {
      itemElements.add(Text(label));
    }

    late Widget? innerContent;

    if (itemElements.isEmpty) {
      innerContent = null;
    } else if (itemElements.length == 1) {
      innerContent = itemElements[0];
    } else {
      // Note: for some reason, ElevatedButton expands to biggest vertical space possible when labelItem is an Image. The 
      // following is a work-around. This behavior doesn't happen then labelItem is null, Text, or Icon.
      innerContent = FittedBox(fit: BoxFit.fitHeight, child: Row(mainAxisSize: MainAxisSize.min, children: itemElements)) ;
    }

    var content = OutlinedButton(
      onPressed: command.issueNow,
      child: innerContent,
    );

    return encloseWithPBMSAF(content, args);
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
