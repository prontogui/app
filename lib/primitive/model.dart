// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'primitive.dart';
import 'pkey.dart';
import 'package:cbor/cbor.dart';
import 'primitive_factory.dart';
import 'events.dart';
import 'ctor_args.dart';

class ModelChangeNotifier extends ChangeNotifier {
  void notify() {
    super.notifyListeners();
  }
}

/// The complete model of a GUI comprised of primitives.
class PrimitiveModel extends ChangeNotifier implements Primitive {
  PrimitiveModel(this.eventHandler);

  /// The topmost event handler.
  final EventHandler eventHandler;

  /// The top level list of primitives in the GUI.
  List<Primitive> _topPrimitives = [];

  /// A listenable for when partial updates are made to one or more top-level primitives.
  final _topLevelUpdateNotifier = ModelChangeNotifier();

  /// Returns true i-if the model is empty.
  bool get isEmpty {
    return _topPrimitives.isEmpty;
  }

  /// Gets a list of top-level primitives comprising the GUI.
  List<Primitive> get topPrimitives {
    return _topPrimitives;
  }

  /// Gets a listenable object that notifies when full updates are made to the model.
  /// This is equivalent to listenable mixin of this class.
  Listenable get fullUpdateNotifier => this;

  /// Gets a listenable object that notifies when partial updates are made to one
  /// or more top-level view primitives.  Listeners are notified only once after a
  /// partial update is performed versus separate notifications for each view.  If
  /// a full update occurs then listeners will not be notified using this
  /// property.  If desired then listeners should subscribe to
  /// fullUpdateNotifier instead of, or in addition to this property.
  Listenable get topLevelUpdateNotifier => _topLevelUpdateNotifier;

  // Implements the Primitive interface.

  @override
  Listenable? doesNotify({bool notifyNow = false}) {
    if (notifyNow) {
      _topLevelUpdateNotifier.notify();
    }
    return _topLevelUpdateNotifier;
  }

  @override
  void updateFromCbor(CborValue v) {
    assert(v is CborList);

    var l = v as CborList;

    var fullUpdate = l.elementAt(0) as CborBool;
    var updateList = l.sublist(1);

    if (fullUpdate.value) {
      _ingestFullUpdate(updateList);
    } else {
      _ingestPartialUpdate(updateList);
    }
  }

  @override
  Primitive? getParent() {
    return null;
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    var index = locator.nextIndex();

    assert(index < _topPrimitives.length);

    // Note:  this could have been done using tree recursion but since it will be
    // called frequently, it is more efficent to iterate from primitive to primitive
    // and avoid stack overhead.

    late Primitive next;

    for (next = _topPrimitives[index];
        !locator.located();
        next = next.locateNextDescendant(locator)) {
      // All the work is done in the for clause.
    }

    return next;
  }

  @override
  Map<String, dynamic>? getEmbodimentProperties() {
    return null;
  }

  /// Ingests a full update from a list of CBOR values and notifies listeners.
  ///
  /// This method is used internally by the class.
  void _ingestFullUpdate(List<CborValue> l) {
    final numPrimitives = l.length;
    final List<Primitive> newTopPrimitives = [];
    final pkey = PKey.empty();
    final ctorArgs = CtorArgs.multi(this, eventHandler);

    for (var i = 0; i < numPrimitives; i++) {
      var m = l.elementAt(i) as CborMap;

      var newPrimitive = PrimitiveFactory.createPrimitiveFromCborMap(
          ctorArgs.using(m, PKey.addIndex(pkey, i)));

      assert(newPrimitive != null);

      newTopPrimitives.add(newPrimitive!);
    }
    _topPrimitives = newTopPrimitives;

    notifyListeners();
  }

  /// Ingests a partial update from a list of CBOR values.  Listeners are notified as each
  /// updated primitive dictates.
  ///
  /// This method is used internally by the class.
  void _ingestPartialUpdate(List<CborValue> l) {
    final numPrimitives = l.length;
    bool topLevelUpdated = false;

    for (var i = 0; i < numPrimitives; i += 2) {
      var pkey = PKey.fromCbor(l.elementAt(i));
      var m = l.elementAt(i + 1) as CborMap;

      var p = locateNextDescendant(PKeyLocator(pkey));

      p.updateFromCbor(m);

      if (!topLevelUpdated) {
        topLevelUpdated = (pkey.indices.length == 1);
      }
    }

    if (topLevelUpdated) {
      _topLevelUpdateNotifier.notify();
    }
  }
}

/// A widget that is used to rebuild the widget tree if the model itself is fully updated.
class InheritedPrimitiveModel extends InheritedNotifier<PrimitiveModel> {
  const InheritedPrimitiveModel({
    super.key,
    super.notifier,
    required super.child,
  });

  static PrimitiveModel of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedPrimitiveModel>()!
        .notifier!;
  }
}
