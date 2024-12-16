// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import '../embodifier.dart';
import 'package:flutter/material.dart';
import 'embodiment_interface.dart';
import 'common_properties.dart';
import 'embodiment_property_help.dart';

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
  ]);
}

enum ListStyle { card, property, normal }

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

    return ListTile(
      title: embodifySingleItem(context, item),
      selected: index == widget.list.selected,
      isThreeLine: false,
      onTap: () {
        setCurrentSelected(index);
      },
    );
  }

  Widget? builderForCardItem(BuildContext context, int index) {
    var groupItem = widget.list.listItems[index];

    if (groupItem is! pg.Group) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text("?"),
      );
    }

    var leading = embodifyGroupItem(context, groupItem, 0);
    var title = embodifyGroupItem(context, groupItem, 1);
    var subtitle = embodifyGroupItem(context, groupItem, 2);
    var trailing = embodifyGroupItem(context, groupItem, 3);

    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      selected: index == widget.list.selected,
      onTap: () {
        setCurrentSelected(index);
      },
    );
  }

  Widget? builderForPropertyItem(BuildContext context, int index) {
    var groupItem = widget.list.listItems[index];

    if (groupItem is! pg.Group) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text("?"),
      );
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

  NullableIndexedWidgetBuilder? mapToBuilderFunction() {
    switch (widget.style) {
      case ListStyle.normal:
        return builderForSingleItem;
      case ListStyle.card:
        return builderForCardItem;
      case ListStyle.property:
        return builderForPropertyItem;
    }
  }

  @override
  Widget build(BuildContext context) {
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

    // Grab the embodifier for other functions in the class to use.
    embodifier ??= InheritedEmbodifier.of(context);
    // var props = widget.embodimentProps;

    Widget content = ListView.builder(
        itemCount: widget.list.listItems.length, itemBuilder: builder);

    var props = widget.props;

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

    if (widget.parentWidgetType == "Column" && content is! SizedBox) {
      content = Flexible(
        child: content,
      );
    }

    return content;
  }
}

class ListEmbodimentProperties with CommonProperties {
  String embodiment;

  static final Set<String> _validEmbodiments = {
    'card-list',
    'normal-list',
    'property-list'
  };

  ListEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap)
      : embodiment = getEnumStringProp(
            embodimentMap, 'embodiment', 'normal-list', _validEmbodiments) {
    super.initializeFromMap(embodimentMap);
  }
}
