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

class TreeDefaultEmbodiment extends StatefulWidget {
  TreeDefaultEmbodiment.fromArgs(this.args, {super.key})
      : tree = args.primitive as pg.Tree;

  final EmbodimentArgs args;
  final pg.Tree tree;

  @override
  State<TreeDefaultEmbodiment> createState() => _TreeDefaultEmbodimentState();
}

bool _listEquals(List<int> list1, List<int> list2) {
  if (list1.length != list2.length) {
    return false;
  }
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) {
      return false;
    }
  }
  return true;
}

// Function to convert a tree of pg.Node to a tree of IndexedTreeNode.
IndexedTreeNode<pg.Node> _convertTree(pg.Node node, IndexedNode? parent) {
  // Internal recursive function for converting the tree
  IndexedTreeNode<pg.Node> recurseConvertTree(
      pg.Node node, IndexedNode? parent, List<int> path) {
    var itn = IndexedTreeNode<pg.Node>(parent: parent);

    // Save path (from root) to this subnode
    node.appData = List<int>.unmodifiable(path);
    itn.data = node;

    if (node.subNodes.isNotEmpty) {
      // Push another index to represent subnode
      path.add(0);

      // Recurse through each sub node
      int index = 0;
      for (var child in node.subNodes) {
        if (child is pg.Node) {
          // Update path for this sub node
          path[path.length - 1] = index;
          var childItn = recurseConvertTree(child, itn, path);
          itn.add(childItn);
        }
        index++;
      }
      // Pop index for subnode
      path.removeLast();
    }

    return itn;
  }

  return recurseConvertTree(node, parent, []);
}

const Set<String> _allowedTypes = {
  'Text',
  'Frame',
  'Group',
  'Choice',
  'Card',
  'Icon'
};

class _TreeDefaultEmbodimentState extends State<TreeDefaultEmbodiment> {
  IndexedTreeNode<pg.Node>? indexedTree;

  void setCurrentSelected(List<int> newSelected) {
    setState(() {
      widget.tree.selection = newSelected;
    });
  }

  Widget embodifySingleItem(
      BuildContext context,
      Embodifier embodifier,
      pg.Tree tree,
      List<int> indices,
      pg.Primitive? item,
      pg.Primitive? modelItem) {
    if (item == null) {
      return SizedBox.shrink();
    }
    // Only certain primitives are supported
    if (!_allowedTypes.contains(item.describeType)) {
      // TODO:  show something better for error case.  Perhaps log an error also.
      return const SizedBox(
        child: Text('?'),
      );
    }

    bool isSelected(List<int> indices) {
      return _listEquals(widget.tree.selection, indices);
    }

    void onSelection(List<int> indices) {
      setCurrentSelected(indices);
    }

    var callbacks = EmbodimentCallbacks(indices,
        isSelected: isSelected, onSelection: onSelection);

    return embodifier.buildPrimitive(context, item,
        modelPrimitive: modelItem, callbacks: callbacks);
  }

  @override
  Widget build(BuildContext context) {
    var embodifier = InheritedEmbodifier.of(context);
    var modelItem = widget.tree.modelItem;

    indexedTree ??= indexedTree = _convertTree(widget.tree.root, null);

    var content = TreeView.indexed(
        indentation: Indentation(style: IndentStyle.roundJoint),
        onTreeReady: (controller) =>
            controller.expandAllChildren(controller.tree, recursive: true),
        tree: indexedTree!,
        builder: (context, itn) {
          // build your node item here
          // return any widget that you need
          var node = itn.data as pg.Node;
          var indices = node.appData as List<int>;

          return embodifySingleItem(context, embodifier, widget.tree, indices,
              node.nodeItem, modelItem);
        });

    return encloseWithPBMSAF(content, widget.args, verticalUnbounded: true);
  }
}
