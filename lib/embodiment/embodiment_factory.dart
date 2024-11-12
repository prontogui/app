import 'package:flutter/widgets.dart' as flutter;
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
import '../embodiment_properties/frame_embodiment_properties.dart';
import '../log.dart';

/// Static class/method for creating embodiments.
class EmbodimentFactory {
  static flutter.Widget createEmbodiment(Primitive primitive,
      Map<String, dynamic> embodimentMap, String parentWidgetType) {
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
  }
}
