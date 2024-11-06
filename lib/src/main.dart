// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/src/inherited_primitive_model.dart';
import 'package:args/args.dart';
import 'package:app/src/background_view.dart';
import 'package:flutter/material.dart';
import 'package:app/src/embodiment/embodifier.dart';
import 'waiting_for_server_view.dart';
import 'top_level_coordinator.dart';
import 'package:window_manager/window_manager.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'inherited_comm.dart';
import 'ui_event_synchro.dart';
import 'ui_builder_synchro.dart';

(String serverAddr, int serverPortNo) parseCommandLineOptions(
    List<String> args) {
  // Default values for options
  const defaultAddr = '127.0.0.1';
  const defaultPort = '50053';
  var defaultPortInt = int.parse(defaultPort);
  var defaultServer = '$defaultAddr:$defaultPort';
//  var defaultServerPortNo = int.parse(defaultServerPort);

  // Parse the command-line args
  final parser = ArgParser()
    ..addOption('server',
        abbr: 's',
        defaultsTo: defaultServer,
        help: 'The address of the server with an optional [:port] specified.')
    ..addFlag('help',
        abbr: 'h',
        help: 'Display help on command-line options for this program.');

  void printUsage(String message) {
    print('\n$message\n');
    print(parser.usage);
  }

  late ArgResults parsedArgs;

  try {
    parsedArgs = parser.parse(args);
  } catch (err) {
    printUsage('Invalid command line usage.');
    return (defaultAddr, defaultPortInt);
  }

  String serverAddr = defaultAddr;
  int serverPort = defaultPortInt;

  var serverOption = parsedArgs.option('server');
  if (serverOption != null) {
    // Parse server option as addr:port
    var serverOptionParts = serverOption.split(':');

    if (serverOptionParts.length > 2) {
      printUsage('Invalid command line usage:  server option is invalid.');
      return (defaultAddr, defaultPortInt);
    }

    serverAddr = serverOptionParts[0];

    if (serverOptionParts.length == 2) {
      var port = int.tryParse(serverOptionParts[1]);
      if (port == null) {
        printUsage('Invalid command line usage:  port must be a number.');
        return (defaultAddr, defaultPortInt);
      }
      serverPort = port;
    }
  }

  if (parsedArgs.flag('help')) {
    printUsage('Command line usage:');
  }

  return (serverAddr, serverPort);
}

void main(List<String> args) async {
  var (serverAddr, serverPort) = parseCommandLineOptions(args);

  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    //size: Size(1200, 800),
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
  final model = pg.PrimitiveModel();

  // Create the object that notifies other objects when changes occur in
  // communication with the server.
  final commNotifier = CommClientChangeNotifier();

  // Create the object that communicates with the server.
  var grpcComm = pg.GrpcCommClient(
    onUpdate: (cborUpdate) {
      try {
        model.ingestCborUpdate(cborUpdate);
      } catch (e) {
        print('Error ingesting CBOR update: $e');
      }
    },
    onStateChange: () => commNotifier.onStateChange(),
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

/*
  // Create an object that notifies portions of the UI when a full update is 
  // ingested into the model or when a top-level primitive is updated.
  final fullOrTopLevelUpdateNotifier = PrimitiveModelChangeNotifier(
      model: model, notifyOnFull: true, notifyOnTopLevel: true);
*/

  // Add the objects we just created to the model as watchers.
  model.addWatcher(fullUpdateNotifier);
  model.addWatcher(topLevelUpdateNotifier);
  model.addWatcher(eventSynchro);
  model.addWatcher(builderSynchro);

  // Open the communication channel to the server.
  grpcComm.open(serverAddress: serverAddr, serverPort: serverPort);

  // Run the app and start rendering the UI.
  runApp(InheritedCommClient(
      notifier: commNotifier,
      child: InheritedPrimitiveModel(
        notifier: fullUpdateNotifier,
        child: InheritedTopLevelPrimitives(
          notifier: topLevelUpdateNotifier,
          child: InheritedEmbodifier(
            embodifier: embodifier,
            child: const MyApp(),
          ),
        ),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ProntoGUI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const WaitingForServerView(
          operatingView: TopLevelCoordinator(
            backgroundView: BackgroundView(),
          ),
        ));
  }
}

class AppNameAndVersion extends StatelessWidget {
  const AppNameAndVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('ProntoGUI, Version 0.0');
  }
}
