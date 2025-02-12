import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:animated_tree_view/animated_tree_view.dart';
import 'embodiment_manifest.dart';
import 'embodiment_help.dart';
import 'embodiment_args.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Node', [
    EmbodimentManifestEntry('default', NodeEmbodiment.fromArgs),
  ]);
}

class NodeEmbodiment extends StatelessWidget {
  NodeEmbodiment.fromArgs(this.args, {super.key})
      : node = args.primitive as pg.Node,
        props = CommonProperties.fromMap(args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.Node node;
  final CommonProperties props;

  @override
  Widget build(BuildContext context) {
    var content = const Icon(Icons.account_tree);

    return encloseWithPBMSAF(content, props, args);
  }
}
