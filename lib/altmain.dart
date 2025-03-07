// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:io';

import 'package:app/src/embodiment/choice_embodiment.dart';
import 'package:app/src/embodiment/text_embodiment.dart';
import 'package:app/src/widgets/numeric_field.dart';
import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as dl;
import 'src/inherited_primitive_model.dart';
import 'src/embodifier.dart';
import 'src/app.dart';
import 'src/embodiment/numericfield_embodiment.dart';
import 'src/widgets/choice_field.dart';

/// The main entry point for the ProntoGUI application.  This function sets up
/// several objects responsible for core functionality of the application and
/// hands off operation to the App widget.
void altmain1(List<String> args) async {
  dl.loggingLevel = dl.LoggingLevel.info;

  dl.logger.i('Welcome to ProntoGUI version ?.?.?');
  dl.logger.i('Running alternate-main 1 program for development purposes.');

  // Create the model that holds the primitives to be displayed.
  final model = dl.PrimitiveModel();

  //final list = dl.ListP(embodiment: 'horizontal:true, width:100, height:100, borderAll:3');
  final list = dl.ListP(embodiment: 'horizontal:false, width:200');
  var t1 = dl.Text(content: 'Frame 1');
  var t2 = dl.Text(content: 'Frame 2');
  var icon1 = dl.Icon(iconID: 'hiking');
  var card1 = dl.Card(mainItem: dl.Text(content: 'Hi, I\'m Bob'));
  //var c1 = dl.Card(mainItem: dl.Text(content: 'CARD'), embodiment: 'width:200');
  list.listItems = [t1, t2, icon1, card1];
  model.topPrimitives = [list];
/*
  if (true) {
    final cm = dl.Card(
        embodiment: 'tile',
        leadingItem: dl.Icon(iconID: 'hiking'),
        mainItem: dl.Text(embodiment: 'fontSize:20'),
        subItem: dl.Text(embodiment: 'borderAll:2'));
    final cr = dl.Icon(iconID: 'tsunami', embodiment: 'paddingAll:10');
    final c1 = dl.Card(
      leadingItem: dl.Icon(iconID: 'hiking'),
      mainItem: dl.Text(content: 'Apple'),
      subItem: dl.Text(content: '1000'),
    );
    final c2 = dl.Card(
      leadingItem: dl.Icon(iconID: 'hiking'),
      mainItem: dl.Text(content: 'Banana'),
      subItem: dl.Text(content: '2000'),
    );
    final c3 = dl.Card(
      leadingItem: dl.Icon(iconID: 'hiking'),
      mainItem: dl.Text(content: 'Cucumber'),
      subItem: dl.Text(content: '3000'),
      trailingItem: dl.Command(label: 'Delete'),
    );

    final n1 = dl.Node(nodeItem: cr, subNodes: [
      dl.Node(nodeItem: c1, subNodes: [dl.Node(nodeItem: c2)]),
      dl.Node(nodeItem: c3)
    ]);

/*
    final gm = dl.Group(groupItems: [
      dl.Icon(iconID: 'hiking'),
      dl.Text(embodiment: 'fontSize:20'),
      dl.Text(embodiment: 'borderAll:2'),
    ], embodiment: 'card');
    final g1 = dl.Group(groupItems: [
      dl.Icon(iconID: 'hiking'),
      dl.Text(content: 'Apple'),
      dl.Text(content: '1000'),
    ]);
    final g2 = dl.Group(groupItems: [
      dl.Icon(iconID: 'hiking'),
      dl.Text(content: 'Banana'),
      dl.Text(content: '2000'),
    ]);
    final g3 = dl.Group(groupItems: [
      dl.Icon(iconID: 'hiking'),
      dl.Text(content: 'Cucumber'),
      dl.Text(content: '3000'),
    ]);

    final n1 = dl.Node(subNodes: [
      dl.Node(nodeItem: g1, subNodes: [dl.Node(nodeItem: g2)]),
      dl.Node(nodeItem: g3)
    ]);
  */
    final tree = dl.Tree(root: n1, modelItem: cm, embodiment: 'width: 300');
    model.topPrimitives = [tree];
  }

  if (false) {
    final gm = dl.Group(groupItems: [
      dl.Nothing(),
      dl.Text(embodiment: 'fontSize:20'),
      dl.Text(embodiment: 'borderAll:2'),
    ], embodiment: 'card');
    final g1 = dl.Group(groupItems: [
      dl.Nothing(),
      dl.Text(content: 'Apple'),
      dl.Text(content: '1000'),
    ], embodiment: 'tile');
    final g2 = dl.Group(groupItems: [
      dl.Nothing(),
      dl.Text(content: 'Banana'),
      dl.Text(content: '2000'),
    ], embodiment: 'card');
    final g3 = dl.Group(groupItems: [
      dl.Nothing(),
      dl.Text(content: 'Cucumber'),
      dl.Text(content: '3000'),
    ], embodiment: 'card');

    final l = dl.ListP(listItems: [g1, g2, g3], modelItem: gm);

    model.topPrimitives = [l]; // [innerFrame];
  }
*/

/*
  final t =
      dl.Text(content: "Hello, World!", embodiment: 'fontSize:30, borderAll:3');

  final l = dl.ListP(listItems: [
    dl.Text(content: "Apple", embodiment: 'fontSize:10'),
    dl.Text(content: "Banana"),
    dl.Text(content: "Orange"),
  ], modelItem: dl.Text(embodiment: 'fontSize:30, borderAll:3'));
  model.topPrimitives = [l];
*/

/*

  final g = dl.Group(groupItems: [
    dl.Nothing(),
    dl.Text(content: 'Apple'),
    dl.Text(content: '1000'),
  ], embodiment: 'card');
  model.topPrimitives = [g];
*/

  // Create the object responsible for embodying the model as Widgets and for
  // rebuilding the UI when the model changes.
  final embodifier = Embodifier();

  // Create an object that notify portions of the UI when a full update is
  // ingested into the model.
  final fullUpdateNotifier =
      PrimitiveModelChangeNotifier(model: model, notifyOnFull: true);

  // Create an object that notifies portions of the UI when a top-level
  // primitive is updated.
  final topLevelUpdateNotifier =
      PrimitiveModelChangeNotifier(model: model, notifyOnTopLevel: true);

  // Add the objects we just created to the model as watchers.
  model.addWatcher(embodifier);
  model.addWatcher(fullUpdateNotifier);
  model.addWatcher(topLevelUpdateNotifier);

  // Run the app and start rendering the UI.
  runApp(InheritedPrimitiveModel(
    notifier: fullUpdateNotifier,
    child: InheritedTopLevelPrimitives(
      notifier: topLevelUpdateNotifier,
      child: InheritedEmbodifier(
        embodifier: embodifier,
        child: App.altdev1(),
      ),
    ),
  ));
}

/// The main entry point for the ProntoGUI application.  This function sets up
/// several objects responsible for core functionality of the application and
/// hands off operation to the App widget.
void altmain2(List<String> args) async {
  dl.loggingLevel = dl.LoggingLevel.trace;

  dl.logger.i('Welcome to ProntoGUI version ?.?.?');
  dl.logger.i('Running alternate-main 2 program for development purposes.');

/*
  var props =
      ColorNumericFieldEmbodimentProperties.fromMap({'embodiment': 'color'});

  var e = ColorNumericFieldEmbodiment(
      numfield: p, props: props, parentWidgetType: 'MaterialApp');
*/

  /*
  var props = FontSizeNumericFielEmbodimentProperties.fromMap(
      {'embodiment': 'font-size'});

  var e = FontSizeNumericFieldEmbodiment(
      numfield: p, props: props, parentWidgetType: 'MaterialApp');
   */

  /*
  var choice = Choice(
      choice: 'Apple', choices: ['Orange', 'Apple', 'Banana', 'Peach', 'Pear']);
  var e = DefaultChoiceEmbodiment(choice: choice);
  var row = Row(
    children: [e, const BackButton()],
  );
 */

/*
  var w = ChoiceField(
      onSubmitted: (value) {},
      initialValue: 'Apple',
      choices: const [
        'Orange',
        'Apple',
        'Banana',
        'Peach',
        'Pear',
        'Mango',
        'Apricot',
        'Cherry'
      ]);
 */

  var p = NumericField(
      initialValue: '0.012345678',
      displayDecimalPlaces: 15,
      displayNegativeFormat: NegativeDisplayFormat.minusSignPrefix,
      displayThousandths: true,
      //minValue: 10,
      //maxValue: 100,
      popupChoices: const ['1.0', '2.0', '3.14159'],
      onSubmitted: (value) => print('submitted:  $value'));

  // Run the app and start rendering the UI.
  runApp(
    App.altdev2(devWidget: p),
  );
}
