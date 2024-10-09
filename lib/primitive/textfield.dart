// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/cbor_conversion.dart';
import 'package:cbor/cbor.dart';
import 'primitive_base.dart';
import 'fkey.dart';
import 'events.dart';

/// The TextField primitive.
///
/// A text field primitive for entering text on the screen.
abstract class TextField {
  /// TextEntry field.
  ///
  /// The text content that was entered.
  String get textEntry;

  /// Notify that a new text entry was entered.
  ///
  /// Embodiments call this method whenever new text is entered.
  void enterText(String newTextEntry);
}

/// The TextField primitive.
///
/// A text field primitive for entering text on the screen.
class TextFieldImpl extends PrimitiveBase implements TextField {
  /// Creates a TextField primitive.
  ///
  /// A text field primitive for entering text on the screen.
  TextFieldImpl(super.ctorArgs);

  /// Storage for the TextEntry field.
  ///
  /// The text content that is entered.
  @override
  String textEntry = "";

  /// Implements the unmarshalling and storage of fields.
  @override
  void updateFieldFromCbor(FKey fkey, CborValue v) {
    switch (fkey) {
      case FKey.textEntry:
        textEntry = cborToString(v);
      default:
        assert(false);
    }
  }

  @override
  void enterText(String newTextEntry) {
    var fieldUpdates = CborMap({
      CborString('TextEntry'): CborString(newTextEntry),
      // An empty update will suffice
    });

    textEntry = newTextEntry;

    eventHandler.call(EventType.textEntered, pkey, fieldUpdates);
  }
}
