import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'icon_map.dart';
import 'embodiment_property_help.dart';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Icon', [
    EmbodimentManifestEntry('default', IconEmbodiment.fromArgs),
  ]);
}

class IconEmbodiment extends StatelessWidget {
  IconEmbodiment.fromArgs(this.args, {super.key})
      : icon = args.primitive as pg.Icon,
        props = IconEmbodimentProperties.fromMap(
            args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.Icon icon;
  final IconEmbodimentProperties props;

  @override
  Widget build(BuildContext context) {
    return Icon(translateIdToIconData(icon.iconID),
        color: props.color, size: props.size);
  }
}

class IconEmbodimentProperties {
  //String embodiment;
  Color? color;
  double? size;

  IconEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap)
      : color = getColorProp(embodimentMap, 'color'),
        size = getNumericProp(embodimentMap, 'size');
}
