import 'package:app/src/embodiment/properties.dart';
import 'package:flutter/material.dart';
import 'embodiment_args.dart';

class EmbodimentManifestEntry {
  EmbodimentManifestEntry(
      this.embodiment, this.factoryFunction, this.propertyAccess,
      {this.keyRequired = false});

  final String embodiment;
  final Widget Function(EmbodimentArgs, {Key? key}) factoryFunction;
  final Properties Function(Map<String, dynamic>? embodimentMap,
      {Properties? initialProperties}) propertyAccess;
  final bool keyRequired;
}

class EmbodimentPackageManifest {
  EmbodimentPackageManifest(this.primitiveType, this.entries);

  final String primitiveType;
  final List<EmbodimentManifestEntry> entries;
}
