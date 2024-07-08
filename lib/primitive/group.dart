// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'primitive.dart';
import 'primitive_base.dart';
import 'pkey.dart';
import 'fkey.dart';

/// The Group primitive.
///
/// A group is a related set of primitives, such as a group of commands.  The child
/// primitives are assumed to be static in type and quantity.  For example, an array
/// of commands.  If its desired to have a dynamic number of primitives or changing
/// primitive types during operation then the List primitive is a better choice.
abstract class Group {
  /// Accessor for the GroupItems field.
  ///
  /// The group items are individual primitives that are displayed accordiing to the embodiment.
  List<Primitive> get groupItems;
}

class GroupImpl extends PrimitiveBase implements Group {
  /// Creates a Group primitive.
  ///
  /// A group is a related set of primitives, such as a group of commands.  The child
  /// primitives are assumed to be static in type and quantity.  For example, an array
  /// of commands.  If its desired to have a dynamic number of primitives or changing
  /// primitive types during operation then the List primitive is a better choice.
  GroupImpl(super.ctorArgs);

  /// Storage for the GroupItems field.
  @override
  List<Primitive> groupItems = [];

  // Overrides for PrimitiveBase class.
  @override
  bool get isNotificationPoint {
    return true;
  }

  /// Implements the unmarshalling and storage of fields.
  @override
  void updateFieldFromCbor(FKey fkey, CborValue v) {
    // Note:  fields should be handled in alphabetical order with containerIndex
    // increasing monotonically in the switch structure below.
    switch (fkey) {
      case FKey.groupItems:
        groupItems = createPrimitivesFromCborList1D(v, 0);
      default:
        assert(false);
    }
  }

  /// Implements the locating of descendant primitives, since this is a container.
  @override
  Primitive locateDescendant(PKeyLocator locator) {
    // The first index is always 0 since there is only one field that contains primitives.
    assert(locator.nextIndex() == 0);
    var index = locator.nextIndex();
    assert(index < groupItems.length);
    return groupItems[index];
  }
}
