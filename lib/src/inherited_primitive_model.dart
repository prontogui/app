import 'package:flutter/widgets.dart';
import 'package:dartlib/dartlib.dart' as pg;

/// An adapter class to allow the pg.PrimitiveModel to notify listeners of state changes.
///
/// Note:  the ProntGUI Dartlib doesn't have direct access to Flutter, that is why
/// we need this adapter class.
class PrimitiveModelChangeNotifier extends ChangeNotifier
    implements pg.PrimitiveModelWatcher {
  PrimitiveModelChangeNotifier(
      {required this.model,
      this.notifyOnFull = false,
      this.notifyOnTopLevel = false}) {
    model.addWatcher(this);
  }

  /// True if this should notify when a full model update happens.
  final bool notifyOnFull;

  /// True if this should notify when a top-level primitive update happens.
  final bool notifyOnTopLevel;

  final pg.PrimitiveModel model;

  @override
  void onBeginFullModelUpdate() {
    // Not handled
  }

  @override
  void onFullModelUpdate() {
    if (notifyOnFull) {
      notifyListeners();
    }
  }

  @override
  void onBeginPartialModelUpdate() {
    // Not handled
  }

  @override
  void onPartialModelUpdate() {
    // Not handled
  }

  @override
  void onSetField(pg.PKey pkey, pg.FKey fkeu, bool structural) {
    // Not handled
  }

  @override
  void onIngestField(pg.PKey pkey, pg.FKey fkeu, bool structural) {
    // Not handled
  }

  @override
  void onTopLevelPrimitiveUpdate() {
    if (notifyOnTopLevel) {
      notifyListeners();
    }
  }
}

/// A widget that is used to rebuild the widget tree if the model itself is fully updated.
class InheritedPrimitiveModel
    extends InheritedNotifier<PrimitiveModelChangeNotifier> {
  const InheritedPrimitiveModel({
    super.key,
    super.notifier,
    required super.child,
  });

  static pg.PrimitiveModel of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedPrimitiveModel>()!
        .notifier!
        .model;
  }
}

/// A widget that is used to rebuild the widget tree if a top-level primitive is updated.
class InheritedTopLevelPrimitives
    extends InheritedNotifier<PrimitiveModelChangeNotifier> {
  const InheritedTopLevelPrimitives({
    super.key,
    super.notifier,
    required super.child,
  });

  static List<pg.Primitive> of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedTopLevelPrimitives>()!
        .notifier!
        .model
        .topPrimitives;
  }
}
