// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:args/args.dart';
import 'package:app/background_view.dart';
import 'package:app/main_testing.dart';
import 'package:cbor/cbor.dart';
import 'package:flutter/material.dart';
import 'package:app/pgcomm/pgcomm.dart';
import 'package:app/primitive/model.dart';
import 'package:app/embodiment/embodifier.dart';
import 'waiting_for_server_view.dart';
import 'top_level_coordinator.dart';
import 'package:window_manager/window_manager.dart';

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

  late PGComm comm;
  late PrimitiveModel model;

  const isTesting = false;

  if (isTesting) {
    model = initializeTestingModel();
  } else {
    model = PrimitiveModel((eventType, pkey, fieldUpdates) {
      // Send update back to pgcomm
      final update =
          CborList([const CborBool(false), pkey.toCbor(), fieldUpdates]);

      comm.streamUpdateToServer(update);
    });

    void onUpdate(CborValue cborUpdate) {
      model.updateFromCbor(cborUpdate);
    }

    comm = PGComm(onUpdate);
    comm.open(serverAddress: serverAddr, serverPort: serverPort);
  }

  runApp(Embodifier(
      child: InheritedPGComm(
    notifier: comm,
    child: InheritedPrimitiveModel(
      notifier: model,
      child: const MyApp(),
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
