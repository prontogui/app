// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import '../embodifier.dart';
import 'package:flutter/material.dart';
import 'embodiment_manifest.dart';
import 'tabbed_list_embodiment.dart';
import 'embodiment_help.dart';
import 'embodiment_args.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('List', [
    EmbodimentManifestEntry('default', ListDefaultEmbodiment.fromArgs,
        ListDefaultProperties.fromMap),
    EmbodimentManifestEntry(
        'tabbed', TabbedListEmbodiment.fromArgs, ListTabbedProperties.fromMap),
  ]);
}

enum ListStyle { card, property, normal, tabbed }

class ListDefaultEmbodiment extends StatefulWidget {
  ListDefaultEmbodiment.fromArgs(this.args, {super.key})
      : list = args.primitive as pg.ListP,
        style = ListStyle.normal;

  final EmbodimentArgs args;
  final pg.ListP list;
  final ListStyle style;

  @override
  State<ListDefaultEmbodiment> createState() {
    return _ListDefaultEmbodimentState();
  }
}

class _ListDefaultEmbodimentState extends State<ListDefaultEmbodiment> {
  Embodifier? embodifier;
  Map<String, dynamic>? modelProperties;

  void setCurrentSelected(int newSelected) {
    setState(() {
      widget.list.selection = newSelected;
    });
  }

  static const Set<String> _singleItemTypes = {
    'Text',
    'Command',
    'Check',
    'Choice',
    'TextField',
    'NumericField',
  };

  Widget? builder(BuildContext context, int index) {
    var item = widget.list.listItems[index];

    late Widget content;
    if (_singleItemTypes.contains(item.describeType)) {
      // Use a ListTile for selection support
      content = ListTile(
        title: embodifier!.buildPrimitive(context, item,
            modelPrimitive: widget.list.modelItem),
        selected: index == widget.list.selection,
        isThreeLine: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 2.0),
        onTap: () {
          setCurrentSelected(index);
        },
      );
    } else if (item is pg.Group) {
      bool isSelected(List<int> indices) {
        return widget.list.selection == indices[0];
      }

      void onSelection(List<int> indices) {
        setCurrentSelected(indices[0]);
      }

      var callbacks = EmbodimentCallbacks(List<int>.unmodifiable([index]),
          isSelected: isSelected, onSelection: onSelection);

      content = embodifier!.buildPrimitive(
        context,
        item,
        modelPrimitive: widget.list.modelItem,
        callbacks: callbacks,
      );
    } else {
      content = const SizedBox(
        child: Text("?"),
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    // Grab the embodifier for other functions in the class to use.
    embodifier ??= InheritedEmbodifier.of(context);

    var props = widget.args.properties as ListDefaultProperties;

    var scrollDirection = props.horizontal ? Axis.horizontal : Axis.vertical;

    Widget content = ListView.builder(
      itemCount: widget.list.listItems.length,
      itemBuilder: builder,
      scrollDirection: scrollDirection,
    );

    var horizontal = props.horizontal;

    return encloseWithPBMSAF(content, widget.args,
        verticalUnbounded: true, horizontalUnbounded: !horizontal);
  }
}

/*


EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('List', [
    EmbodimentManifestEntry('default', ListEmbodiment.fromArgsNormalStyle),
    EmbodimentManifestEntry('card', ListEmbodiment.fromArgsCardStyle),
    EmbodimentManifestEntry('property', ListEmbodiment.fromArgsPropertyStyle),
    EmbodimentManifestEntry('tabbed', TabbedListEmbodiment.fromArgs),
  ]);
}

enum ListStyle { card, property, normal, tabbed }

class ListEmbodiment extends StatefulWidget {
  ListEmbodiment.fromArgsNormalStyle(this.args, {super.key})
      : list = args.primitive as pg.ListP,
        props =
            ListNormalProperties.fromMap(args.primitive.embodimentProperties),
        style = ListStyle.normal;
  ListEmbodiment.fromArgsPropertyStyle(this.args, {super.key})
      : list = args.primitive as pg.ListP,
        props =
            ListNormalProperties.fromMap(args.primitive.embodimentProperties),
        style = ListStyle.property;
  ListEmbodiment.fromArgsCardStyle(this.args, {super.key})
      : list = args.primitive as pg.ListP,
        props =
            ListNormalProperties.fromMap(args.primitive.embodimentProperties),
        style = ListStyle.card;

  final EmbodimentArgs args;
  final pg.ListP list;
  final ListNormalProperties props;
  final ListStyle style;

  @override
  State<ListEmbodiment> createState() {
    return _ListEmbodimentState();
  }
}

class _ListEmbodimentState extends State<ListEmbodiment> {
  Embodifier? embodifier;

  void setCurrentSelected(int newSelected) {
    setState(() {
      widget.list.selection = newSelected;
    });
  }

  Widget? embodifySingleItem(BuildContext context, pg.Primitive item) {
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

    return embodifier!.buildPrimitive(context, EmbodimentArgs(item));
  }

  Widget? embodifyGroupItem(
      BuildContext context, pg.Group group, int itemIndex) {
    if (itemIndex >= group.groupItems.length) {
      return null;
    }

    var groupItem = group.groupItems[itemIndex];

    return embodifySingleItem(context, groupItem);
  }

  Widget? builderForSingleItem(BuildContext context, int index) {
    var item = widget.list.listItems[index];
    var content = ListTile(
      title: embodifySingleItem(context, item),
      selected: index == widget.list.selection,
      isThreeLine: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 2.0),
      onTap: () {
        setCurrentSelected(index);
      },
    );
    return sizeListItem(content);
  }

  Widget? builderForCardItem(BuildContext context, int index) {
    var groupItem = widget.list.listItems[index];

    if (groupItem is! pg.Group) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text("?"),
      );
    }

    // Is group hidden?
    if (!groupItem.visible) {
      return const SizedBox.shrink();
    }

    var leading = embodifyGroupItem(context, groupItem, 0);
    var title = embodifyGroupItem(context, groupItem, 1);
    var subtitle = embodifyGroupItem(context, groupItem, 2);
    var trailing = embodifyGroupItem(context, groupItem, 3);

    var content = ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      selected: index == widget.list.selection,
      onTap: () {
        setCurrentSelected(index);
      },
    );

    return sizeListItem(content);
  }

  Widget? builderForPropertyItem(BuildContext context, int index) {
    var groupItem = widget.list.listItems[index];

    if (groupItem is! pg.Group) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text("?"),
      );
    }

    // Is group hidden?
    if (!groupItem.visible) {
      return const SizedBox.shrink();
    }

    var propLabel = embodifyGroupItem(context, groupItem, 0);
    var propValue = embodifyGroupItem(context, groupItem, 1);

    return Row(
      children: [
        Expanded(
            child: Align(alignment: Alignment.centerLeft, child: propLabel)),
        Expanded(
            child: Align(alignment: Alignment.centerRight, child: propValue)),
      ],
    );
  }

  // Encloses a list item with a sized box when item height or width is specified,
  // or if atleast a width must be specified for horizontal list.
  Widget sizeListItem(Widget content) {
    var width = widget.props.itemWidth;
    var height = widget.props.itemHeight;

    if (widget.props.horizontal && width == null) {
      // Reasonable default when horizontal and width not specified
      width = 100;
    }

    if (width != null || height != null) {
      content = SizedBox(
        width: width,
        height: height,
        child: content,
      );
    }

    return content;
  }

  NullableIndexedWidgetBuilder? mapToBuilderFunction() {
    assert(widget.style != ListStyle.tabbed);
    switch (widget.style) {
      case ListStyle.normal:
        return builderForSingleItem;
      case ListStyle.card:
        return builderForCardItem;
      case ListStyle.property:
        return builderForPropertyItem;
      case ListStyle.tabbed:
        assert(false);
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Grab the embodifier for other functions in the class to use.
    embodifier ??= InheritedEmbodifier.of(context);

    // Determine the right ListView builder based on the List primitive TemplateItem.
    var builder = mapToBuilderFunction();

    if (builder == null) {
      // TODO:  show an error box and log an error
      return const SizedBox(
        child: Text("{No Template Item}",
            style: TextStyle(
              backgroundColor: Colors.red,
              color: Colors.white,
            )),
      );
    }

    var props = widget.props;

    var scrollDirection = props.horizontal ? Axis.horizontal : Axis.vertical;

    Widget content = ListView.builder(
      itemCount: widget.list.listItems.length,
      itemBuilder: builder,
      scrollDirection: scrollDirection,
    );

    var horizontal = props.horizontal;

    return encloseWithPBMSAF(content, props, widget.args,
        verticalUnbounded: true, horizontalUnbounded: !horizontal);
  }
}



*/
