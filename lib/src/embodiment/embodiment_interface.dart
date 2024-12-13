import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart';

class EmbodimentArgs {
  EmbodimentArgs(
      this.primitive, this.embodimentMap, this.parentWidgetType, this.key);

  final Primitive primitive;
  final Map<String, dynamic> embodimentMap;
  final String parentWidgetType;
  final Key? key;
}

class EmbodimentManifestEntry {
  EmbodimentManifestEntry(this.embodiment, this.factoryFunction,
      {this.keyRequired = false});

  final String embodiment;
  final Widget Function(EmbodimentArgs) factoryFunction;
  final bool keyRequired;
}

class EmbodimentPackageManifest {
  EmbodimentPackageManifest(this.primitiveType, this.entries);

  final String primitiveType;
  final List<EmbodimentManifestEntry> entries;
}
