import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'icon_map.dart';
import 'embodiment_property_help.dart';
import 'embodiment_interface.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Icon', [
    EmbodimentManifestEntry('default', (args) {
      return IconEmbodiment(
          key: args.key,
          icon: args.primitive as pg.Icon,
          props: IconEmbodimentProperties.fromMap(args.embodimentMap));
    }),
  ]);
}

class IconEmbodiment extends StatelessWidget {
  const IconEmbodiment({super.key, required this.icon, required this.props});

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
