// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:io';

import 'package:app/src/embodiment/choice_embodiment.dart';
import 'package:app/src/embodiment/text_embodiment.dart';
import 'package:app/src/widgets/numeric_field.dart';
import 'package:app/src/widgets/text_field.dart';
import 'package:app/src/widgets/widget_common.dart';
import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as dl;
import 'src/inherited_primitive_model.dart';
import 'src/embodifier.dart';
import 'src/app.dart';
import 'src/embodiment/numericfield_embodiment.dart';
import 'src/widgets/choice_field.dart';
import 'src/widgets/color_field.dart';

/// The main entry point for the ProntoGUI application.  This function sets up
/// several objects responsible for core functionality of the application and
/// hands off operation to the App widget.
void altmain1(List<String> args) async {
  dl.loggingLevel = dl.LoggingLevel.info;

  dl.logger.i('Welcome to ProntoGUI version ?.?.?');
  dl.logger.i('Running alternate-main 1 program for development purposes.');

  // Create the model that holds the primitives to be displayed.
  final model = dl.PrimitiveModel();



// NEEDS FIXIN

/*
  var icon = dl.Icon(iconID: 'cancel');
  // Following button appears on LH side
//  var cmd = dl.Command(label: 'Hello world', labelItem: icon, embodiment: 'outlined-button');
  // Following button appears centered
  var cmd = dl.Command(label: 'Hello world', labelItem: icon);
  model.topPrimitives = [cmd];

*/


  var icon = dl.Icon(iconID: 'cancel');
  var img = dl.Image(fromFile: '/Users/andy/Downloads/go-logo.png', embodiment: 'width:50,height:50,borderAll:1');
  var txt = dl.Text(content: 'H', embodiment: 'fontSize:20,fontColor:#FFFFFF00');
//  var cmd = dl.Command(label: 'Hello world', labelItem: img, embodiment: 'outlined-button');
  var cmd = dl.Tristate(label: 'Hello world', labelItem: txt);
  //var cmd = dl.Command(label: 'Hello world');
//  var cmd = dl.Command(labelItem: icon);
  //var cmd = dl.Check(label: 'Guten Tag');

  //var nf = dl.NumericField(numericEntry: '0.0', embodiment: 'marginAll:5');
  //var tf = dl.TextField(textEntry: "Mary", embodiment: 'marginAll:5,borderAll:1,maxLength:30');

  model.topPrimitives = [cmd];

/*
  var exRow = [
    dl.Text(embodiment: 'height:50, verticalAlignment:bottom', content: 'XXXX'),
    dl.Text(embodiment: 'verticalAlignment:bottom, backgroundColor:#FF00FF00, verticalAlignment:expand', content: '\$0.00'),
    dl.Text(embodiment: 'verticalAlignment:top', content: 'In stock')];

  var row1 = [dl.Text(content: 'Apple'), dl.Text(content: '\$10.00', embodiment: 'backgroundColor:#FFFF0000, verticalAlignment:top'), dl.Text(content: 'In stock')];
  var row2 = [dl.Text(content: 'Orange'), dl.Text(content: '\$5.00'), dl.Text(content: 'In stock')];
  var row3 = [dl.Text(content: 'Banana'), dl.Text(content: '\$3.00'), dl.Text(content: 'Out of stock')];
  var row4 = [dl.Text(content: 'Mango'), dl.Text(content: '\$10.00'), dl.Text(content: 'In stock')];
  var row5 = [dl.Text(content: 'Pear'), dl.Text(content: '\$5.00'), dl.Text(content: 'In stock')];
  var row6 = [dl.Text(content: 'Grape'), dl.Text(content: '\$3.00'), dl.Text(content: 'Out of stock')];
  var row7 = [dl.Text(content: 'Raspberry'), dl.Text(content: '\$10.00'), dl.Text(content: 'In stock')];
  var row8 = [dl.Text(content: 'Blueberry'), dl.Text(content: '\$5.00'), dl.Text(content: 'In stock')];
  var row9 = [dl.Text(content: 'Coconut'), dl.Text(content: '\$3.00'), dl.Text(content: 'Out of stock')];

  //var emb = '{"insideBorderAll":2,"columnSettings":[{"width":200}, {"width":100}, {"width":75}]}';
//  var emb = '{"embodiment":"paged","backgroundColor":"#40000000","columnSettings":[{"width":300},{"width":200},{"width":120}]}';
  var emb = '{"backgroundColor":"#40000000","columnSettings":[{"width":300},{"width":200},{"width":120}]}';

  var t = dl.Table(embodiment: emb, rows: [row1, row2, row3, row4, row5, row6, row7, row8, row9], modelRow: exRow);
  //t.makeHeadings(['Fruit', 'Price', 'Stock']);
  //t.headerRow[0].embodiment = 'height:75, verticalTextAlignment:bottom, horizontalTextAlignment:right, marginAll:2, backgroundColor:#FFFFFF00';
  var h1 = dl.Group(groupItems: [dl.Text(content: 'Fruit'), dl.Icon(iconID: 'group', embodiment: 'size:18, marginLeft:5')], embodiment: 'horizontalAlignment:right');
  var h2 = dl.Group(groupItems: [dl.Text(content: 'Price'), dl.Icon(iconID: 'lock_open', embodiment: 'size:18, marginLeft:5')]);
  var h3 = dl.Group(groupItems: [dl.Text(content: 'Stock'), dl.Icon(iconID: 'stacked_bar_chart', embodiment: 'size:18, marginLeft:5')]);
  t.headerRow = [h1, h2, h3];

  var g1 = dl.Group(groupItems: [dl.Text(content: 'Fruit'), dl.Text(content: 'Fruit')], embodiment: 'horizontalAlignment:center');
  var l1 = dl.Frame(frameItems:[g1]);

  model.topPrimitives = [t];

*/

//  model.topPrimitives = [l1];

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
//        child: App.altdev1(),
        child: App.local(),
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
  var p = NumericField(
      initialValue: '0.012345678',
      displayDecimalPlaces: 15,
      displayNegativeFormat: NegativeDisplayFormat.minusSignPrefix,
      displayThousandths: true,
      //minValue: 10,
      //maxValue: 100,
      popupChoices: const ['1.0', '2.0', '3.14159'],
      focusSelection: FocusSelection.end,
      onSubmitted: (value) => print('submitted:  $value'));
*/

/*
var p = ColorField(
    focusSelection: FocusSelection.all,
    onSubmitted: (value) => {},
);
/  */
/*
  var p = ChoiceField(
    choices: ['Apple', 'Orange', 'Banana'],
    focusSelection: FocusSelection.end,
    onSubmitted: (value) =>{},
  );
*/



  var p = TextEntryField(
    initialText: '',
    maxLength: 30,
    maxLines: 1,
    //minDisplayLines: 1,
    maxDisplayLines: 1,
    hideText: false,
    focusSelection: FocusSelection.all,
    //inputPattern: r"^\([0-9][0-9][0-9]\)",
    //popupChoices: ['ABC', 'DEF', 'XYZ'],
    onSubmitted:  (value) => print('submitted:  $value')
    );

  // Run the app and start rendering the UI.
  runApp(
    App.altdev2(devWidget: p),
  );
}
