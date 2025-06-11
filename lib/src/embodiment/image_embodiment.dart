import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'embodiment_manifest.dart';
import 'embodiment_help.dart';
import 'embodiment_args.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Image', [
    EmbodimentManifestEntry('default', ImageDefaultEmbodiment.fromArgs,
        IconDefaultProperties.fromMap),
  ]);
}

class ImageDefaultEmbodiment extends StatelessWidget {
  const ImageDefaultEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var img = args.primitive as pg.Image;
//    var props = args.properties as ImageDefaultProperties;

    var content = Image.memory(img.image);

    return encloseWithPBMSAF(content, args);
  }
}
