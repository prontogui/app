// Copyright 2025 ProntoGUI, LLC.
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

  var imgAsset = dl.Image(fromFile: '/Users/andy/Downloads/go-logo.png', id: 'gopher');
  var assets = dl.Group(groupItems: [imgAsset], status: 2);
  var img = dl.Image(ref: 'gopher', embodiment: 'width:100, height:100');
  var gui = dl.Frame(frameItems: [img], embodiment: 'full-view', showing: true);

  model.topPrimitives = [gui, assets];

/*
  var imgAsset = dl.Image(fromFile: '/Users/andy/Downloads/go-logo.png', id: 'gopher', embodiment: 'width:100, height:100');
  model.topPrimitives = [imgAsset];
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
