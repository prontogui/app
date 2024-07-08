// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';

CborMap cborEmpty() {
  return CborMap({});
}

CborMap cborForGroup() {
  var cmd1 = CborMap({
    CborString('Label'): CborString('Press Me!'),
    CborString('Status'): const CborSmallInt(0),
  });

  var cmd2 = CborMap({
    CborString('Label'): CborString('Click Here! (disable)'),
    CborString('Status'): const CborSmallInt(1),
  });

  return CborMap({
    CborString('GroupItems'): CborList([cmd1, cmd2]),
  });
}

CborMap cborForFrame() {
  var cmd1 = CborMap({
    CborString('Label'): CborString('Press Me!'),
    CborString('Status'): const CborSmallInt(0),
  });

  var cmd2 = CborMap({
    CborString('Label'): CborString('Click Here! (disable)'),
    CborString('Status'): const CborSmallInt(1),
  });

  return CborMap({
    CborString('FrameItems'): CborList([cmd1, cmd2]),
  });
}

CborList cborForAny1DField() {
  var cmd1 = CborMap({
    CborString('Label'): CborString('Press Me!'),
    CborString('Status'): const CborSmallInt(0),
  });

  var cmd2 = CborMap({
    CborString('Label'): CborString('Click Here! (disable)'),
    CborString('Status'): const CborSmallInt(1),
  });

  return CborList([cmd1, cmd2]);
}

CborMap cborForList() {
  var cmd3 = CborMap({
    CborString('Label'): CborString('STOP'),
    CborString('Status'): const CborSmallInt(2),
  });

  return CborMap({
    CborString('ListItems'): cborForAny1DField(),
    CborString('Selected'): const CborSmallInt(1),
    CborString('TemplateItem'): cmd3,
  });
}

CborList cborForAny2DField() {
  var cmdR0C0 = CborMap({
    CborString('Label'): CborString('Press Me!'),
    CborString('Status'): const CborSmallInt(0),
  });

  var cmdR0C1 = CborMap({
    CborString('Label'): CborString('Click Here! (disable)'),
    CborString('Status'): const CborSmallInt(1),
  });

  var cmdR1C0 = CborMap({
    CborString('Label'): CborString('STOP'),
    CborString('Status'): const CborSmallInt(2),
  });

  var cmdR1C1 = CborMap({
    CborString('Label'): CborString('START'),
    CborString('Status'): const CborSmallInt(2),
  });

  var row0 = CborList([cmdR0C0, cmdR0C1]);
  var row1 = CborList([cmdR1C0, cmdR1C1]);

  return CborList([row0, row1]);
}

CborMap cborForTable() {
  var cmdTR0 = CborMap({
    CborString('Label'): CborString('BEGIN'),
    CborString('Status'): const CborSmallInt(0),
  });

  var cmdTR1 = CborMap({
    CborString('Label'): CborString('END'),
    CborString('Status'): const CborSmallInt(1),
  });

  return CborMap({
    CborString('Rows'): cborForAny2DField(),
    CborString('TemplateRow'): CborList([cmdTR0, cmdTR1]),
  });
}

CborMap distinctCborForCommand() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Status'): const CborSmallInt(0),
  });
}

CborMap cborForCommandAsOutlined() {
  return CborMap({
    CborString('Status'): const CborSmallInt(0),
    CborString('Embodiment'): CborString('outlined-button'),
  });
}

CborMap distinctCborForGroup() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('GroupItems'): CborList([]),
  });
}

CborMap distinctCborForFrame() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('FrameItems'): CborList([]),
  });
}

CborMap distinctCborForText() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Content'): CborString('Excepteur sint occaecat cupidatat'),
  });
}

CborMap distinctCborForChoice() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Choice'): CborString(''),
  });
}

CborMap distinctCborForCheck() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Checked'): const CborBool(false),
  });
}

CborMap distinctCborForTristate() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('State'): const CborSmallInt(0),
  });
}

CborMap distinctCborForList() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('ListItems'): CborList([]),
  });
}

CborMap distinctCborForTextField() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('TextEntry'): CborString(''),
  });
}

CborMap distinctCborForExportFile() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Exported'): const CborBool(true),
  });
}

CborMap distinctCborForImportFile() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Imported'): const CborBool(true),
  });
}

CborMap distinctCborForTable() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Rows'): CborList([]),
  });
}

CborMap distinctCborForTimer() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('PeriodMs'): const CborSmallInt(200),
  });
}

CborMap cborForEmptyEmbodiment() {
  return CborMap({
    CborString('Embodiment'): CborString(''),
  });
}

CborMap cborForEmptyWhitespaceEmbodiment() {
  return CborMap({
    CborString('Embodiment'): CborString('   '),
  });
}

CborMap cborForSimplifiedEmbodiment() {
  return CborMap({
    CborString('Embodiment'): CborString('down-and-dirty'),
  });
}

CborMap cborForComplexEmbodiment() {
  return CborMap({
    CborString('Embodiment'): CborString('''
{
  "embodiment":"fancy-look-and-feel",
  "layoutMethod":"flow",
  "flowDirection":"LTR"
}
'''),
  });
}
