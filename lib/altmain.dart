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

  var text = dl.Text(
      content: 'Hello, World!',
      embodiment:
//          'width:50, height:30, borderAll:10, horizontalAlignment:expand, verticalAlignment:top');
          'right: 40, bottom: 40, height:40, width:100, borderAll:4, borderTop:0, borderLeft:10, borderRight:3, borderColor:#FFFF0000');

  var g = dl.Frame(
      frameItems: [text],
      embodiment:
          'layoutMethod:positioned, width:500, height:500, borderAll:3, borderColor:#FF00FF00');

  model.topPrimitives = [g]; // [innerFrame];

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
