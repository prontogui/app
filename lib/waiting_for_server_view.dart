// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/pgcomm/pgcomm.dart';
import 'package:flutter/material.dart';

class WaitingForServerView extends StatelessWidget {
  const WaitingForServerView({super.key, required this.operatingView});

  final Widget operatingView;

  @override
  Widget build(BuildContext context) {
    var pgcomm = InheritedPGComm.of(context);

    if (pgcomm.invalidServer) {
      return buildInvalidServerMessage(context, pgcomm);
    }

    if (!pgcomm.active) {
      return buildNoServerMessage(context);
    }

    if (pgcomm.paused) {
      return buildWaitingForServerMessage(context, pgcomm);
    } else {
      return operatingView;
    }
  }

  Widget buildInvalidServerMessage(BuildContext context, PGComm pgcomm) {
    return Scaffold(
        body: Center(
      child: Text(
          'Server at address ${pgcomm.serverAddress}:${pgcomm.serverPort} is invalid or unreachable.'),
    ));
  }

  Widget buildNoServerMessage(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('No server specified.'),
    ));
  }

  Widget buildWaitingForServerMessage(BuildContext context, PGComm pgcomm) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const Expanded(
            child: SizedBox(),
          ),
          Text(
              'Waiting for connection to server.  Retrying in ${pgcomm.reconnectCountdown} seconds...'),
          OutlinedButton(
            onPressed: () {
              pgcomm.tryConnectionAgain();
            },
            child: const Text('Try Now'),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    ));
  }
}
