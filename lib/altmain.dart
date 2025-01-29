// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:app/src/embodiment/choice_embodiment.dart';
import 'package:app/src/embodiment/common_props.dart';
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

/*
  var p1 = dl.Text(
      embodiment:
          'fontFamily:BonaNovaSC, fontSize:30, fontStyle:italic, fontWeight:bold, backgroundColor:#FF750DF1, color:#FFFFFFFF',
      content: 'This is a line of text.');

  var p2 = dl.Text(
      embodiment: 'fontFamily:KodeMono,fontSize:20',
      content: 'This is a line of text.');

  var p3 = dl.Text(
      embodiment: 'fontFamily:PTSerif,fontSize:20',
      content: 'This is a line of text.');

  var p4 = dl.Text(
      embodiment: 'fontFamily:Roboto,fontSize:20',
      content: 'This is a line of text.');

  var choice1 = dl.Choice(
    choice: 'Apple',
    choices: ['Orange', 'Apple', 'Banana', 'Peach', 'Pear'],
  );

  var choice2 = dl.Choice(
      embodiment: 'button',
      choice: 'a',
      choices: ['o', 'a', 'b', 'p', 'r'],
      choiceLabels: ['Orange', 'Apple', 'Banana', 'Peach', 'Pear']);

  //var p = dl.NumericField(embodiment: 'color', numericEntry: 'Red');
  model.topPrimitives = [p1, p2, p3, p4, choice1, choice2];
*/

/*
  var t1 = dl.Text(content: 'Frame');
  var t2 = dl.Text(content: 'Frame');
  var t3 = dl.Text(content: 'Frame');

  var p = dl.ListP(
      listItems: [t1, t2, t3],
      embodiment: 'height:75, horizontal:true, itemWidth:80');

  model.topPrimitives = [p];
*/
/*
  //var grp1 = dl.Group(groupItems: [dl.Text(content: 'Setting 1'), dl.Check()]);
  var f1 = dl.Frame(
      title: 'Tab 1',
      icon: dl.Icon(iconID: 'beach_access'),
      frameItems: [dl.Text(content: 'Setting 1'), dl.Check()]);
  var f2 = dl.Frame(
      title: 'Tab 2',
      icon: dl.Icon(iconID: 'accessible'),
      frameItems: [
        dl.Icon(iconID: 'accessible', embodiment: 'color:#CCFF0000, size:50')
      ]);
  var f3 = dl.Frame(title: 'Tab 3', icon: dl.Icon(iconID: 'dining'));

  var l = dl.ListP(
      embodiment: 'embodiment:tabbed-list, animationPeriod:200',
      listItems: [f1, f2, f3]);
  model.topPrimitives = [l];
*/
  var list = dl.ListP(embodiment: 'embodiment:property-list, height:600');
  list.listItems = [
    dl.Group(groupItems: [
      dl.Text(content: 'Embodiment'),
      dl.NumericField(numericEntry: '4.56')
    ])
  ];

  var innerGroup = dl.Group(
      groupItems: [dl.Choice(embodiment: 'width:50, height:30'), list]);

  var selector = dl.ListP(listItems: [
    dl.Text(content: 'Apple'),
    dl.Text(content: 'Orange'),
  ], embodiment: 'horizontal:true');

  var innerFrame = dl.Frame(
      embodiment: 'flowDirection:top-to-bottom, width:300',
      frameItems: [selector, innerGroup]);

//dl.NumericField(numericEntry: '4.56')
  var group = dl.Group(groupItems: [innerFrame]);

  var l = dl.ListP(embodiment: 'embodiment:property-list', listItems: [
    dl.Group(groupItems: [dl.Text(content: 'Item 1'), dl.NumericField()]),
    dl.Group(groupItems: [dl.Text(content: 'Item 2'), dl.NumericField()]),
    dl.Group(groupItems: [dl.Text(content: 'Item 3'), dl.NumericField()]),
  ]);

  var gui = dl.Frame(
    embodiment: 'border:outline',
    frameItems: [
      dl.Text(content: 'Embodiment'),
      //  dl.Choice(embodiment: 'height:40'),
      dl.ListP(embodiment: 'embodiment:property-list', listItems: [
        dl.Group(groupItems: [dl.Text(content: 'Item 1'), dl.NumericField()]),
        dl.Group(groupItems: [dl.Text(content: 'Item 2'), dl.NumericField()]),
        dl.Group(groupItems: [dl.Text(content: 'Item 3'), dl.NumericField()]),
      ])
    ],
  );

  var f2 = dl.Frame(frameItems: [
    dl.Text(content: 'Some content'),
    dl.Group(
        groupItems: [dl.Text(content: 'Embodiment'), dl.Text(content: 'xxxx')]),
    dl.ListP(embodiment: 'property-list', listItems: [
      dl.Group(groupItems: [dl.Text(content: 'Item 1'), dl.NumericField()]),
      dl.Group(groupItems: [dl.Text(content: 'Item 2'), dl.NumericField()]),
      dl.Group(groupItems: [dl.Text(content: 'Item 3'), dl.NumericField()]),
    ]),
  ]);
  model.topPrimitives = [f2]; // [innerFrame];

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
