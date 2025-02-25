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

  Widget embodifySingleItem(
      BuildContext context, Embodifier embodifier, pg.Primitive item) {
    // Only certain primitives are supported
    if (item is! pg.Text && item is! pg.Frame && item is! pg.Group) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text('?'),
      );
    }

    return embodifier.buildPrimitive(context, item);
  }

  @override
  Widget build(BuildContext context) {
    var embodifier = InheritedEmbodifier.of(context);
    var tree = args.primitive as pg.Tree;
    //var props = args.properties as TreeDefaultProperties;

    var content = TreeView.indexed(
        indentation: Indentation(style: IndentStyle.roundJoint),
        onTreeReady: (controller) =>
            controller.expandAllChildren(controller.tree, recursive: true),
        tree: convertTree(tree.root, null),
        builder: (context, node) {
          // build your node item here
          // return any widget that you need
          var primitive = node.data as pg.Primitive;
          return embodifySingleItem(context, embodifier, primitive);
/*
          return Card.outlined(
            child: ListTile(
              title: Text("Item ${node.level}- ${pgNode.describeType}"),
              subtitle: Text('Level ${node.level}'),
            ),
          );
          */
        });

    return encloseWithPBMSAF(content, args, verticalUnbounded: true);
  }
}

/*
  Widget embodifySingleItem(BuildContext context, Embodifier embodifier,
      pg.Primitive item, String parentWidgetType) {
    // Only certain primitives are supported
    if (item is! pg.Text &&
        item is! pg.Command &&
        item is! pg.Check &&
        item is! pg.Choice &&
        item is! pg.NumericField) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text('?'),
      );
    }

    return embodifier.buildPrimitive(context, EmbodimentArgs(item));
  }
*/
