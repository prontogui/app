import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:flutter/widgets.dart';
import 'package:dartlib/dartlib.dart' as pg;

/// An adapter class to allow the pg.PrimitiveModel to notify listeners of state changes.
///
/// Note:  the ProntGUI Dartlib doesn't have direct access to Flutter, that is why
/// we need this adapter class.
class PrimitiveModelChangeNotifier extends ChangeNotifier
    implements pg.PrimitiveModelWatcher {
  PrimitiveModelChangeNotifier();

  pg.PrimitiveModel? _model;

  pg.PrimitiveModel get model {
    if (_model == null) {
      throw Exception('model has not been assigned.');
    }
    return _model!;
  }

  set model(pg.PrimitiveModel value) {
    if (_model != null) {
      throw Exception('model can only be assigned once.');
    }
    _model = value;
  }

  @override
  void onFullModelUpdate() {
    notifyListeners();
  }

  @override
  void onSetField(PKey pkey, FKey fkeu, bool structural) {
    // Ignore
  }

  @override
  void onTopLevelPrimitiveUpdate() {
    // Ignore
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
