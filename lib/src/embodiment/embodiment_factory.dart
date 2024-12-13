import 'package:flutter/widgets.dart';
import 'package:dartlib/dartlib.dart';
import 'check_embodiment.dart';
import 'choice_embodiment.dart';
import 'command_embodiment.dart';
import 'exportfile_embodiment.dart';
import 'frame_embodiment.dart';
import 'group_embodiment.dart';
import 'importfile_embodiment.dart';
import 'list_embodiment.dart';
import 'snackbar_embodiment.dart';
import 'table_embodiment.dart';
import 'text_embodiment.dart';
import 'textfield_embodiment.dart';
import 'timer_embodiment.dart';
import 'tristate_embodiment.dart';
import 'numericfield_embodiment.dart';
import '../embodiment_properties/embodiment_property_help.dart';
import 'embodiment_interface.dart';

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
    manifests.add(getManifest());

    return manifests;
  }

  late final Map<String, Map<String, EmbodimentManifestEntry>> _factoryInfo;

  Widget createEmbodiment(Primitive primitive,
      Map<String, dynamic> embodimentMap, String parentWidgetType) {
    var embodiment = getStringProp(embodimentMap, 'embodiment', '');

    var primitiveType = primitive.describeType;
    var pinfo = _factoryInfo[primitiveType];
    if (pinfo == null) {
      var msg =
          'No embodifier for primitive of type $primitiveType with pkey = ${primitive.pkey}';
      logger.e(msg);
      throw Exception(msg);
    }

    var einfo = pinfo[embodiment];
    if (einfo == null) {
      var msg =
          'Embodiment named "$embodiment" does not exist for primitive of type $primitiveType with pkey = ${primitive.pkey}.  Using default embodiment.';
      logger.w(msg);

      einfo = pinfo['default'];
      if (einfo == null) {
        var msg =
            'Default embodiment (default) not found for primitive of type $primitiveType with pkey = ${primitive.pkey}.  Using default embodiment.';
        logger.e(msg);
        throw Exception(msg);
      }
    }

    Key? key;
    if (einfo.keyRequired) {
      key = UniqueKey();
    }

    var args = EmbodimentArgs(primitive, embodimentMap, parentWidgetType, key);
    return einfo.factoryFunction(args);
/*
    switch (primitive.describeType) {
      case "Command":
        return CommandEmbodiment(
            command: primitive as Command, embodimentMap: embodimentMap);
      case "ExportFile":
        return ExportFileEmbodiment(exportFile: primitive as ExportFile);
      case "Group":
        return GroupEmbodiment(group: primitive as Group);
      case "ImportFile":
        return ImportFileEmbodiment(importFile: primitive as ImportFile);
      case "Text":
        return TextEmbodiment(
            text: primitive as Text, embodimentMap: embodimentMap);
      case "Choice":
        return ChoiceEmbodiment(choice: primitive as Choice);
      case "Check":
        return CheckEmbodiment(check: primitive as Check);
      case "Tristate":
        return TristateEmbodiment(tristate: primitive as Tristate);
      case "List":
        return ListEmbodiment(
          list: primitive as ListP,
          embodimentMap: embodimentMap,
          parentWidgetType: parentWidgetType,
        );
      case "TextField":
        return TextFieldEmbodiment(
          textfield: primitive as TextField,
          key: flutter.UniqueKey(),
          parentWidgetType: parentWidgetType,
        );
      case "Frame":
        var frame = primitive as Frame;
        var frameEmbodimentProps =
            FrameEmbodimentProperties.fromMap(embodimentMap);
        if (frameEmbodimentProps.embodiment == "snackbar") {
          return SnackBarEmbodiment(frame: frame, embodimentMap: embodimentMap);
        }

        // All other embodiments of Frame are handled here
        return FrameEmbodiment(
          frame: frame,
          embodimentMap: embodimentMap,
          parentWidgetType: parentWidgetType,
        );
      case "Table":
        return TableEmbodiment(table: primitive as Table);
      case "Timer":
        return TimerEmbodiment(timer: primitive as Timer);
      default:
        var errorMsg =
            'No embodifier for primitive of type ${primitive.describeType} with pkey = ${primitive.pkey}';
        logger.e(errorMsg);
        throw Exception(errorMsg);
    }
    */
  }
}
