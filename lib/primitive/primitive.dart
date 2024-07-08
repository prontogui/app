// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'package:flutter/foundation.dart';
import 'pkey.dart';

/// Interface that every primitive supports.
abstract interface class Primitive {
  /// Update the fields partially or in full from a CBOR map.
  void updateFromCbor(CborMap m);

  /// Returns a listenable object if this primitive supports notifications (to embodiments).
  ///
  /// You can optionally specify [notifyNow = true] that anything currently listening
  /// should be notified.
  Listenable? doesNotify({bool notifyNow = false});

  /// Returns the parent of this primitive or null if the primitive is the root.
  Primitive? getParent();

  /// Locates the next descendant primitive with respect to this primitive.  A locator object
  /// [PKeyLocator] is updated during this call.  An assertion is thrown if you call this
  /// method and locator has no more indices to look for (locator.located() == true).
  Primitive locateNextDescendant(PKeyLocator locator);

  /// Returns the embodiment properties.  If there is no embodiment specification then null is returned.
  Map<String, dynamic>? getEmbodimentProperties();
}
