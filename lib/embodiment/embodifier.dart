// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/check.dart' as pri;
import 'package:app/primitive/choice.dart' as pri;
import 'package:app/primitive/command.dart' as pri;
import 'package:app/primitive/exportfile.dart' as pri;
import 'package:app/primitive/frame.dart' as pri;
import 'package:app/primitive/group.dart' as pri;
import 'package:app/primitive/list.dart' as pri;
import 'package:app/primitive/importfile.dart' as pri;
import 'package:app/primitive/primitive.dart';
import 'package:app/primitive/table.dart' as pri;
import 'package:app/primitive/timer.dart' as pri;
import 'package:app/primitive/text.dart' as pri;
import 'package:app/primitive/textfield.dart' as pri;
import 'package:app/primitive/tristate.dart' as pri;
import 'package:app/embodiment/check_embodiment.dart';
import 'package:app/embodiment/choice_embodiment.dart';
import 'package:app/embodiment/command_embodiment.dart';
import 'package:app/embodiment/exportfile_embodiment.dart';
import 'package:app/embodiment/frame_embodiment.dart';
import 'package:app/embodiment/group_embodiment.dart';
import 'package:app/embodiment/importfile_embodiment.dart';
import 'package:app/embodiment/list_embodiment.dart';
import 'package:app/embodiment/table_embodiment.dart';
import 'package:app/embodiment/text_embodiment.dart';
import 'package:app/embodiment/textfield_embodiment.dart';
import 'package:app/embodiment/timer_embodiment.dart';
import 'package:app/embodiment/tristate_embodiment.dart';
import 'package:flutter/widgets.dart';

/// This object builds embodiments for the primitive model.
class Embodifier extends InheritedWidget {
  const Embodifier({
    super.key,
    required super.child,
  });

  /// Boilerplate method for InheritedWidget access inside widgets.
  static Embodifier? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Embodifier>();
  }

  /// Boilerplate method for InheritedWidget access inside widgets.
  static Embodifier of(BuildContext context) {
    final Embodifier? result = maybeOf(context);
    assert(result != null, 'No Embodifier found in context');
    return result!;
  }

  /// Boilerplate method for InheritedWidget access inside widgets.
  @override
  bool updateShouldNotify(Embodifier oldWidget) => false;

  /// Builds the particular embodiment for a primitive.
  ///
  /// This is meant to be used internally to this class its closures.
  Widget _buildEmbodiment(
      BuildContext context, Primitive primitive, Primitive? templatePrimitive) {
    Map<String, dynamic>? embodimentMap;

    if (templatePrimitive != null) {
      embodimentMap = templatePrimitive.getEmbodimentProperties();
    }
    embodimentMap ??= primitive.getEmbodimentProperties();

    if (primitive is pri.Command) {
      var cmd = primitive as pri.Command;
      return CommandEmbodiment(command: cmd, embodimentMap: embodimentMap);
    } else if (primitive is pri.ExportFile) {
      var exportFile = primitive as pri.ExportFile;
      return ExportFileEmbodiment(exportFile: exportFile);
    } else if (primitive is pri.Group) {
      var grp = primitive as pri.Group;
      return GroupEmbodiment(group: grp);
    } else if (primitive is pri.ImportFile) {
      var importFile = primitive as pri.ImportFile;
      return ImportFileEmbodiment(importFile: importFile);
    } else if (primitive is pri.Text) {
      var txt = primitive as pri.Text;
      return TextEmbodiment(text: txt, embodimentMap: embodimentMap);
    } else if (primitive is pri.Choice) {
      var choice = primitive as pri.Choice;
      return ChoiceEmbodiment(choice: choice);
    } else if (primitive is pri.Check) {
      var check = primitive as pri.Check;
      return CheckEmbodiment(check: check);
    } else if (primitive is pri.Tristate) {
      var tristate = primitive as pri.Tristate;
      return TristateEmbodiment(tristate: tristate);
    } else if (primitive is pri.ListP) {
      var listp = primitive as pri.ListP;
      return ListEmbodiment(list: listp, embodimentMap: embodimentMap);
    } else if (primitive is pri.TextField) {
      var tf = primitive as pri.TextField;
      return TextFieldEmbodiment(textfield: tf, key: UniqueKey());
    } else if (primitive is pri.Frame) {
      var frame = primitive as pri.Frame;
      return FrameEmbodiment(frame: frame, embodimentMap: embodimentMap);
    } else if (primitive is pri.TableP) {
      var table = primitive as pri.TableP;
      return TableEmbodiment(table: table);
    } else if (primitive is pri.TimerP) {
      var timer = primitive as pri.TimerP;
      return TimerEmbodiment(timer: timer);
    } else {
      // TODO:  throw an exception of some kind
      return const Text("Unknown Primitive");
    }
  }

  /// Builds the particular embodiment for a primitive and injects a listenable builder
  /// if the primitive is a notifification point.
  Widget buildPrimitive(BuildContext context, Primitive primitive,
      [Primitive? templatePrimitive]) {
    // Is this embodiment an update point?
    var notifier = primitive.doesNotify();
    if (notifier != null) {
      // Plug-in a parent node that will rebuild the embodiment when the primitive notifies a change occurred
      return ListenableBuilder(
        listenable: notifier,
        builder: (BuildContext context, Widget? child) {
          return _buildEmbodiment(context, primitive, templatePrimitive);
        },
        child: null,
      );
    }

    return _buildEmbodiment(context, primitive, templatePrimitive);
  }

  /// Builds a list of embodiments corresponding to a list of primitives.
  List<Widget> buildPrimitiveList(
      BuildContext context, List<Primitive> primitives) {
    var widgets = <Widget>[];

    for (final primitive in primitives) {
      widgets.add(
        buildPrimitive(context, primitive),
      );
    }

    return widgets;
  }

  /// Builds a list of embodiments corresponding to a list of primitives.
  List<Widget> buildPrimitiveListExpanded(
      BuildContext context, List<Primitive> primitives) {
    var widgets = <Widget>[];

    for (final primitive in primitives) {
      widgets.add(
        Expanded(
          child: buildPrimitive(context, primitive),
        ),
      );
    }

    return widgets;
  }
}
