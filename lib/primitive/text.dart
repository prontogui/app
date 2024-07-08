// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/cbor_conversion.dart';
import 'package:cbor/cbor.dart';
import 'primitive_base.dart';
import 'fkey.dart';

/// The Text primitive.
///
/// A text primitive displays text on the screen.
abstract class Text {
  /// Content field.
  ///
  /// The text content to be shown.
  String get content;
}

/// The Text primitive.
///
/// A text primitive displays text on the screen.
class TextImpl extends PrimitiveBase implements Text {
  /// Creates a Text primitive.
  ///
  /// A text primitive displays text on the screen.
  TextImpl(super.ctorArgs);

  /// Storage for the Content field.
  ///
  /// The text content to be shown.
  @override
  String content = "";

  /// Implements the unmarshalling and storage of fields.
  @override
  void updateFieldFromCbor(FKey fkey, CborValue v) {
    switch (fkey) {
      case FKey.content:
        content = cborToString(v);
      default:
        assert(false);
    }
  }
}
