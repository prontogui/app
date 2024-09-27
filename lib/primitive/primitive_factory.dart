// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'check.dart';
import 'choice.dart';
import 'command.dart';
import 'ctor_args.dart';
import 'exportfile.dart';
import 'frame.dart';
import 'group.dart';
import 'importfile.dart';
import 'list.dart';
import 'primitive.dart';
import 'table.dart';
import 'text.dart';
import 'textfield.dart';
import 'timer.dart';
import 'tristate.dart';

// "Distinct Primitive Fields" that identifiy what kind of primitive is kept in a CBOR map
//  final CborString _dpfFrame = CborString("FrameItems");
final CborString _dpfCheck = CborString("Checked");
final CborString _dpfChoice = CborString("Choice");
final CborString _dpfCommand = CborString("CommandIssued");
final CborString _dpfExportFile = CborString("Exported");
final CborString _dpfFrameField = CborString("FrameItems");
final CborString _dpfGroup = CborString("GroupItems");
final CborString _dpfImportFile = CborString("Imported");
final CborString _dpfList = CborString("ListItems");
final CborString _dpfTable = CborString("Rows");
final CborString _dpfText = CborString("Content");
final CborString _dpfTextField = CborString("TextEntry");
final CborString _dpfTristate = CborString("State");
final CborString _dpfTimer = CborString("PeriodMs");

/// The static object factory responsible for creating primitive-type objects.
abstract class PrimitiveFactory {
  /// Creates the appropriate primitive from the CBOR specification provide in [ctorArgs].
  static Primitive? createPrimitiveFromCborMap(CtorArgs ctorArgs) {
    // Determine what primitive to create from the unique set of fields it holds.
    if (ctorArgs.cbor.containsKey(_dpfCommand)) {
      return CommandImpl(ctorArgs);
    } else if (ctorArgs.cbor.containsKey(_dpfChoice)) {
      return ChoiceImpl(ctorArgs);
    } else if (ctorArgs.cbor.containsKey(_dpfCheck)) {
      return CheckImpl(ctorArgs);
    } else if (ctorArgs.cbor.containsKey(_dpfExportFile)) {
      return ExportFileImpl(ctorArgs);
    } else if (ctorArgs.cbor.containsKey(_dpfFrameField)) {
      return FrameImpl(ctorArgs);
    } else if (ctorArgs.cbor.containsKey(_dpfGroup)) {
      return GroupImpl(ctorArgs);
    } else if (ctorArgs.cbor.containsKey(_dpfImportFile)) {
      return ImportFileImpl(ctorArgs);
    } else if (ctorArgs.cbor.containsKey(_dpfList)) {
      return ListImpl(ctorArgs);
    } else if (ctorArgs.cbor.containsKey(_dpfTable)) {
      return TableImpl(ctorArgs);
    } else if (ctorArgs.cbor.containsKey(_dpfText)) {
      return TextImpl(ctorArgs);
    } else if (ctorArgs.cbor.containsKey(_dpfTextField)) {
      return TextFieldImpl(ctorArgs);
    } else if (ctorArgs.cbor.containsKey(_dpfTimer)) {
      return TimerImpl(ctorArgs);
    } else if (ctorArgs.cbor.containsKey(_dpfTristate)) {
      return TristateImpl(ctorArgs);
    }

    return null;
  }
}
