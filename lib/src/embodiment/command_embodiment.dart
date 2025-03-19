// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/src/embodiment/embodiment_help.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Command', [
    EmbodimentManifestEntry('default', ElevatedButtonCommandEmbodiment.fromArgs,
        CommonProperties.fromMap),
    EmbodimentManifestEntry('outlined-button',
        OutlinedButtonCommandEmbodiment.fromArgs, CommonProperties.fromMap),
  ]);
}

class ElevatedButtonCommandEmbodiment extends StatelessWidget {
  const ElevatedButtonCommandEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  Widget _buildAsHidden(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    var command = args.primitive as pg.Command;

    // Is the command hidden?
    if (command.status == 2) {
      return _buildAsHidden(context);
    }

    var content = ElevatedButton(
      onPressed: command.issueNow,
      child: Text(command.label),
    );

    return encloseWithPBMSAF(content, args);
  }
}

class OutlinedButtonCommandEmbodiment extends StatelessWidget {
  const OutlinedButtonCommandEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  Widget _buildAsHidden(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    var command = args.primitive as pg.Command;

    // Is the command hidden?
    if (command.status == 2) {
      return _buildAsHidden(context);
    }

    var content = OutlinedButton(
      onPressed: command.issueNow,
      child: Text(command.label),
    );

    return encloseWithPBMSAF(content, args);
  }
}
