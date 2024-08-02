// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/pgcomm/pgcomm.dart';
import 'package:flutter/material.dart';
import 'serverfield.dart';

class WaitingForServerView extends StatelessWidget {
  const WaitingForServerView({super.key, required this.operatingView});

  final Widget operatingView;

  @override
  Widget build(BuildContext context) {
    var pgcomm = InheritedPGComm.of(context);

    switch (pgcomm.state) {
      case PGCommState.inactive:
        return _buildInactiveMessage(context, pgcomm);
      case PGCommState.active:
        return operatingView;
      case PGCommState.connecting:
        return _buildBlankScreen(context);
      case PGCommState.connectingWait:
        return _buildConnectingWaitMessage(context, pgcomm);
      case PGCommState.reestablishmentDelay:
        return _buildReestablishmentDelayMessage(context, pgcomm);
    }
  }

  Widget _buildBlankScreen(BuildContext context) {
    return const Scaffold(body: SizedBox());
  }

  Widget _openButton(PGComm pgcomm) {
    return OutlinedButton.icon(
      onPressed: () {
        pgcomm.open();
      },
      label: const Text('Open'),
      icon: const Icon(
        Icons.link_outlined,
        color: Colors.black87,
        size: 30.0,
      ),
    );
  }

  Widget _closeButton(PGComm pgcomm) {
    return OutlinedButton.icon(
      onPressed: () {
        pgcomm.close();
      },
      label: const Text('Close'),
      icon: const Icon(
        Icons.link_off_outlined,
        color: Colors.black87,
        size: 30.0,
      ),
    );
  }

  Widget _buildInactiveMessage(BuildContext context, PGComm pgcomm) {
    return _buildCommon(
        pgcomm,
        const Text('Communication closed.'),
        SizedBox(
            height: 50,
            child: ServerField(
              pgcomm: pgcomm,
            )),
        true);
  }

  Widget _buildConnectingWaitMessage(BuildContext context, PGComm pgcomm) {
    return _buildCommon(
        pgcomm,
        Row(
          children: [
            Text(
                'Waiting for connection to server ${pgcomm.serverAddress}:${pgcomm.serverPort}'),
            TextButton(
                onPressed: () => pgcomm.tryConnectionAgain(),
                child: const Text('Try Again')),
          ],
        ),
        const LinearProgressIndicator(),
        false);
  }

  Widget _buildReestablishmentDelayMessage(
      BuildContext context, PGComm pgcomm) {
    return _buildCommon(
      pgcomm,
      Row(
        children: [
          Text(
              'Reestablishing connection to server ${pgcomm.serverAddress}:${pgcomm.serverPort}'),
          TextButton(
              onPressed: () => pgcomm.tryConnectionAgain(),
              child: const Text('Try Again')),
        ],
      ),
      LinearProgressIndicator(
        value: pgcomm.reestablishmentWaitProgress,
      ),
      false,
    );
  }

  Widget _buildCommon(
      PGComm pgcomm, Widget widget1, Widget? widget2, bool openMode) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        width: 500,
        child: Column(
          children: [
            const Spacer(),
            Icon(
              openMode ? Icons.link_off_outlined : Icons.link_outlined,
              color: openMode ? Colors.black87 : Colors.green,
              size: 60.0,
            ),
            widget1,
            widget2 ??
                const SizedBox(
                  height: 30,
                ),
            const SizedBox(
              height: 30,
            ),
            openMode ? _openButton(pgcomm) : _closeButton(pgcomm),
            const Spacer(),
          ],
        ),
      ),
    ));
  }
}
