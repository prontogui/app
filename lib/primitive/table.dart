// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'primitive.dart';
import 'primitive_base.dart';
import 'pkey.dart';
import 'fkey.dart';
import 'cbor_conversion.dart';

/// The Table primitive.
///
/// A table displays an array of primitives in a grid of rows and columns.
abstract class TableP {
  /// Accessor for the Headings field.
  ///
  /// The headings to use for each column in the table.
  List<String> get headings;

  /// Accessor for the Rows field.
  ///
  /// The dynamically populated 2D (rows, cols) collection of primitives that appear in the table.
  List<List<Primitive>> get rows;

  /// Storage for the Status field.
  ///
  /// Status represents whether the table is enabled (status = 0), disabled (status = 1),
  /// or hidden (status = 2).
  int get status;

  /// Accessor for the TemplateRow field.
  ///
  /// The template for how each row should look, feel, and behave.
  List<Primitive> get templateRow;
}

class TableImpl extends PrimitiveBase implements TableP {
  /// Creates a Table primitive.
  ///
  /// A table displays an array of primitives in a grid of rows and columns.
  TableImpl(super.ctorArgs);

  /// Storage for the Headings field.
  @override
  List<String> headings = [];

  /// Storage for the Rows field.
  @override
  List<List<Primitive>> rows = [];

  /// Storage for the Status field.
  @override
  int status = 0;

  /// Storage for the TemplateRow field.
  @override
  List<Primitive> templateRow = [];

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
      case FKey.headings:
        headings = cborToStringList(v);
      case FKey.rows:
        rows = createPrimitivesFromCborList2D(v, 0);
      case FKey.status:
        status = cborToInt(v);
      case FKey.templateRow:
        templateRow = createPrimitivesFromCborList1D(v, 1);
      default:
        assert(false);
    }
  }

  /// Implements the locating of descendant primitives, since this is a container.
  @override
  Primitive locateDescendant(PKeyLocator locator) {
    // First index refers to the primitive field that contains primitive(s)
    var fieldIndex = locator.nextIndex();

    if (fieldIndex == 0) {
      var rowIndex = locator.nextIndex();
      assert(rowIndex < rows.length);

      var colIndex = locator.nextIndex();
      assert(colIndex < rows.length);

      return rows[rowIndex][colIndex];
    }
    assert(fieldIndex == 1);
    var templateIndex = locator.nextIndex();
    assert(templateIndex < templateRow.length);

    return templateRow[templateIndex];
  }
}
