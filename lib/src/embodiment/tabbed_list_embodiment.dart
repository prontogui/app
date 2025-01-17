// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/src/embodiment/embodiment_help.dart';
import 'package:dartlib/dartlib.dart' as pg;
import '../embodifier.dart';
import 'package:flutter/material.dart';
import 'common_properties.dart';
import 'embodiment_property_help.dart';
import 'icon_map.dart';

class TabbedListEmbodiment extends StatelessWidget {
  const TabbedListEmbodiment({
    super.key,
    required this.list,
    required this.props,
    required this.parentWidgetType,
  });

  final pg.ListP list;
  final TabbedListEmbodimentProperties props;
  final String parentWidgetType;

  Widget embodifySingleItem(BuildContext context, Embodifier embodifier,
      pg.Primitive item, String parentWidgetType) {
    // Only certain primitives are supported
    if (item is! pg.Text &&
        item is! pg.Command &&
        item is! pg.Check &&
        item is! pg.Choice &&
        item is! pg.NumericField) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text('?'),
      );
    }

    return embodifier.buildPrimitive(context, item, parentWidgetType);
  }

  @override
  Widget build(BuildContext context) {
    // Grab the embodifier for other functions in the class to use.
    var embodifier = InheritedEmbodifier.of(context);

    var listItems = list.listItems;

    // Verify that list contains only Frame primitives
    if (listItems.indexWhere((p) => p.describeType != 'Frame') != -1) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text("?"),
      );
    }

    // Build the tabs based on frame's icon and title fields.
    var tabs = List<Tab>.generate(listItems.length, (i) {
      var item = listItems[i];
      assert(item is pg.Frame);
      var frame = item as pg.Frame;

      // If being used, embodify the icon primitive into the Tab.
      if (frame.icon != null) {
        var p = frame.icon as pg.Primitive;
        if (p.describeType == 'Icon') {
          var iconPrimitive = p as pg.Icon;
          return Tab(
            text: frame.title,
            icon: Icon(translateIdToIconData(iconPrimitive.iconID)),
          );
        } else {
          return Tab(
              text: frame.title,
              child: embodifySingleItem(context, embodifier, p, 'Column'));
        }
      }
      return Tab(text: frame.title);
    });

    var tabViews = List<Widget>.generate(listItems.length, (i) {
      return embodifier.buildPrimitive(context, listItems[i], "TabBarView");
    });

    var tabHeight = props.tabHeight;

    var content = DefaultTabController(
        length: tabs.length,
        animationDuration: props.animationPeriod,
        child: Column(
          children: [
            SizedBox(
              height: tabHeight,
              child: TabBar(
                tabs: tabs,
              ),
            ),
            Expanded(child: TabBarView(children: tabViews))
          ],
        ));
    return encloseWithSizingAndBounding(content, props, parentWidgetType,
        verticalUnbounded: true);
  }
}

class TabbedListEmbodimentProperties with CommonProperties {
  late final double? tabHeight;
  Duration? animationPeriod;

  TabbedListEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap) {
    super.fromMap(embodimentMap);

    tabHeight = getNumericProp(embodimentMap, 'tabHeight');
    var period = getIntProp(embodimentMap, 'animationPeriod', 0, 5000);
    if (period != null) {
      animationPeriod = Duration(milliseconds: period);
    }
  }
}
