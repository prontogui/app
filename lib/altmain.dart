// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:app/src/embodiment/choice_embodiment.dart';
import 'package:app/src/embodiment/common_properties.dart';
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

  var p1 = dl.Text(
      embodiment:
          'fontFamily:BonaNovaSC, fontSize:30, fontStyle:italic, fontWeight:bold, backgroundColor:0xFF750DF1, color:0xFFFFFFFF',
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

  //var p = dl.NumericField(embodiment: 'color', numericEntry: 'Red');
  model.topPrimitives = [p1, p2, p3, p4];

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
      initialValue: '0.0',
      displayDecimalPlaces: 3,
      displayNegativeFormat: NegativeDisplayFormat.minusSignPrefix,
      displayThousandths: true,
      minValue: 0,
      maxValue: 100,
      onSubmitted: (value) => print('submitted:  $value'));

  // Run the app and start rendering the UI.
  runApp(
    App.altdev2(devWidget: p),
  );
}
