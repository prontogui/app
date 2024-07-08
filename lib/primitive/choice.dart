// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'primitive_base.dart';
import 'fkey.dart';
import 'events.dart';
import 'cbor_conversion.dart';

abstract class Choice {
  /// Accessor for the Choice field.
  ///
  /// The choice is the currently selected item.
  late String choice;

  /// Accessor for the Choices field.
  ///
  /// The available choices to choose from.
  late List<String> choices;

  /// Notify that the choice has been changed.
  ///
  /// Embodiments call this method whenever the choice is changed.
  void updateChoice(String newChoice);

  /// Returns whether or not the choice is valid.
  bool get isChoiceValid;
}

/// The Choice primitive implementation.
///
/// A choice is a user selection from a set of choices.  It is often represented using a pull-down list.
class ChoiceImpl extends PrimitiveBase implements Choice {
  /// Creates a Choice primitive implementation.
  ChoiceImpl(super.ctorArgs);

  /// Returns whether or not the choice is valid.
  @override
  bool get isChoiceValid {
    return choices.contains(choice);
  }

  /// Storage for the choice field.
  @override
  String choice = "";

  /// Storage for the Choices field.
  @override
  List<String> choices = [];

  @override
  void updateChoice(String newChoice) {
    choice = newChoice;
    var fieldUpdates = CborMap({
      CborString("Choice"): CborString(newChoice),
    });

    eventHandler.call(EventType.choiceChanged, pkey, fieldUpdates);
  }

  /// Implements the unmarshalling and storage of fields.
  @override
  void updateFieldFromCbor(FKey fkey, CborValue v) {
    switch (fkey) {
      case FKey.choice:
        choice = cborToString(v);
      case FKey.choices:
        choices = cborToStringList(v);
      default:
        assert(false);
    }
  }
}
