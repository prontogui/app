import 'package:flutter/widgets.dart';
import 'package:dartlib/dartlib.dart';
import 'check_embodiment.dart' as check;
import 'choice_embodiment.dart' as choice;
import 'command_embodiment.dart' as command;
import 'exportfile_embodiment.dart' as export_file;
import 'frame_embodiment.dart' as frame;
import 'group_embodiment.dart' as group;
import 'node_embodiment.dart' as node;
import 'nothing_embodiment.dart' as nothing;
import 'icon_embodiment.dart' as icon;
import 'importfile_embodiment.dart' as import_file;
import 'list_embodiment.dart' as list;
import 'table_embodiment.dart' as table;
import 'text_embodiment.dart' as text;
import 'textfield_embodiment.dart' as text_field;
import 'timer_embodiment.dart' as timer;
import 'tree_embodiment.dart' as tree;
import 'tristate_embodiment.dart' as tristate;
import 'numericfield_embodiment.dart' as numeric_field;
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'properties.dart';

class _EmbodimentInfo {
  _EmbodimentInfo(this.manifest, this.properties);
  final EmbodimentManifestEntry manifest;
  final dynamic properties;
}

/// Static class/method for creating embodiments.
class EmbodimentFactory {
  EmbodimentFactory() {
    var allManifests = <String, Map<String, EmbodimentManifestEntry>>{};

    void addManifestInfo(EmbodimentPackageManifest manifest) {
      var pinfo = allManifests[manifest.primitiveType];
      pinfo ??= <String, EmbodimentManifestEntry>{};
      for (var entry in manifest.entries) {
        if (allManifests.containsKey(entry.embodiment)) {
          throw Exception(
              'duplicate embodiment name for primitive ${manifest.primitiveType}');
        }
        pinfo[entry.embodiment] = entry;
      }
      allManifests[manifest.primitiveType] = pinfo;
    }

    var manifests = collectManifests();
    for (var mi in manifests) {
      addManifestInfo(mi);
    }

    _factoryInfo = allManifests;
  }

  List<EmbodimentPackageManifest> collectManifests() {
    var manifests = List<EmbodimentPackageManifest>.empty(growable: true);

    // For each embodiment package...
    manifests.add(check.getManifest());
    manifests.add(choice.getManifest());
    manifests.add(command.getManifest());
    manifests.add(export_file.getManifest());
    manifests.add(frame.getManifest());
    manifests.add(group.getManifest());
    manifests.add(icon.getManifest());
    manifests.add(import_file.getManifest());
    manifests.add(list.getManifest());
    manifests.add(node.getManifest());
    manifests.add(nothing.getManifest());
    manifests.add(numeric_field.getManifest());
    manifests.add(table.getManifest());
    manifests.add(text.getManifest());
    manifests.add(text_field.getManifest());
    manifests.add(timer.getManifest());
    manifests.add(tree.getManifest());
    manifests.add(tristate.getManifest());

    return manifests;
  }

  // All of the embodiment manifest entries.
  late final Map<String, Map<String, EmbodimentManifestEntry>> _factoryInfo;

  // Performs a look up of embodiment manifest entry.  Throws an exception if no entries
  // exist for the primitive type, or if no entry exists for the desired embodiment and
  // there is no default entry.
  EmbodimentManifestEntry _lookupEmbodimentManifest(Primitive primitive) {
    var embodiment = EmbodimentProperty.getFromMap(primitive.embodimentMap);

    // Look up manifest info for primitive
    var primitiveType = primitive.describeType;
    var pinfo = _factoryInfo[primitiveType];
    if (pinfo == null) {
      var msg =
          'No embodifiers for primitive of type $primitiveType with pkey = ${primitive.pkey}';
      logger.e(msg);
      throw Exception(msg);
    }

    // Look up embodiment info from manifest
    var einfo = pinfo[embodiment];
    if (einfo == null) {
      // Not found - try using default embodiment
      einfo = pinfo['default'];
      if (einfo == null) {
        var msg =
            'Default embodiment (default) not found for primitive of type $primitiveType with pkey = ${primitive.pkey}.';
        logger.e(msg);
        throw Exception(msg);
      }
    }

    return einfo;
  }

  /// Creates the embodiment for a primitive.
  Widget createEmbodiment(EmbodimentArgs ea) {
    var primitive = ea.primitive;
    var modelPrimitive = ea.modelPrimitive;

    late _EmbodimentInfo info;

    // Using the embodiment of model primitive?
    if (modelPrimitive != null) {
      // Need to generate info and cache it?
      if (modelPrimitive.embodimentInfo == null) {
        var manifest = _lookupEmbodimentManifest(modelPrimitive);
        var properties = manifest.propertyAccess(modelPrimitive.embodimentMap);
        info = _EmbodimentInfo(manifest, properties);
        modelPrimitive.embodimentInfo = info;
      } else {
        // Get cached embodiment info
        info = modelPrimitive.embodimentInfo as _EmbodimentInfo;
      }
    } else {
      // Need to generate info and cache it?
      if (primitive.embodimentInfo == null) {
        var manifest = _lookupEmbodimentManifest(primitive);
        var properties = manifest.propertyAccess(primitive.embodimentMap);
        info = _EmbodimentInfo(manifest, properties);
        primitive.embodimentInfo = info;
      } else {
        // Get cached embodiment info
        info = primitive.embodimentInfo as _EmbodimentInfo;
      }
    }

    // Finish preparing the embodiment arguments
    ea.properties = info.properties;

    // Add a key to the arguments if needed
    Key? key;
    if (info.manifest.keyRequired) {
      key = UniqueKey();
    }

    return info.manifest.factoryFunction(ea, key: key);
  }
}
