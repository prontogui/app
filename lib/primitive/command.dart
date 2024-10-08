// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/cbor_conversion.dart';
import 'package:cbor/cbor.dart';
import 'primitive_base.dart';
import 'fkey.dart';
import 'events.dart';

abstract class Command {
  /// Storage for the Label field.
  ///
  /// The label is what is shown in the Command's embodiment.
  late String label;

  /// Storage for the Status field.
  ///
  /// Status represents whether the button is enable (status = 0), disabled (status = 1),
  /// or hidden (status = 2).
  late int status;

  /// Notify that the command has been issued.
  ///
  /// Embodiments call this method whenever the command is issued.
  void issueCommand();
}

/// The Command primitive.
///
/// A command is used to handle momentary requests by the user such that, when
/// the command is issued, the service does something useful.  It is often rendered
/// as a button with clear boundaries that suggest it can be clicked.
class CommandImpl extends PrimitiveBase implements Command {
  /// Creates a Command primitive.
  ///
  /// A command is used to handle momentary requests by the user such that, when
  /// the command is issued, the service does something useful.  It is often rendered
  /// as a button with clear boundaries that suggest it can be clicked.
  CommandImpl(super.ctorArgs);

  /// Storage for the Label field.
  @override
  String label = "";

  /// Storage for the Status field.
  @override
  int status = 0;

  /// Issue the command to all listeners along with an update.
  ///
  /// Embodiments call this method whenever the command is issued.
  @override
  void issueCommand() {
    var fieldUpdates = CborMap({
      CborString(fieldnameFor(FKey.commandIssued)): const CborBool(false),
    });

    eventHandler.call(EventType.commandIssued, pkey, fieldUpdates);
  }

  /// Implements the unmarshalling and storage of fields.
  @override
  void updateFieldFromCbor(FKey fkey, CborValue v) {
    switch (fkey) {
      case FKey.commandIssued:
        // do nothing - it's an event field
        break;
      case FKey.label:
        label = cborToString(v);
      case FKey.status:
        status = cborToInt(v);
      case FKey.invalidFieldName:
        assert(false, 'invalid field name');
      default:
        assert(false, 'primitive does not support field $fkey');
    }
  }
}
