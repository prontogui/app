// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/cbor_conversion.dart';
import 'package:cbor/cbor.dart';
import 'primitive_base.dart';
import 'fkey.dart';
import 'events.dart';

abstract class ImportFile {
  /// Storage for the Data field.
  ///
  /// The blob of data representing the binary contents of the file.
  late List<int> data;

  /// Storage for the Exported field.
  ///
  /// True when the file has been imported (loaded from a file) by the app.
  /// This field is updated by the app.
  late bool imported;

  /// Storage for the Name field.
  ///
  /// The suggested file name (including its extension separated by a period) to save the file as.
  late String name;

  /// Storage for the ValidExtensions field.
  ///
  /// The valid extensions for importing (non-case sensitive and period separator is omitted).
  late List<String> validExtensions;

  /// Notify that the export is completed.
  ///
  /// Embodiments call this method whenever the export is completed.
  void importComplete(String fileName, List<int> importedData);
}

/// The ExportFile primitive.
///
/// A file represents a blob of data that can be exported from the server side
/// and stored to a file on the app side.
class ImportFileImpl extends PrimitiveBase implements ImportFile {
  /// Creates an ExportFile primitive.
  ///
  /// A file represents a blob of data that can be exported from the server side
  /// and stored to a file on the app side.
  ImportFileImpl(super.ctorArgs);

  /// Storage for the data field.
  @override
  List<int> data = [];

  /// Storage for the exported field.
  @override
  bool imported = false;

  /// Storage for the name field.
  @override
  String name = "";

  /// Storage for the validExtensions field.
  @override
  List<String> validExtensions = [];

  /// Notify that the export is completed.
  ///
  /// Embodiments call this method whenever the export is completed.
  @override
  void importComplete(String fileName, List<int> importedData) {
    imported = true;

    var fieldUpdates = CborMap({
      CborString('Name'): CborString(fileName),
      CborString('Data'): CborBytes(importedData),
      CborString('Imported'): const CborBool(true),
    });

    eventHandler.call(EventType.importComplete, pkey, fieldUpdates);
  }

  /// Implements the unmarshalling and storage of fields.
  @override
  void updateFieldFromCbor(FKey fkey, CborValue v) {
    switch (fkey) {
      case FKey.data:
        data = cborToBlob(v);
      case FKey.imported:
        imported = cborToBool(v);
      case FKey.name:
        name = cborToString(v);
      case FKey.validExtensions:
        validExtensions = cborToStringList(v);
      default:
        assert(false);
    }
  }
}
