// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'primitive_base.dart';
import 'fkey.dart';
import 'events.dart';
import 'cbor_conversion.dart';

abstract class Tristate {
  /// Accessor for the Label field.
  ///
  /// The label is optional and is shown along with the check box.
  late String label;

  /// Accessor for the State field.
  ///
  /// The (tri)state of the primitive.
  late int state;

  /// Getter for the State field.
  ///
  /// Alternative getter of state represented as nullable boolean.
  bool? get stateAsBool;

  /// Setter for the State field.
  ///
  /// Alternative setter of state using a nullable boolean.  Calling this function also
  /// sets the state field appropriately.
  set stateAsBool(bool? state);

  /// Accessor for the Tag field.
  ///
  /// Tag is an optional arbitrary string that is assigned by the developer of the server
  /// for identification purposes.  It is not used by this application.
  late String tag;

  /// Notify that the state has been changed.
  ///
  /// Embodiments call this method whenever the state is changed.
  void updateState(bool? newState);

  /// Updates the state to the next one (null to true to false to null etc...)
  void nextState();
}

/// The Tristate primitive implementation.
class TristateImpl extends PrimitiveBase implements Tristate {
  /// Creates a Tristate primitive implementation.
  TristateImpl(super.ctorArgs);

  void notifyStateUpdated() {
    var fieldUpdates = CborMap({
      CborString("State"): CborSmallInt(state),
    });

    eventHandler.call(EventType.stateChanged, pkey, fieldUpdates);
  }

  /// Storage for the label field.
  @override
  String label = "";

  /// Storage for the state field.
  @override
  int state = 0;

  /// Storage for the Tag field.
  @override
  String tag = "";

  /// Alternative getter of state represented as nullable boolean.
  @override
  bool? get stateAsBool {
    switch (state) {
      case 0:
        return false;
      case 1:
        return true;
      case 2:
        return null;
      default:
        assert(false);
    }
    return null;
  }

  /// Alternative setter of state using a nullable boolean.  Calling this function also
  /// sets the state field appropriately.
  @override
  set stateAsBool(bool? boolState) {
    if (boolState == null) {
      state = 2;
    } else if (boolState) {
      state = 1;
    } else {
      state = 0;
    }
  }

  @override
  void updateState(bool? newState) {
    stateAsBool = newState;
    notifyStateUpdated();
  }

  @override
  void nextState() {
    switch (state) {
      case 0:
        state = 1;
      case 1:
        state = 2;
      case 2:
        state = 0;
      default:
        state = 0;
    }
    notifyStateUpdated();
  }

  /// Implements the unmarshalling and storage of fields.
  @override
  void updateFieldFromCbor(FKey fkey, CborValue v) {
    switch (fkey) {
      case FKey.label:
        label = cborToString(v);
      case FKey.state:
        state = cborToInt(v);
      case FKey.tag:
        tag = cborToString(v);
      default:
        assert(false);
    }
  }
}
