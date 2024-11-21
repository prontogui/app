// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:app/src/cmd_line_options.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dartlib/dartlib.dart';
import 'src/inherited_primitive_model.dart';
import 'src/ui_builder_synchro.dart';
import 'src/ui_event_synchro.dart';
import 'src/inherited_comm.dart';
import 'src/embodifier.dart';
import 'src/app.dart';

/// The main entry point for the ProntoGUI application.  This function sets up
/// several objects responsible for core functionality of the application and
/// hands off operation to the App widget.
void main(List<String> args) async {
  // Be sure to add this line if `PackageInfo.fromPlatform()` is called before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Get information about this App
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  // Parse the command-line options
  final options = CmdLineOptions.from(args);

  // Set the logging level of Logger
  loggingLevel = options.logLevel;

  // TODO:  REMOVE THE FOLLOWING FOR PRODUCTION
  loggingLevel = LoggingLevel.info;

  logger.i('Welcome to ProntoGUI version ${packageInfo.version}');
  logger.i('Started with args: $args');

  // Initialize the window manager
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    //titleBarStyle: TitleBarStyle.normal,
    //title: 'App Title',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Create the model that holds the primitives to be displayed.
  final model = PrimitiveModel();

  // Create the object that notifies other objects when changes occur in
  // communication with the server.
  final commNotifier = CommClientChangeNotifier();

  // Create the object that communicates with the server.
  var grpcComm = GrpcCommClient(
    onStateChange: () => commNotifier.onStateChange(),
    serverCheckinPeriod: 0,
  );

  // Handler for receiving CBOR updates from the server.
  grpcComm.updatesFromServer.listen(
    (cborUpdate) {
      logger.i('Received CBOR update.');
      try {
        model.ingestCborUpdate(cborUpdate);
      } catch (e) {
        logger.e('Error ingesting CBOR update: $e');
      }
    },
    onError: (e) {
      logger.e(e.toString());
      model.topPrimitives = [];
    },
  );

  // Attach the comm object to the notifier.
  commNotifier.comm = grpcComm;

  // Create the object responsible for embodying the model as Widgets and for
  // rebuilding the UI when the model changes.
  final embodifier = Embodifier();

  // Create the object that synchronizes UI events with the server.
  final eventSynchro = UIEventSynchro(locator: model, comm: grpcComm);

  // Create the object that rebuilds all, or portions of, the UI when the model
  // changes.
  final builderSynchro = UIBuilderSynchro(embodifier);

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
  model.addWatcher(eventSynchro);
  model.addWatcher(builderSynchro);

  // Open the communication channel to the server.
  grpcComm.open(
      serverAddress: options.serverAddr, serverPort: options.serverPort);

  // Run the app and start rendering the UI.
  runApp(InheritedCommClient(
      notifier: commNotifier,
      child: InheritedPrimitiveModel(
        notifier: fullUpdateNotifier,
        child: InheritedTopLevelPrimitives(
          notifier: topLevelUpdateNotifier,
          child: InheritedEmbodifier(
            embodifier: embodifier,
            child: const App(),
          ),
        ),
      )));
}
