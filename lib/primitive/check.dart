// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'primitive_base.dart';
import 'fkey.dart';
import 'events.dart';
import 'cbor_conversion.dart';

abstract class Check {
  /// Accessor for the Checked field.
  ///
  /// The checked status of the primitive.
  late bool checked;

  /// Accessor for the Label field.
  ///
  /// The label is optional and is shown along with the check box.
  late String label;

  /// Update the checked field and notify listeners with an update.
  ///
  /// Embodiments call this method whenever the check is changed.
  void updateChecked(bool newChecked);

  /// Updates the state to the next one (false to true to false etc...)
  void nextState();
}

/// The Check primitive implementation.
class CheckImpl extends PrimitiveBase implements Check {
  /// Creates a Check primitive implementation.
  CheckImpl(super.ctorArgs);

  /// Notify listeners that check was updated.
  void notifyUpdated() {
    var fieldUpdates = CborMap({
      CborString("Checked"): CborBool(checked),
    });

    eventHandler.call(EventType.checkedChanged, pkey, fieldUpdates);
  }

  /// Storage for the checked field.
  @override
  bool checked = false;

  /// Storage for the label field.
  @override
  String label = "";

  @override
  void updateChecked(bool newChecked) {
    checked = newChecked;
    notifyUpdated();
  }

  /// Updates the state to the next one (false to true to false etc...)
  @override
  void nextState() {
    checked = !checked;
    notifyUpdated();
  }

  /// Implements the unmarshalling and storage of fields.
  @override
  void updateFieldFromCbor(FKey fkey, CborValue v) {
    switch (fkey) {
      case FKey.checked:
        checked = cborToBool(v);
      case FKey.label:
        label = cborToString(v);
      default:
        assert(false);
    }
  }
}
