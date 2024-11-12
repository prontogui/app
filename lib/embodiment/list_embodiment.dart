// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import '../facilities/embodifier.dart';
import 'package:flutter/material.dart';
import '../embodiment_properties/list_embodiment_properties.dart';

class ListEmbodiment extends StatefulWidget {
  ListEmbodiment(
      {super.key,
      required this.list,
      required Map<String, dynamic>? embodimentMap,
      required this.parentWidgetType})
      : embodimentProps = ListEmbodimentProperties.fromMap(embodimentMap);

  final pg.ListP list;
  final ListEmbodimentProperties embodimentProps;
  final String parentWidgetType;

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
    if (item is! pg.Text && item is! pg.Command && item is! pg.Check) {
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
    var item = widget.list.listItems[index];

    if (item is! pg.Group) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text("?"),
      );
    }

    var groupItem = item as pg.Group;
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

  NullableIndexedWidgetBuilder? mapToBuilderFunction() {
    var embodiment = widget.embodimentProps.embodiment;

    switch (embodiment) {
      case 'normal-list':
        return builderForSingleItem;
      case 'card-list':
        return builderForCardItem;
      default:
        return null;
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
    var props = widget.embodimentProps;

    Widget content = ListView.builder(
        itemCount: widget.list.listItems.length, itemBuilder: builder);

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
