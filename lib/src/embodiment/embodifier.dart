// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import '../embodiment_properties/frame_embodiment_properties.dart';
import 'package:app/src/embodiment/check_embodiment.dart';
import 'package:app/src/embodiment/choice_embodiment.dart';
import 'package:app/src/embodiment/command_embodiment.dart';
import 'package:app/src/embodiment/exportfile_embodiment.dart';
import 'package:app/src/embodiment/frame_embodiment.dart';
import 'package:app/src/embodiment/group_embodiment.dart';
import 'package:app/src/embodiment/importfile_embodiment.dart';
import 'package:app/src/embodiment/list_embodiment.dart';
import 'package:app/src/embodiment/snackbar_embodiment.dart';
import 'package:app/src/embodiment/table_embodiment.dart';
import 'package:app/src/embodiment/text_embodiment.dart';
import 'package:app/src/embodiment/textfield_embodiment.dart';
import 'package:app/src/embodiment/timer_embodiment.dart';
import 'package:app/src/embodiment/tristate_embodiment.dart';
import 'package:flutter/widgets.dart';
import 'notifier.dart';

/// This object builds embodiments for the primitive model.
class Embodifier extends InheritedWidget {
  Embodifier({
    super.key,
    required super.child,
  });

  // The pool of notifiers that are used to rebuild the embodiments when a change occurs.
  final List<Notifier> _notifierPool = [];
  int _nextAvailableNotifier = 0;

  // The map of pkeys to notifiers.
  final Map<pg.PKey, Notifier> _pkeyToNotifier = {};

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

  /// Prepares for a full rebuild by reseting the notifier pool and the pkey to notifier map.
  ///
  /// This should be called when the entire model is updated.
  void prepareForFullRebuild() {
    _pkeyToNotifier.clear();
    _nextAvailableNotifier = 0;
  }

  /// Tests whether a frame is a view-type frame.
  bool isView(pg.Frame frame) {
    var frameEmbodimentProps =
        FrameEmbodimentProperties.fromMap(frame.embodimentProperties);

    return ["full-view", "dialog-view"]
        .contains(frameEmbodimentProps.embodiment);
  }

  /// Returns the next notifier from the pool or adds another to the pool
  Notifier _getNextAvailableNotifier() {
    if (_nextAvailableNotifier < _notifierPool.length) {
      return _notifierPool[_nextAvailableNotifier++];
    }

    var notifier = Notifier();
    _notifierPool.add(notifier);
    return notifier;
  }

  /// Returns the notifier associate with the primitive or creates a new
  /// association if one does not exist.
  Notifier _getOrMakeNotifier(pg.Primitive primitive) {
    var pkey = primitive.pkey;
    if (_pkeyToNotifier.containsKey(pkey)) {
      return _pkeyToNotifier[pkey]!;
    }

    var notifier = _getNextAvailableNotifier();
    _pkeyToNotifier[pkey] = notifier;
    return notifier;
  }

  /// Returns a Listenable object if the primitive is a notification point.
  Listenable? _doesNotify(pg.Primitive primitive) {
    switch (primitive.describeType) {
      // These are the primitives that are considered notification points
      case 'Frame':
      case 'Group':
      case 'List':
      case 'Table':
      case 'Timer':
        return _getOrMakeNotifier(primitive);
      default:
        return null;
    }
  }

  /// Builds the particular embodiment for a primitive.
  ///
  /// This is meant to be used internally to this class its closures.
  Widget _buildEmbodiment(
      BuildContext context, pg.Primitive primitive, String parentWidgetType) {
    Map<String, dynamic>? embodimentMap;

    embodimentMap ??= primitive.embodimentProperties;

    switch (primitive.describeType) {
      case "Command":
        return CommandEmbodiment(
            command: primitive as pg.Command, embodimentMap: embodimentMap);
      case "ExportFile":
        return ExportFileEmbodiment(exportFile: primitive as pg.ExportFile);
      case "Group":
        return GroupEmbodiment(group: primitive as pg.Group);
      case "ImportFile":
        return ImportFileEmbodiment(importFile: primitive as pg.ImportFile);
      case "Text":
        return TextEmbodiment(
            text: primitive as pg.Text, embodimentMap: embodimentMap);
      case "Choice":
        return ChoiceEmbodiment(choice: primitive as pg.Choice);
      case "Check":
        return CheckEmbodiment(check: primitive as pg.Check);
      case "Tristate":
        return TristateEmbodiment(tristate: primitive as pg.Tristate);
      case "List":
        return ListEmbodiment(
          list: primitive as pg.ListP,
          embodimentMap: embodimentMap,
          parentWidgetType: parentWidgetType,
        );
      case "TextField":
        return TextFieldEmbodiment(
          textfield: primitive as pg.TextField,
          key: UniqueKey(),
          parentWidgetType: parentWidgetType,
        );
      case "Frame":
        var frame = primitive as pg.Frame;
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
        return TableEmbodiment(table: primitive as pg.Table);
      case "Timer":
        return TimerEmbodiment(timer: primitive as pg.Timer);
      default:
        // TODO:  throw an exception of some kind
        return const Text("Unknown Primitive");
    }
  }

  /// Builds the particular embodiment for a primitive and injects a listenable builder
  /// if the primitive is a notifification point.
  Widget buildPrimitive(
      BuildContext context, pg.Primitive primitive, String parentWidgetType) {
    // Is this embodiment an update point?
    var notifier = _doesNotify(primitive);
    if (notifier != null) {
      // Plug-in a parent node that will rebuild the embodiment when the primitive notifies a change occurred
      return ListenableBuilder(
        listenable: notifier,
        builder: (BuildContext context, Widget? child) {
          return _buildEmbodiment(context, primitive, parentWidgetType);
        },
        child: null,
      );
    }

    return _buildEmbodiment(context, primitive, parentWidgetType);
  }

  /// Builds a list of embodiments corresponding to a list of primitives.
  List<Widget> buildPrimitiveList(BuildContext context,
      List<pg.Primitive> primitives, String parentWidgetType) {
    var widgets = <Widget>[];

    for (final primitive in primitives) {
      widgets.add(
        buildPrimitive(context, primitive, parentWidgetType),
      );
    }

    return widgets;
  }
}
