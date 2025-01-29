import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'icon_map.dart';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Icon', [
    EmbodimentManifestEntry('default', IconEmbodiment.fromArgs),
  ]);
}

class IconEmbodiment extends StatelessWidget {
  IconEmbodiment.fromArgs(this.args, {super.key})
      : icon = args.primitive as pg.Icon,
        props =
            IconDefaultProperties.fromMap(args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.Icon icon;
  final IconDefaultProperties props;

  @override
  Widget build(BuildContext context) {
    return Icon(translateIdToIconData(icon.iconID),
        color: props.color, size: props.size);
  }
}
