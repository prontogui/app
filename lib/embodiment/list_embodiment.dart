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

class ListEmbodiment extends StatefulWidget {
  const ListEmbodiment({super.key, required this.list});

  final pri.ListP list;

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

  Widget? builderForTextItems(BuildContext context, int index) {
    var item = widget.list.listItems[index];

    if (item is! pri.Text) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text("?"),
      );
    }

    var text = item as pri.Text;

    return ListTile(
      title: Text(text.content),
      onTap: () {
        setCurrentSelected(index);
      },
    );
  }

  Widget? embodifyGroupItem(BuildContext context, pri.Group group,
      pri.Group template, int itemIndex) {
    if (itemIndex >= group.groupItems.length ||
        itemIndex >= template.groupItems.length) {
      return null;
    }

    var groupItem = group.groupItems[itemIndex];
    var templateItem = template.groupItems[itemIndex];

    // Only certain primitives are supported
    if (templateItem is! pri.Text &&
        groupItem is! pri.Command &&
        templateItem is! pri.Check) {
      return null;
    }

    return embodifier!.buildPrimitive(context, groupItem, templateItem);
  }

  Widget? builderForGroupItems(BuildContext context, int index) {
    var item = widget.list.listItems[index];
    var template = widget.list.templateItem as pri.Group;

    if (item is! pri.Group) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text("?"),
      );
    }

    var groupItem = item as pri.Group;
    var leading = embodifyGroupItem(context, groupItem, template, 0);
    var title = embodifyGroupItem(context, groupItem, template, 1);
    var subtitle = embodifyGroupItem(context, groupItem, template, 2);
    var trailing = embodifyGroupItem(context, groupItem, template, 3);

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

  NullableIndexedWidgetBuilder? mapTemplateItemToBuilderFunction(
      pri.Primitive? templateItem) {
    // Text primitive?
    if (templateItem is pri.Text) {
      return builderForTextItems;

      // Group primitive?
    } else if (templateItem is pri.Group) {
      return builderForGroupItems;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the right ListView builder based on the List primitive TemplateItem.
    var builder = mapTemplateItemToBuilderFunction(widget.list.templateItem);

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
    return Expanded(
      child: ListView.builder(
          itemCount: widget.list.listItems.length, itemBuilder: builder),
    );
  }
}
