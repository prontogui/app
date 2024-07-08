// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:app/embodiment/embodifier.dart';

class TestTree extends StatelessWidget {
  const TestTree({super.key, required this.wut});

  final Widget wut;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Embodifier(
        child: MaterialApp(
      title: 'Pronto!GUI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: wut,
        ),
      ),
    ));
  }
}
