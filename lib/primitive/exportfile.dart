// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/cbor_conversion.dart';
import 'package:cbor/cbor.dart';
import 'primitive_base.dart';
import 'fkey.dart';
import 'events.dart';

abstract class ExportFile {
  /// Storage for the Data field.
  ///
  /// The blob of data representing the binary contents of the file.
  late List<int> data;

  /// Storage for the Exported field.
  ///
  /// True when the file has been exported (stored to a file) by the app.
  /// This field is updated by the app.
  late bool exported;

  /// Storage for the Name field.
  ///
  /// The suggested file name (including its extension separated by a period) to save the file as.
  late String name;

  /// Notify that the export is completed.
  ///
  /// Embodiments call this method whenever the export is completed.
  void exportComplete();
}

/// The ExportFile primitive.
///
/// A file represents a blob of data that can be exported from the server side
/// and stored to a file on the app side.
class ExportFileImpl extends PrimitiveBase implements ExportFile {
  /// Creates an ExportFile primitive.
  ///
  /// A file represents a blob of data that can be exported from the server side
  /// and stored to a file on the app side.
  ExportFileImpl(super.ctorArgs);

  /// Storage for the data field.
  @override
  List<int> data = [];

  /// Storage for the exported field.
  @override
  bool exported = false;

  /// Storage for the name field.
  @override
  String name = "";

  /// Notify that the export is completed.
  ///
  /// Embodiments call this method whenever the export is completed.
  @override
  void exportComplete() {
    exported = true;

    var fieldUpdates = CborMap({
      CborString("Exported"): const CborBool(true),
    });

    eventHandler.call(EventType.exportComplete, pkey, fieldUpdates);
  }

  /// Implements the unmarshalling and storage of fields.
  @override
  void updateFieldFromCbor(FKey fkey, CborValue v) {
    switch (fkey) {
      case FKey.data:
        data = cborToBlob(v);
      case FKey.exported:
        exported = cborToBool(v);
      case FKey.name:
        name = cborToString(v);
      default:
        assert(false);
    }
  }
}
