// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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

void main() async {
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
    comm.open('127.0.0.1', 50053);
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
