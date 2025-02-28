import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:animated_tree_view/animated_tree_view.dart';
import 'embodiment_manifest.dart';
import 'embodiment_help.dart';
import 'embodiment_args.dart';
import 'properties.dart';
import '../embodifier.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Tree', [
    EmbodimentManifestEntry('default', TreeDefaultEmbodiment.fromArgs,
        TreeDefaultProperties.fromMap),
  ]);
}

class TreeDefaultEmbodiment extends StatelessWidget {
  const TreeDefaultEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  // Recursive function to convert a tree of pg.Node to a tree of IndexedTreeNode.
  IndexedTreeNode<pg.Node> convertTree(pg.Node node, IndexedNode? parent) {
    var itn = IndexedTreeNode<pg.Node>(parent: parent);
    itn.data = node;
    for (var child in node.subNodes) {
      if (child is pg.Node) {
        var childItn = convertTree(child, itn);
        itn.add(childItn);
      }
    }
    return itn;
  }

  Widget embodifySingleItem(BuildContext context, Embodifier embodifier,
      pg.Primitive? item, pg.Primitive? modelItem) {
    if (item == null) {
      return SizedBox.shrink();
    }
    // Only certain primitives are supported
    if (item is! pg.Text && item is! pg.Frame && item is! pg.Group) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text('?'),
      );
    }

    return embodifier.buildPrimitive(context, item, modelPrimitive: modelItem);
  }

  @override
  Widget build(BuildContext context) {
    var embodifier = InheritedEmbodifier.of(context);
    var tree = args.primitive as pg.Tree;
    var modelItem = tree.modelItem;

    var content = TreeView.indexed(
        indentation: Indentation(style: IndentStyle.roundJoint),
        onTreeReady: (controller) =>
            controller.expandAllChildren(controller.tree, recursive: true),
        tree: convertTree(tree.root, null),
        builder: (context, itn) {
          // build your node item here
          // return any widget that you need
          var node = itn.data as pg.Node;

          return embodifySingleItem(
              context, embodifier, node.nodeItem, modelItem);
        });

    return encloseWithPBMSAF(content, args, verticalUnbounded: true);
  }
}
