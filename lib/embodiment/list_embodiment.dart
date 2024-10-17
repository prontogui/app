// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/list.dart' as pri;
import 'package:app/primitive/group.dart' as pri;
import 'package:app/primitive/command.dart' as pri;
import 'package:app/primitive/check.dart' as pri;
import 'package:app/primitive/primitive.dart' as pri;
import 'embodifier.dart';
import 'package:flutter/material.dart';
import 'package:app/primitive/text.dart' as pri;
import '../embodiment_properties/list_embodiment_properties.dart';

class ListEmbodiment extends StatefulWidget {
  ListEmbodiment(
      {super.key,
      required this.list,
      required Map<String, dynamic>? embodimentMap,
      required this.parentWidgetType})
      : embodimentProps = ListEmbodimentProperties.fromMap(embodimentMap);

  final pri.ListP list;
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
      widget.list.updateSelected(newSelected);
    });
  }

  Widget? embodifySingleItem(BuildContext context, pri.Primitive item) {
    // Only certain primitives are supported
    if (item is! pri.Text && item is! pri.Command && item is! pri.Check) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text("?"),
      );
    }

    return embodifier!.buildPrimitive(context, item, "ListTile");
  }

  Widget? embodifyGroupItem(
      BuildContext context, pri.Group group, int itemIndex) {
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

    if (item is! pri.Group) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text("?"),
      );
    }

    var groupItem = item as pri.Group;
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
    embodifier ??= Embodifier.of(context);
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
