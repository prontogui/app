// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import '../embodifier.dart';
import 'package:flutter/material.dart';
import 'embodiment_interface.dart';
import 'common_properties.dart';
import 'embodiment_property_help.dart';
import 'tabbed_list_embodiment.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('List', [
    EmbodimentManifestEntry('default', (args) {
      return ListEmbodiment(
          key: args.key,
          list: args.primitive as pg.ListP,
          props: ListEmbodimentProperties.fromMap(args.embodimentMap),
          parentWidgetType: args.parentWidgetType,
          style: ListStyle.normal);
    }),
    EmbodimentManifestEntry('card-list', (args) {
      return ListEmbodiment(
          key: args.key,
          list: args.primitive as pg.ListP,
          props: ListEmbodimentProperties.fromMap(args.embodimentMap),
          parentWidgetType: args.parentWidgetType,
          style: ListStyle.card);
    }),
    EmbodimentManifestEntry('property-list', (args) {
      return ListEmbodiment(
          key: args.key,
          list: args.primitive as pg.ListP,
          props: ListEmbodimentProperties.fromMap(args.embodimentMap),
          parentWidgetType: args.parentWidgetType,
          style: ListStyle.property);
    }),
    EmbodimentManifestEntry('tabbed-list', (args) {
      return TabbedListEmbodiment(
        key: args.key,
        list: args.primitive as pg.ListP,
        props: TabbedListEmbodimentProperties.fromMap(args.embodimentMap),
        parentWidgetType: args.parentWidgetType,
      );
    }),
  ]);
}

enum ListStyle { card, property, normal, tabbed }

class ListEmbodiment extends StatefulWidget {
  const ListEmbodiment(
      {super.key,
      required this.list,
      required this.props,
      required this.parentWidgetType,
      required this.style});

  final pg.ListP list;
  final ListEmbodimentProperties props;
  final String parentWidgetType;
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
        item is! pg.NumericField) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text("?"),
      );
    }

    return embodifier!.buildPrimitive(context, item, "ListTile");
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

    if (!props.width.isNaN && !props.height.isNaN) {
      content = SizedBox(
        width: props.width,
        height: props.height,
        child: content,
      );
    } else if (!props.width.isNaN) {
      content = SizedBox(
        width: props.width,
        child: content,
      );
    } else if (!props.height.isNaN) {
      content = SizedBox(
        height: props.height,
        child: content,
      );
    }

    return encloseInFlexibleIfNeeded(content);
  }

  Widget encloseInFlexibleIfNeeded(Widget content) {
    var pwt = widget.props.horizontal ? "Row" : "Column";

    if (widget.parentWidgetType == pwt && content is! SizedBox) {
      return Flexible(
        child: content,
      );
    }

    return content;
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
    tabHeight = getNumericProp(embodimentMap, 'tabHeight');
  }
}
