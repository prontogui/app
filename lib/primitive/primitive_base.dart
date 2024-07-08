// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'package:flutter/foundation.dart';
import 'primitive.dart';
import 'primitive_factory.dart';
import 'pkey.dart';
import 'fkey.dart';
import 'events.dart';
import 'ctor_args.dart';
import 'notifier.dart';
import 'cbor_conversion.dart';
import 'dart:convert';

/// The base class implementation for every primitive.
///
/// This provides functionality for organizing a primitive tree, handling events from primitives,
/// B-side fields, constructing new descendant primitives, and notifying embodiments when rebuilding
/// is needed to reflect field changes.
abstract class PrimitiveBase implements Primitive {
  PrimitiveBase(CtorArgs ctorArgs)
      : parent = ctorArgs.parent,
        eventHandler = ctorArgs.eventHandler,
        pkey = ctorArgs.pkey {
    _internalUpdateFromCbor(ctorArgs.cbor);
  }

  /// The parent primitive.
  final Primitive parent;

  /// The event handler for events originating at the embodiment level.
  final EventHandler eventHandler;

  /// The primitive key for locating this in the primitive tree.
  final PKey pkey;

  /// The listenable object created as needed for embodiments to subscribe to.
  ///
  /// This is constructed lazily if the primitive is a notification point and has been
  /// queried whether it can notify [doesNotify method].
  Notifier? notifier;

  /// Storage for the embodiment field.
  String embodiment = "";

  /// Cached embodimenet properties.  These are computed on demand and cleared when
  /// embodiment is reassigned.  If embodiment is empty then this value remains null.
  Map<String, dynamic>? _embodimentProperties;

  /// Updates the fields with new values from a CBOR map.
  ///
  /// This is intended to be use internally by this class.
  void _internalUpdateFromCbor(CborMap m) {
    for (final kv in m.entries) {
      var fieldname = kv.key.toString();
      var fkey = fkeyFor(fieldname);

      // first, update any common properties stored in this base class, then delegate
      // update to derived class.
      switch (fkey) {
        case FKey.embodiment:
          embodiment = cborToString(kv.value);
        default:
          updateFieldFromCbor(fkey, kv.value);
      }
    }
  }

  /// Constructs a list of new primitives from a CBOR value representing a CBOR list.
  ///
  /// The new primitives are initialized as proper children.
  List<Primitive> createPrimitivesFromCborList1D(
      CborValue v, int fieldPKeyIndex) {
    var cborList = v as CborList;

    var primitives = <Primitive>[];
    var ctorArgs = CtorArgs.multi(this, eventHandler);

    var containerPkey = PKey.addIndex(pkey, fieldPKeyIndex);

    for (int i = 0; i < cborList.length; i++) {
      var m = cborList[i] as CborMap;

      var primitive = PrimitiveFactory.createPrimitiveFromCborMap(
          ctorArgs.using(m, PKey.addIndex(containerPkey, i)));

      if (primitive == null) {
        // TODO:  raise an exception of particular kind
        break;
      }
      primitives.add(primitive);
    }

    return primitives;
  }

  /// Constructs a list of new primitives from a CBOR value representing a CBOR 2D array
  /// (List of Lists).
  ///
  /// The new primitives are initialized as proper children.
  List<List<Primitive>> createPrimitivesFromCborList2D(
      CborValue v, int fieldPKeyIndex) {
    var cborRows = v as CborList;

    var primitives = <List<Primitive>>[];
    var ctorArgs = CtorArgs.multi(this, eventHandler);

    var containerPkey = PKey.addIndex(pkey, fieldPKeyIndex);

    for (int i = 0; i < cborRows.length; i++) {
      var cborCells = cborRows[i] as CborList;

      var primitiveRow = <Primitive>[];

      var rowPkey = PKey.addIndex(containerPkey, i);

      for (int j = 0; j < cborCells.length; j++) {
        var cborCell = cborCells[j] as CborMap;

        var cellPkey = PKey.addIndex(rowPkey, j);

        var primitive = PrimitiveFactory.createPrimitiveFromCborMap(
            ctorArgs.using(cborCell, cellPkey));

        if (primitive == null) {
          // TODO:  raise an exception of particular kind
          break;
        }
        primitiveRow.add(primitive);
      }
      primitives.add(primitiveRow);
    }

    return primitives;
  }

  /// Constructs a new primitive from a CBOR value representing a CBOR map.
  ///
  /// The new primitive is initialized.
  Primitive createPrimitiveFromCborMap(CborValue v, int fieldPKeyIndex) {
    var cborMap = v as CborMap;

    var ctorArgs = CtorArgs.multi(this, eventHandler);

    var primitive = PrimitiveFactory.createPrimitiveFromCborMap(
        ctorArgs.using(cborMap, PKey.addIndex(pkey, fieldPKeyIndex)));

    // TODO:  raise an exception of particular kind
    assert(primitive != null);

    return primitive!;
  }

  /// Iterate up the tree until a notification point is found and notify listeners at
  /// that point.
  void _notifyListenersAbove() {
    Primitive? parent = this.parent;

    while (parent != null) {
      if (parent.doesNotify(notifyNow: true) != null) {
        return;
      }
      parent = parent.getParent();
    }
  }

  /// Returns true if the primitive is a notification point, meaning it
  /// can be listened to by its associated embodiment for rebuilding the descending widget tree.
  ///
  /// This method is overriden by the primitive.  By default, it returns false.
  bool get isNotificationPoint {
    // By default, primitives are not notification points.
    return false;
  }

  /// Updates a field of the primitive.
  ///
  /// This method is overriden by the primitive.  An override is not necessary if the primitive
  /// does not have any fields.
  void updateFieldFromCbor(FKey fkey, CborValue v) {}

  /// Locates a descendant primitive using the provided locator object.
  ///
  /// Note:  this method modifies the state of the locator.  It is intended to be used
  /// in tree iteration algorithms.
  Primitive locateDescendant(PKeyLocator locator) {
    // By default, primitives donm't have any descendants.
    return this;
  }

  // Implements the Primitive interface.

  @override
  Listenable? doesNotify({bool notifyNow = false}) {
    if (isNotificationPoint) {
      notifier ??= Notifier();

      if (notifyNow) {
        notifier!.notifyListeners();
      }
      return notifier;
    }
    return null;
  }

  @override
  void updateFromCbor(CborMap m) {
    _internalUpdateFromCbor(m);

    if (doesNotify(notifyNow: true) == null) {
      // Delegate notification to a primitive above this
      _notifyListenersAbove();
    }
  }

  @override
  Primitive? getParent() {
    return parent;
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    assert(!locator.located());
    return locateDescendant(locator);
  }

  /// Accessor for embodimentProperties.  This allows it to be computed on demand.
  @override
  Map<String, dynamic>? getEmbodimentProperties() {
    if (_embodimentProperties != null) {
      return _embodimentProperties;
    }

    if (embodiment.trim().isNotEmpty) {
      late String jsonToParse;

      // Complex (full JSON map) or simplified embodiment syntax?
      if (embodiment.startsWith('{')) {
        jsonToParse = embodiment;
      } else {
        jsonToParse = '{"embodiment":"$embodiment"}';
      }

      // TODO:  handle this exception and log an error
      _embodimentProperties = jsonDecode(jsonToParse) as Map<String, dynamic>;
    }

    return _embodimentProperties;
  }
}
