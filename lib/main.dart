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

void main() async {
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

      comm.sendUpdate(update);
    });

    void onUpdate(CborValue cborUpdate) {
      model.updateFromCbor(cborUpdate);
    }

    try {
      comm = PGComm.start(onUpdate);
    } on Exception catch (e) {
      print('Unknown exception: $e');
    }
  }

  runApp(Embodifier(
      child: InheritedPrimitiveModel(
    notifier: model,
    child: const MyApp(),
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
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
