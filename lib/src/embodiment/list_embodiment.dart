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
        props = args.properties as ListDefaultProperties,
        style = ListStyle.normal;

  final EmbodimentArgs args;
  final ListDefaultProperties props;
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
      widget.list.selectedIndex = newSelected;
    });
  }

  static const Set<String> _singleItemTypes = {
    'Text',
    'Command',
    'Check',
    'Choice',
    'TextField',
    'NumericField',
    'Card',
    'Group',
    'Icon'
  };

  Widget? builder(BuildContext context, int index) {
    var item = widget.list.listItems[index];

    late Widget content;
    if (_singleItemTypes.contains(item.describeType)) {
      bool isSelected(List<int> indices) {
        return widget.list.selectedIndex == indices[0];
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
        horizontalUnbounded: widget.props.horizontal,
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

    var horizontal = widget.props.horizontal;
    var scrollDirection = horizontal ? Axis.horizontal : Axis.vertical;

    Widget content = ListView.builder(
      itemCount: widget.list.listItems.length,
      itemBuilder: builder,
      scrollDirection: scrollDirection,
    );

    return encloseWithPBMSAF(content, widget.args,
        verticalUnbounded: true, horizontalUnbounded: !horizontal);
  }
}
