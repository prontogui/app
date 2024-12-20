// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart';
import 'src/inherited_primitive_model.dart';
import 'src/embodifier.dart';
import 'src/app.dart';
import 'src/embodiment/numericfield_embodiment.dart';

/// The main entry point for the ProntoGUI application.  This function sets up
/// several objects responsible for core functionality of the application and
/// hands off operation to the App widget.
void altmain1(List<String> args) async {
  loggingLevel = LoggingLevel.info;

  logger.i('Welcome to ProntoGUI version ?.?.?');
  logger.i('Running alternate-main 1 program for development purposes.');

  // Create the model that holds the primitives to be displayed.
  final model = PrimitiveModel();

  var p = NumericField(embodiment: 'color', numericEntry: 'Red');
  model.topPrimitives = [p];

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
  loggingLevel = LoggingLevel.trace;

  logger.i('Welcome to ProntoGUI version ?.?.?');
  logger.i('Running alternate-main 2 program for development purposes.');

  var p = NumericField();

/*
  var props =
      ColorNumericFieldEmbodimentProperties.fromMap({'embodiment': 'color'});

  var e = ColorNumericFieldEmbodiment(
      numfield: p, props: props, parentWidgetType: 'MaterialApp');
*/

// /*
  var props = FontSizeNumericFielEmbodimentProperties.fromMap(
      {'embodiment': 'font-size'});

  var e = FontSizeNumericFieldEmbodiment(
      numfield: p, props: props, parentWidgetType: 'MaterialApp');
// */

  // Run the app and start rendering the UI.
  runApp(
    App.altdev2(devWidget: e),
  );
}
