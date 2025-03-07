// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../embodifier.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'embodiment_help.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Card', [
    EmbodimentManifestEntry(
        'default', CardDefaultEmbodiment.fromArgs, CommonProperties.fromMap),
    EmbodimentManifestEntry(
        'tile', CardTileEmbodiment.fromArgs, CommonProperties.fromMap),
  ]);
}

class CardDefaultEmbodiment extends StatelessWidget {
  const CardDefaultEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var content = Card.outlined(
      child: _buildTile(context, args),
    );

    return encloseWithPBMSAF(content, args, verticalUnbounded: true);
  }
}

class CardTileEmbodiment extends StatelessWidget {
  const CardTileEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var content = _buildTile(context, args);
    return encloseWithPBMSAF(content, args, verticalUnbounded: true);
  }
}

Widget _buildTile(BuildContext context, EmbodimentArgs args) {
  var card = args.primitive as pg.Card;
  var embodifier = InheritedEmbodifier.of(context);

  var modelPrimitive = args.modelPrimitive;

  pg.Card? modelCard;
  if (modelPrimitive != null && modelPrimitive is pg.Card) {
    modelCard = modelPrimitive;
  }

  var leading = _embodifySingleItem(
      context, embodifier, card.leadingItem, modelCard?.leadingItem);
  var title = _embodifySingleItem(
      context, embodifier, card.mainItem, modelCard?.mainItem);
  var subtitle = _embodifySingleItem(
      context, embodifier, card.subItem, modelCard?.subItem);
  var trailing = _embodifySingleItem(
      context, embodifier, card.trailingItem, modelCard?.trailingItem);

  // If callbacks are available, then handle selection state
  var selected = false;
  void Function()? handleTap;
  if (args.callbacks != null) {
    var cb = args.callbacks!;

    // If List selection is available...
    if (cb.isSelected != null) {
      selected = cb.isSelected!(cb.indices);
    }
    if (cb.onSelection != null) {
      handleTap = () {
        cb.onSelection!(cb.indices);
      };
    }
  }

  return ListTile(
    leading: leading,
    title: title,
    subtitle: subtitle,
    trailing: trailing,
    selected: selected,
    onTap: handleTap,
  );
}

// The allowed primitives for members of a card tile.
const Set<String> _allowedTypes = {
  'Text',
  'Command',
  'Check',
  'Choice',
  'TextField',
  'NumericField',
  'Nothing',
  'Icon'
};

Widget? _embodifySingleItem(BuildContext context, Embodifier embodifier,
    pg.Primitive? item, pg.Primitive? modelItem) {
  if (item == null) {
    return null;
  }
  // Only certain primitives are supported
  if (!_allowedTypes.contains(item.describeType)) {
    // TODO:  show something better for error case.  Perhaps log an error also.
    return const SizedBox(
      child: Text("?"),
    );
  }

  return embodifier.buildPrimitive(context, item, modelPrimitive: modelItem);
}
