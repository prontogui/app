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

  final myApp = const MyApp();
  final embodifier = Embodifier(child: myApp);
  final model = pg.PrimitiveModel();
  final eventSynchro = UIEventSynchro(model);
  final buildSynchro = UIBuilderSynchro(embodifier);
  final commNotifier = CommClientChangeNotifier();
  final fullUpdateNotifier = PrimitiveModelChangeNotifier(notifyOnFull: true);
  final topLevelUpdateNotifier =
      PrimitiveModelChangeNotifier(notifyOnTopLevel: true);

  model.addWatcher(fullUpdateNotifier);
  model.addWatcher(topLevelUpdateNotifier);
  model.addWatcher(eventSynchro);

  var grpcComm = pg.GrpcCommClient(
    onUpdate: (cborUpdate) => model.ingestCborUpdate(cborUpdate),
    onStateChange: () => commNotifier.onStateChange(),
  );

  grpcComm.open(serverAddress: serverAddr, serverPort: serverPort);

  commNotifier.comm = grpcComm;

  // TODO:  figure out how to send primitive model updates to the server.

  runApp(InheritedCommClient(
    notifier: commNotifier,
    child: InheritedPrimitiveModel(
      notifier: fullUpdateNotifier,
      child: InheritedTopLevelPrimitives(
        notifier: topLevelUpdateNotifier,
        child: embodifier,
      ),
    ),
  ));
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
