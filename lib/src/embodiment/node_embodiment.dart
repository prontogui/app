import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'embodiment_manifest.dart';
import 'embodiment_help.dart';
import 'embodiment_args.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Node', [
    EmbodimentManifestEntry(
        'default', NodeEmbodiment.fromArgs, CommonProperties.fromMap),
  ]);
}

class NodeEmbodiment extends StatelessWidget {
  const NodeEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var content = const Icon(Icons.account_tree);

    return encloseWithPBMSAF(content, args);
  }
}
