// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:args/args.dart';
import 'package:window_manager/window_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dartlib/dartlib.dart';
import 'facilities/inherited_primitive_model.dart';
import 'facilities/ui_event_synchro.dart';
import 'facilities/ui_builder_synchro.dart';
import 'facilities/inherited_comm.dart';
import 'facilities/embodifier.dart';
import 'widgets/app.dart';
import 'log.dart';

/// The main entry point for the ProntoGUI application.  This function sets up
/// several objects responsible for core functionality of the application and
/// hands off operation to the App widget.
void main(List<String> args) async {
  // Be sure to add this line if `PackageInfo.fromPlatform()` is called before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Get information about this App
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  var (serverAddr, serverPort, logLevel) = _parseCommandLineOptions(args);

  loggingLevel = logLevel;

  logger.i('Welcome to ProntoGUI version ${packageInfo.version}');
  logger.i('Starting ProntoGUI App with args: $args');

  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
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
    // Handler for receiving CBOR updates from the server.
    onUpdate: (cborUpdate) {
      logger.t('Received CBOR update: $cborUpdate');
      try {
        model.ingestCborUpdate(cborUpdate);
      } catch (e) {
        logger.e('Error ingesting CBOR update: $e');
      }
    },
    onStateChange: () => commNotifier.onStateChange(),
    serverCheckinPeriod: 0,
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
            child: const App(),
          ),
        ),
      )));
}

/// Parses the command-line options for the program.  If there are invalid
/// options then it prints the usage and exits the program with an error code (-1).
(String serverAddr, int serverPortNo, LoggingLevel logLevel)
    _parseCommandLineOptions(List<String> args) {
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
        help: 'Display help on command-line options for this program.')
    ..addOption('loglevel',
        abbr: 'l',
        defaultsTo: 'warning',
        allowed: [
          'off',
          'fatal',
          'error',
          'warning',
          'info',
          'debug',
          'trace',
        ],
        help: 'Set the logging level for the program.');

  /// Prints the command-line usage and options for this application.
  void printUsage(String message) {
    stdout.writeln('\n$message\n${parser.usage}');
  }

  late ArgResults parsedArgs;

  try {
    parsedArgs = parser.parse(args);
  } catch (err) {
    printUsage('Invalid command line usage.');
    exit(-1);
  }

  String serverAddr = defaultAddr;
  int serverPort = defaultPortInt;

  var serverOption = parsedArgs.option('server');
  if (serverOption != null) {
    // Parse server option as addr:port
    var serverOptionParts = serverOption.split(':');

    if (serverOptionParts.length > 2) {
      printUsage('Invalid command line usage:  server option is invalid.');
      exit(-1);
    }

    serverAddr = serverOptionParts[0];

    if (serverOptionParts.length == 2) {
      var port = int.tryParse(serverOptionParts[1]);
      if (port == null) {
        printUsage('Invalid command line usage:  port must be a number.');
        exit(-1);
      }
      serverPort = port;
    }
  }

  var logLevelOption = parsedArgs['loglevel'];
  var logLevel = LoggingLevel.warning;
  switch (logLevelOption) {
    case 'off':
      logLevel = LoggingLevel.off;
    case 'fatal':
      logLevel = LoggingLevel.fatal;
    case 'error':
      logLevel = LoggingLevel.error;
    case 'warning':
      logLevel = LoggingLevel.warning;
    case 'info':
      logLevel = LoggingLevel.info;
    case 'debug':
      logLevel = LoggingLevel.debug;
    case 'trace':
      logLevel = LoggingLevel.trace;
    default:
      printUsage('Invalid command line usage:  loglevel is invalid.');
      exit(-1);
  }

  if (parsedArgs.flag('help')) {
    printUsage('Command line usage:');
    exit(0);
  }

  return (serverAddr, serverPort, logLevel);
}
