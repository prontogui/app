// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import '../embodifier.dart';
import 'package:flutter/material.dart';
import 'embodiment_manifest.dart';
import 'common_properties.dart';
import 'embodiment_property_help.dart';
import 'tabbed_list_embodiment.dart';
import 'embodiment_help.dart';
import 'embodiment_args.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('List', [
    EmbodimentManifestEntry('default', ListEmbodiment.fromArgsNormalStyle),
    EmbodimentManifestEntry('card-list', ListEmbodiment.fromArgsCardStyle),
    EmbodimentManifestEntry(
        'property-list', ListEmbodiment.fromArgsPropertyStyle),
    EmbodimentManifestEntry('tabbed-list', TabbedListEmbodiment.fromArgs),
  ]);
}

enum ListStyle { card, property, normal, tabbed }

class ListEmbodiment extends StatefulWidget {
  ListEmbodiment.fromArgsNormalStyle(this.args, {super.key})
      : list = args.primitive as pg.ListP,
        props = ListEmbodimentProperties.fromMap(
            args.primitive.embodimentProperties),
        style = ListStyle.normal;
  ListEmbodiment.fromArgsPropertyStyle(this.args, {super.key})
      : list = args.primitive as pg.ListP,
        props = ListEmbodimentProperties.fromMap(
            args.primitive.embodimentProperties),
        style = ListStyle.property;
  ListEmbodiment.fromArgsCardStyle(this.args, {super.key})
      : list = args.primitive as pg.ListP,
        props = ListEmbodimentProperties.fromMap(
            args.primitive.embodimentProperties),
        style = ListStyle.card;

  final EmbodimentArgs args;
  final pg.ListP list;
  final ListEmbodimentProperties props;
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
      widget.list.selected = newSelected;
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
      selected: index == widget.list.selected,
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
      selected: index == widget.list.selected,
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

    // Note regarding unbounded nature of ListView widget:
    //
    // This Flutter error, "Vertical viewport was given unbounded width," means
    // that a scrollable widget like a ListView is placed inside a layout that
    // doesn't provide any horizontal constraints, allowing it to expand infinitely
    // wide, which is causing the layout system to fail.
    //
    // This means that vertically scrolling list are unbounded in the horizontal direction
    // and vice versa.

    return encloseWithSizingAndBounding(content, props, widget.parentWidgetType,
        useExpanded: true,
        verticalUnbounded: true,
        horizontalUnbounded: !horizontal);
  }
}

class ListEmbodimentProperties with CommonProperties {
  late final bool horizontal;
  late final double? itemWidth;
  late final double? itemHeight;
  late final double? tabHeight;

  ListEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap) {
    super.fromMap(embodimentMap);

    horizontal = getBoolPropOrDefault(embodimentMap, 'horizontal', false);
    itemWidth = getNumericProp(embodimentMap, 'itemWidth');
    itemHeight = getNumericProp(embodimentMap, 'itemHeight');
  }
}
