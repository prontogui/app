// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/model.dart';
import 'package:flutter/material.dart';

class WaitingForServerView extends StatelessWidget {
  const WaitingForServerView({super.key, required this.operatingView});

  final Widget operatingView;

  @override
  Widget build(BuildContext context) {
    var model = InheritedPrimitiveModel.of(context);

    if (model.isEmpty) {
      return buildWaitingForServerMessage(context);
    } else {
      return operatingView;
    }
  }

  Widget buildWaitingForServerMessage(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Waiting for server..."),
      ),
    );
  }
}
