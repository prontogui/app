import 'package:flutter/material.dart';
import 'embodiment_args.dart';

class EmbodimentManifestEntry {
  EmbodimentManifestEntry(this.embodiment, this.factoryFunction,
      {this.keyRequired = false});

  final String embodiment;
  final Widget Function(EmbodimentArgs, {Key? key}) factoryFunction;
  final bool keyRequired;
}

class EmbodimentPackageManifest {
  EmbodimentPackageManifest(this.primitiveType, this.entries);

  final String primitiveType;
  final List<EmbodimentManifestEntry> entries;
}
