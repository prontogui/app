import 'package:flutter/widgets.dart';
import 'package:dartlib/dartlib.dart';
import 'check_embodiment.dart' as check;
import 'choice_embodiment.dart' as choice;
import 'command_embodiment.dart' as command;
import 'exportfile_embodiment.dart' as export_file;
import 'frame_embodiment.dart' as frame;
import 'group_embodiment.dart' as group;
import 'icon_embodiment.dart' as icon;
import 'importfile_embodiment.dart' as import_file;
import 'list_embodiment.dart' as list;
import 'table_embodiment.dart' as table;
import 'text_embodiment.dart' as text;
import 'textfield_embodiment.dart' as text_field;
import 'timer_embodiment.dart' as timer;
import 'tristate_embodiment.dart' as tristate;
import 'numericfield_embodiment.dart' as numeric_field;
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'properties.dart';

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
    manifests.add(numeric_field.getManifest());
    manifests.add(command.getManifest());
    manifests.add(export_file.getManifest());
    manifests.add(frame.getManifest());
    manifests.add(import_file.getManifest());
    manifests.add(group.getManifest());
    manifests.add(icon.getManifest());
    manifests.add(list.getManifest());
    manifests.add(table.getManifest());
    manifests.add(text.getManifest());
    manifests.add(text_field.getManifest());
    manifests.add(timer.getManifest());
    manifests.add(tristate.getManifest());

    return manifests;
  }

  late final Map<String, Map<String, EmbodimentManifestEntry>> _factoryInfo;

  Widget createEmbodiment(EmbodimentArgs ea) {
    var primitive = ea.primitive;
    var embodiment =
        EmbodimentProperty.getFromMap(primitive.embodimentProperties);
    var primitiveType = ea.primitive.describeType;
    var pinfo = _factoryInfo[primitiveType];
    if (pinfo == null) {
      var msg =
          'No embodifiers for primitive of type $primitiveType with pkey = ${primitive.pkey}';
      logger.e(msg);
      throw Exception(msg);
    }

    var einfo = pinfo[embodiment];
    if (einfo == null) {
      einfo = pinfo['default'];
      if (einfo == null) {
        var msg =
            'Default embodiment (default) not found for primitive of type $primitiveType with pkey = ${primitive.pkey}.';
        logger.e(msg);
        throw Exception(msg);
      }
    }

    // Add a key to the arguments if needed
    Key? key;
    if (einfo.keyRequired) {
      key = UniqueKey();
    }

    return einfo.factoryFunction(ea, key: key);
  }
}
