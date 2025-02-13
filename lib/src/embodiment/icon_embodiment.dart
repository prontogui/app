import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'icon_map.dart';
import 'embodiment_manifest.dart';
import 'embodiment_help.dart';
import 'embodiment_args.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Icon', [
    EmbodimentManifestEntry('default', IconDefaultEmbodiment.fromArgs),
  ]);
}

class IconDefaultEmbodiment extends StatelessWidget {
  IconDefaultEmbodiment.fromArgs(this.args, {super.key})
      : icon = args.primitive as pg.Icon,
        props =
            IconDefaultProperties.fromMap(args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.Icon icon;
  final IconDefaultProperties props;

  @override
  Widget build(BuildContext context) {
    var content = Icon(translateIdToIconData(icon.iconID),
        color: props.color, size: props.size);

    return encloseWithPBMSAF(content, props, args);
  }
}
