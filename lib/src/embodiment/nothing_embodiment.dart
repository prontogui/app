import 'package:flutter/material.dart';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Nothing', [
    EmbodimentManifestEntry('default', NothingDefaultEmbodiment.fromArgs),
  ]);
}

class NothingDefaultEmbodiment extends StatelessWidget {
  const NothingDefaultEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
