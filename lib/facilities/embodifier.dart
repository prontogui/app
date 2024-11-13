// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart'; // as pg;
import '../embodiment_properties/frame_embodiment_properties.dart';
import 'package:flutter/widgets.dart';
import '../embodiment/notifier.dart';
import '../embodiment/embodiment_factory.dart';

/// This object builds embodiments for the primitive model.
class Embodifier implements PrimitiveModelWatcher {
  Embodifier();

  // The pool of notifiers that are used to rebuild the embodiments when a change occurs.
  final List<Notifier> _notifierPool = [];
  int _nextAvailableNotifier = 0;

  // The map of pkeys to notifiers.
  final Map<PKey, Notifier> _pkeyToNotifier = {};

  /// Notifies the builder associated with the pkey that a change has occurred.
  void notifyBuilder(PKey pkey) {
    var origPkey = pkey;

    do {
      var found = _pkeyToNotifier[pkey];
      if (found != null) {
        found.notifyListeners();
        return;
      }
      pkey = PKey.parentOf(pkey);
    } while (!pkey.isEmpty);

    logger.d('No builder notifier found for pkey $origPkey');
  }

  /// Tests whether a frame is a view-type frame.
  bool isView(Frame frame) {
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
    _nextAvailableNotifier++;
    return notifier;
  }

  /// Returns the notifier associate with the primitive or creates a new
  /// association if one does not exist.
  Notifier _getOrMakeNotifier(Primitive primitive) {
    var pkey = primitive.pkey;
    if (_pkeyToNotifier.containsKey(pkey)) {
      return _pkeyToNotifier[pkey]!;
    }

    var notifier = _getNextAvailableNotifier();
    _pkeyToNotifier[pkey] = notifier;
    return notifier;
  }

  /// Returns a Listenable object if the primitive is a notification point.
  Listenable? _doesNotify(Primitive primitive) {
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
      BuildContext context, Primitive primitive, String parentWidgetType) {
    Map<String, dynamic>? embodimentMap;

    embodimentMap ??= primitive.embodimentProperties;

    return EmbodimentFactory.createEmbodiment(
        primitive, embodimentMap, parentWidgetType);
  }

  /// Builds the particular embodiment for a primitive and injects a listenable builder
  /// if the primitive is a notifification point.
  Widget buildPrimitive(
      BuildContext context, Primitive primitive, String parentWidgetType) {
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
      List<Primitive> primitives, String parentWidgetType) {
    var widgets = <Widget>[];

    for (final primitive in primitives) {
      widgets.add(
        buildPrimitive(context, primitive, parentWidgetType),
      );
    }

    return widgets;
  }

  /// Prepares for a full rebuild by reseting the notifier pool and the pkey to notifier map.
  ///
  /// This should be called when the entire model is updated.
  void _prepareForFullRebuild() {
    logger.t('Entered _prepareForFullRebuild');

    _pkeyToNotifier.clear();
    _nextAvailableNotifier = 0;
  }

  @override
  void onBeginFullModelUpdate() {
    _prepareForFullRebuild();
  }

  @override
  void onFullModelUpdate() {
    // Not handled
  }

  @override
  void onBeginPartialModelUpdate() {
    // TODO: implement onBeginPartialModelUpdate
  }

  @override
  void onPartialModelUpdate() {
    logger.t(
        'emodifier metrics:  ${_pkeyToNotifier.length} notifiers in action, pool size: ${_notifierPool.length}');
  }

  @override
  void onTopLevelPrimitiveUpdate() {
    // TODO: implement onTopLevelPrimitiveUpdate
  }

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural) {
    // TODO: implement onSetField
  }

  @override
  void onIngestField(PKey pkey, FKey fkey, bool structural) {
    // Not handled
  }
}

/// A widget that provides access to the Embodifier object inside build routines.
class InheritedEmbodifier extends InheritedWidget {
  const InheritedEmbodifier(
      {super.key, required super.child, required this.embodifier});

  final Embodifier embodifier;

  /// Boilerplate method for InheritedWidget access inside widgets.
  @override
  bool updateShouldNotify(InheritedEmbodifier oldWidget) => false;

  /// Boilerplate method for InheritedWidget access inside widgets.
  static InheritedEmbodifier? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedEmbodifier>();
  }

  /// Boilerplate method for InheritedWidget access inside widgets.
  static Embodifier of(BuildContext context) {
    final InheritedEmbodifier? result = maybeOf(context);
    if (result == null) {
      throw Exception('No Embodifier found in context');
    }
    return result.embodifier;
  }
}
