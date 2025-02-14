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
    EmbodimentManifestEntry('default', GroupDefaultEmbodiment.fromArgs),
    EmbodimentManifestEntry('tile', GroupTileEmbodiment.fromArgs),
    EmbodimentManifestEntry('card', GroupCardEmbodiment.fromArgs),
  ]);
}

class GroupDefaultEmbodiment extends StatelessWidget {
  GroupDefaultEmbodiment.fromArgs(this.args, {super.key})
      : group = args.primitive as pg.Group,
        props = CommonProperties.fromMap(args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.Group group;
  final CommonProperties props;

  @override
  Widget build(BuildContext context) {
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
          child: InheritedEmbodifier.of(context)
              .buildPrimitive(context, EmbodimentArgs(group.groupItems[0])));
    } else {
      content = Row(
        children:
            // This is very elegant but we'll see how it performs.  Documentation says
            // stuff in .of method should work in O(1) time with a "small constant".
            // An alternative approach is to pass Embodifier into constructor of each
            // embodiment.
            InheritedEmbodifier.of(context).buildPrimitiveList(
                context, group.groupItems,
                horizontalUnbounded: true),
      );
    }

    return encloseWithPBMSAF(content, props, args, verticalUnbounded: true);
  }
}

Widget? _embodifySingleItem(
    BuildContext context, Embodifier embodifier, pg.Primitive item) {
  // Only certain primitives are supported
  if (item is! pg.Text &&
      item is! pg.Command &&
      item is! pg.Check &&
      item is! pg.Choice &&
      item is! pg.TextField &&
      item is! pg.NumericField) {
    // TODO:  show something better for error case.  Perhaps log an error also.
    return const SizedBox(
      child: Text("?"),
    );
  }

  return embodifier.buildPrimitive(context, EmbodimentArgs(item));
}

Widget? _embodifyGroupItem(BuildContext context, Embodifier embodifier,
    pg.Group group, int itemIndex) {
  if (itemIndex >= group.groupItems.length) {
    return null;
  }

  var groupItem = group.groupItems[itemIndex];

  return _embodifySingleItem(context, embodifier, groupItem);
}

class GroupTileEmbodiment extends StatelessWidget {
  GroupTileEmbodiment.fromArgs(this.args, {super.key})
      : group = args.primitive as pg.Group,
        props = CommonProperties.fromMap(
          args.primitive.embodimentProperties,
        );

  final EmbodimentArgs args;
  final pg.Group group;
  final CommonProperties props;

  @override
  Widget build(BuildContext context) {
    var embodifier = InheritedEmbodifier.of(context);

    // Is group hidden?
    if (!group.visible) {
      return const SizedBox.shrink();
    }

    var leading = _embodifyGroupItem(context, embodifier, group, 0);
    var title = _embodifyGroupItem(context, embodifier, group, 1);
    var subtitle = _embodifyGroupItem(context, embodifier, group, 2);
    var trailing = _embodifyGroupItem(context, embodifier, group, 3);
    var selected = false;
    if (args.isSelected != null) {
      selected = args.isSelected!(args.id);
    }
    void Function()? handleTap;
    if (args.onSelection != null) {
      handleTap = () {
        args.onSelection!(args.id);
      };
    }
    var content = ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      selected: selected,
      onTap: handleTap,
    );

    return encloseWithPBMSAF(content, props, args, verticalUnbounded: true);
  }
}

class GroupCardEmbodiment extends StatelessWidget {
  GroupCardEmbodiment.fromArgs(this.args, {super.key})
      : group = args.primitive as pg.Group,
        props = CommonProperties.fromMap(
          args.primitive.embodimentProperties,
        );

  final EmbodimentArgs args;
  final pg.Group group;
  final CommonProperties props;

  @override
  Widget build(BuildContext context) {
    var embodifier = InheritedEmbodifier.of(context);

    // Is group hidden?
    if (!group.visible) {
      return const SizedBox.shrink();
    }

    var leading = _embodifyGroupItem(context, embodifier, group, 0);
    var title = _embodifyGroupItem(context, embodifier, group, 1);
    var subtitle = _embodifyGroupItem(context, embodifier, group, 2);
    var trailing = _embodifyGroupItem(context, embodifier, group, 3);
    var selected = false;
    if (args.isSelected != null) {
      selected = args.isSelected!(args.id);
    }
    void Function()? handleTap;
    if (args.onSelection != null) {
      handleTap = () {
        args.onSelection!(args.id);
      };
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

    return encloseWithPBMSAF(content, props, args, verticalUnbounded: true);
  }
}
