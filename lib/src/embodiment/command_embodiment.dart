// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'package:app/src/embodiment/embodiment_interface.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Command', [
    EmbodimentManifestEntry('default', (args) {
      return ElevatedButtonCommandEmbodiment(
          key: args.key, command: args.primitive as pg.Command);
    }),
    EmbodimentManifestEntry('outlined-button', (args) {
      return OutlinedButtonCommandEmbodiment(
          key: args.key, command: args.primitive as pg.Command);
    }),
  ]);
}

class ElevatedButtonCommandEmbodiment extends StatelessWidget {
  const ElevatedButtonCommandEmbodiment({super.key, required this.command});

  final pg.Command command;

  Widget _buildAsHidden(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    // Is the command hidden?
    if (command.status == 2) {
      return _buildAsHidden(context);
    }

    return ElevatedButton(
      onPressed: command.issueNow,
      child: Text(command.label),
    );
  }
}

class OutlinedButtonCommandEmbodiment extends StatelessWidget {
  const OutlinedButtonCommandEmbodiment({super.key, required this.command});

  final pg.Command command;

  Widget _buildAsHidden(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    // Is the command hidden?
    if (command.status == 2) {
      return _buildAsHidden(context);
    }

    return OutlinedButton(
      onPressed: command.issueNow,
      child: Text(command.label),
    );
  }
}
