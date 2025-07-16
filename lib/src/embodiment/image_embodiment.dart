import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'embodiment_manifest.dart';
import 'embodiment_help.dart';
import 'embodiment_args.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Image', [
    EmbodimentManifestEntry('default', ImageDefaultEmbodiment.fromArgs,
        ImageDefaultProperties.fromMap),
  ]);
}

class ImageDefaultEmbodiment extends StatelessWidget {
  const ImageDefaultEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var img = args.primitive as pg.Image;
    var props = args.properties as ImageDefaultProperties;

    // Convert ImageFit enum to Flutter's BoxFit enum
    late BoxFit fit;
    switch (props.imageFit) {
      case ImageFit.fill:
        fit = BoxFit.fill;
      case ImageFit.contain:
        fit = BoxFit.contain;
      case ImageFit.cover:
        fit = BoxFit.cover;
      case ImageFit.fitWidth:
        fit = BoxFit.fitWidth;
      case ImageFit.fitHeight:
        fit = BoxFit.fitHeight;
      case ImageFit.none:
        fit = BoxFit.none;
       case ImageFit.scaleDown:
        fit = BoxFit.scaleDown;
    }

    Widget content;
    var imageData = img.image;
    if (imageData.isNotEmpty) {
      content = Image.memory(imageData, fit: fit);
    } else {
      content = Icon(Icons.image_not_supported,
        color: Colors.black45);
    }

    return encloseWithPBMSAF(content, args);
  }
}
