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

  Widget? builderForSingleItems(BuildContext context, int index) {
    var item = widget.list.listItems[index];

    return ListTile(
      title: embodifySingleItem(context, item),
      onTap: () {
        setCurrentSelected(index);
      },
    );
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

  Widget? builderForCardItems(BuildContext context, int index) {
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
      onTap: () {
        setCurrentSelected(index);
      },
    );
  }

  NullableIndexedWidgetBuilder? mapToBuilderFunction() {
    var embodiment = widget.embodimentProps.embodiment;

    switch (embodiment) {
      case 'normal-list':
        return builderForSingleItems;
      case 'card-list':
        return builderForCardItems;
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

    // We use an Expanded widget for the case when there is a Column or ListView parent,
    // which will cause an exception of non-zero flex but the vertical constraints are unbounded.
    // For a great explanation, refer to documentation on Column widget.  This video is also
    // helpful and amusing:  https://youtu.be/jckqXR5CrPI

    if (widget.parentWidgetType == "Row" ||
        widget.parentWidgetType == "Column") {
      return Flexible(
        child: ListView.builder(
            itemCount: widget.list.listItems.length, itemBuilder: builder),
      );
/*
      return SizedBox(
        width: 300,
        height: 300,
        child: ListView.builder(
            itemCount: widget.list.listItems.length, itemBuilder: builder),
      );
*/
    }

    return ListView.builder(
        itemCount: widget.list.listItems.length, itemBuilder: builder);
  }
}
