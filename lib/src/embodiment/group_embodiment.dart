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
  return EmbodimentPackageManifest('Group', [
    EmbodimentManifestEntry(
        'default', GroupDefaultEmbodiment.fromArgs, CommonProperties.fromMap),
    EmbodimentManifestEntry(
        'tile', GroupTileEmbodiment.fromArgs, CommonProperties.fromMap),
    EmbodimentManifestEntry(
        'card', GroupCardEmbodiment.fromArgs, CommonProperties.fromMap),
  ]);
}

class GroupDefaultEmbodiment extends StatelessWidget {
  const GroupDefaultEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var group = args.primitive as pg.Group;

    if (group.groupItems.isEmpty || !group.visible) {
      return const SizedBox.shrink();
    }

    late Widget content;

    // Groups with only 1 item will degenerate to a SizedBox with just the item.  This
    // leads to immutable appearance of the primitive but also creates a notification
    // point at the Group level.  This can be handy to improve re-rendering performance
    // when only updating the child primitive because other children at the parent level
    // don't have to be re-rendered.  For a good example, look at the timer demo in
    // https://github.com/prontogui/goexamples
    if (group.groupItems.length == 1) {
      // TODO:  is SizedBox necessary or can we use a different widget or no widget??
      content = SizedBox(
          child: InheritedEmbodifier.of(context).buildPrimitive(
        context,
        group.groupItems[0],
      ));
    } else {
      List<pg.Primitive>? modelPrimitives;
      if (args.modelPrimitive != null) {
        var modelGroup = args.modelPrimitive as pg.Group;
        modelPrimitives = modelGroup.groupItems;
      }

      content = Row(
        children:
            // This is very elegant but we'll see how it performs.  Documentation says
            // stuff in .of method should work in O(1) time with a "small constant".
            // An alternative approach is to pass Embodifier into constructor of each
            // embodiment.
            InheritedEmbodifier.of(context).buildPrimitiveList(
                context, group.groupItems,
                modelPrimitives: modelPrimitives, horizontalUnbounded: true),
      );
    }

    return encloseWithPBMSAF(content, args, verticalUnbounded: true);
  }
}

Widget? _embodifySingleItem(BuildContext context, Embodifier embodifier,
    pg.Primitive item, pg.Primitive? modelItem) {
  // Only certain primitives are supported
  if (item is! pg.Text &&
      item is! pg.Command &&
      item is! pg.Check &&
      item is! pg.Choice &&
      item is! pg.TextField &&
      item is! pg.NumericField &&
      item is! pg.Nothing &&
      item is! pg.Icon) {
    // TODO:  show something better for error case.  Perhaps log an error also.
    return const SizedBox(
      child: Text("?"),
    );
  }

  return embodifier.buildPrimitive(context, item, modelPrimitive: modelItem);
}

Widget? _embodifyGroupItem(BuildContext context, Embodifier embodifier,
    pg.Group group, pg.Group? modelGroup, int itemIndex) {
  if (itemIndex >= group.groupItems.length) {
    return null;
  }

  pg.Primitive? modelItem;
  if (modelGroup != null) {
    var modelItems = modelGroup.groupItems;
    if (itemIndex < modelItems.length) {
      modelItem = modelItems[itemIndex];
    }
  }

  var groupItem = group.groupItems[itemIndex];

  return _embodifySingleItem(context, embodifier, groupItem, modelItem);
}

class GroupTileEmbodiment extends StatelessWidget {
  const GroupTileEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var group = args.primitive as pg.Group;

    var modelPrimitive = args.modelPrimitive;

    pg.Group? modelGroup;
    if (modelPrimitive != null && modelPrimitive is pg.Group) {
      modelGroup = modelPrimitive;
    }

    var embodifier = InheritedEmbodifier.of(context);

    // Is group hidden?
    if (!group.visible) {
      return const SizedBox.shrink();
    }

    var leading = _embodifyGroupItem(context, embodifier, group, modelGroup, 0);
    var title = _embodifyGroupItem(context, embodifier, group, modelGroup, 1);
    var subtitle =
        _embodifyGroupItem(context, embodifier, group, modelGroup, 2);
    var trailing =
        _embodifyGroupItem(context, embodifier, group, modelGroup, 3);
    var selected = false;
    void Function()? handleTap;

    // If callbacks are available...
    if (args.callbacks != null) {
      var cb = args.callbacks!;

      // If List selection is available...
      if (cb.isSelected != null) {
        selected = cb.isSelected!(cb.id);
      }
      if (cb.onSelection != null) {
        handleTap = () {
          cb.onSelection!(cb.id);
        };
      }
    }

    var content = ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      selected: selected,
      onTap: handleTap,
    );

    return encloseWithPBMSAF(content, args, verticalUnbounded: true);
  }
}

class GroupCardEmbodiment extends StatelessWidget {
  const GroupCardEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var group = args.primitive as pg.Group;
    var embodifier = InheritedEmbodifier.of(context);

    var modelPrimitive = args.modelPrimitive;

    pg.Group? modelGroup;
    if (modelPrimitive != null && modelPrimitive is pg.Group) {
      modelGroup = modelPrimitive;
    }

    // Is group hidden?
    if (!group.visible) {
      return const SizedBox.shrink();
    }

    var leading = _embodifyGroupItem(context, embodifier, group, modelGroup, 0);
    var title = _embodifyGroupItem(context, embodifier, group, modelGroup, 1);
    var subtitle =
        _embodifyGroupItem(context, embodifier, group, modelGroup, 2);
    var trailing =
        _embodifyGroupItem(context, embodifier, group, modelGroup, 3);
    var selected = false;
    void Function()? handleTap;

    // If callbacks are available...
    if (args.callbacks != null) {
      var cb = args.callbacks!;

      // If List selection is available...
      if (cb.isSelected != null) {
        selected = cb.isSelected!(cb.id);
      }
      if (cb.onSelection != null) {
        handleTap = () {
          cb.onSelection!(cb.id);
        };
      }
    }

    var content = Card.outlined(
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        selected: selected,
        onTap: handleTap,
      ),
    );

    return encloseWithPBMSAF(content, args, verticalUnbounded: true);
  }
}
