// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'widgets/server_field.dart';
import 'inherited_comm.dart';
import 'package:dartlib/dartlib.dart' as pg;

class WaitingForServerView extends StatelessWidget {
  const WaitingForServerView({super.key, required this.operatingView});

  final Widget operatingView;

  @override
  Widget build(BuildContext context) {
    var comm = InheritedCommClient.of(context);

    switch (comm.state) {
      case pg.CommState.inactive:
        return _buildInactiveMessage(context, comm);
      case pg.CommState.active:
        return operatingView;
      case pg.CommState.connecting:
        return _buildBlankScreen(context);
      case pg.CommState.connectingWait:
        return _buildConnectingWaitMessage(context, comm);
      case pg.CommState.reestablishmentDelay:
        return _buildReestablishmentDelayMessage(context, comm);
    }
  }

  Widget _buildBlankScreen(BuildContext context) {
    return const Scaffold(body: SizedBox());
  }

  Widget _openButton(pg.CommClientCtl pgcomm) {
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

  Widget _closeButton(pg.CommClientCtl pgcomm) {
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

  Widget _buildInactiveMessage(BuildContext context, pg.CommClientCtl comm) {
    return _buildCommon(
        comm,
        const Text('Communication closed.'),
        SizedBox(
            height: 50,
            child: ServerField(
              comm: comm,
            )),
        true);
  }

  Widget _buildConnectingWaitMessage(
      BuildContext context, pg.CommClientCtl pgcomm) {
    return _buildCommon(
        pgcomm,
        Row(
          children: [
            Text(
                'Waiting for connection to server ${pgcomm.serverEndpointDescription()}'),
            TextButton(
                onPressed: () => pgcomm.tryConnectionAgain(),
                child: const Text('Try Again')),
          ],
        ),
        const LinearProgressIndicator(),
        false);
  }

  Widget _buildReestablishmentDelayMessage(
      BuildContext context, pg.CommClientCtl pgcomm) {
    return _buildCommon(
      pgcomm,
      Row(
        children: [
          Text(
              'Reestablishing connection to server ${pgcomm.serverEndpointDescription()}'),
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
      pg.CommClientCtl pgcomm, Widget widget1, Widget? widget2, bool openMode) {
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
