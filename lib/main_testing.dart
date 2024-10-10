// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'package:app/primitive/model.dart';
import 'package:app/primitive/events.dart';
import 'package:app/primitive/pkey.dart';

CborValue buildSampleFullUpdate1() {
  var txt = CborMap({
    CborString("Content"): CborString("Look at my pretty text!"),
  });

  var cmd1 = CborMap({
    CborString("CommandIssued"): const CborBool(false),
    CborString("Label"): CborString("Press Me!"),
    CborString("Status"): const CborSmallInt(0),
  });

  var cmd2 = CborMap({
    CborString("CommandIssued"): const CborBool(false),
    CborString("Label"): CborString("Click Here! (disable)"),
    CborString("Status"): const CborSmallInt(1),
  });

  var choice1 = CborMap({
    CborString("Choice"): CborString("Porsche 911"),
    CborString("Choices"): CborList([
      CborString('Corvette'),
      CborString('Porsche 911'),
      CborString('Maserati'),
      CborString('Lambo'),
    ]),
  });

  var chk1 = CborMap({
    CborString("Label"): CborString("Turn this on/off"),
    CborString("Checked"): const CborBool(true),
  });

  var tri1 = CborMap({
    CborString("Label"): CborString("Vote for trump or biden"),
    CborString("State"): const CborSmallInt(2),
  });

  var group1 = CborMap({
    CborString("GroupItems"): CborList([txt, cmd1, cmd2, choice1, chk1, tri1]),
  });

  return CborList([const CborBool(true), group1]);
}

CborValue buildSampleFullUpdate2() {
  var cmd1 = CborMap({
    CborString("CommandIssued"): const CborBool(false),
    CborString("Label"): CborString("(Enabled)"),
    CborString("Status"): const CborSmallInt(0),
    CborString("B.Embodiment"): CborString("outlined-button")
  });

  var cmd2 = CborMap({
    CborString("CommandIssued"): const CborBool(false),
    CborString("Label"): CborString("(Disable))"),
    CborString("Status"): const CborSmallInt(1),
    CborString("B.Embodiment"): CborString("outlined-button")
  });

  var cmd3 = CborMap({
    CborString("CommandIssued"): const CborBool(false),
    CborString("Label"): CborString("(Hidden)"),
    CborString("Status"): const CborSmallInt(2),
    CborString("B.Embodiment"): CborString("outlined-button")
  });

  var group1 = CborMap({
    CborString("GroupItems"): CborList([cmd1, cmd2, cmd3]),
  });

  return CborList([const CborBool(true), group1]);
}

CborValue text(String text) {
  return CborMap({
    CborString('Content'): CborString(text),
  });
}

CborValue textField(String textEntry) {
  return CborMap({
    CborString('TextEntry'): CborString(textEntry),
  });
}

CborValue row(
    [CborValue col0 = const CborNull(),
    CborValue col1 = const CborNull(),
    CborValue col2 = const CborNull()]) {
  var args = [col0];
  if (col1 is! CborNull) {
    args.add(col1);
  }
  if (col2 is! CborNull) {
    args.add(col2);
  }

  return CborList(args);
}

CborValue buildTableExample() {
  var rows = CborList([
    row(text('0'), textField('A')),
    row(text('1'), textField('B')),
    row(text('2'), textField('C')),
    row(text('3'), textField('D')),
    row(text('4'), textField('E')),
    row(text('5'), textField('F')),
    row(text('6'), textField('G')),
    row(text('7'), textField('H')),
    row(text('8'), textField('I')),
    row(text('10'), textField('J')),
  ]);

  var templateRow = row(text(''), textField(''));

  var table = CborMap({
    CborString('Rows'): CborList(rows),
    CborString('TemplateRow'): templateRow,
  });

  return CborList([const CborBool(true), table]);
}

CborValue buildTextFieldExample() {
  var textField1 = CborMap({
    CborString('TextEntry'): CborString(''),
  });

  var textField2 = CborMap({
    CborString('TextEntry'): CborString(''),
  });

  var chk = CborMap({
    CborString('Checked'): const CborBool(false),
  });

  return CborList([const CborBool(true), textField1, textField2, chk]);
}

CborValue buildToggleUpdate(bool defaultButton) {
  String embodiment = defaultButton ? "" : "outlined-button";

  var cmdUpdate = CborMap({
    CborString("B.Embodiment"): CborString(embodiment),
  });

  var pkey1 = CborList([const CborSmallInt(0), const CborSmallInt(0)]);
  var pkey2 = CborList([const CborSmallInt(0), const CborSmallInt(1)]);

  return CborList([const CborBool(false), pkey1, cmdUpdate, pkey2, cmdUpdate]);
}

/*
var defaultButton = true;
*/

void eventHandler(EventType eventType, PKey pkey, CborMap fieldUpdates) {
  // Turn the event into an update and send back to server side
  //        comm?.sendUpdate(update);
/*
  defaultButton = !defaultButton;

  if (defaultButton) {
    _model.updateFromCbor(buildSampleFullUpdate1());
  } else {
    _model.updateFromCbor(buildSampleFullUpdate2());
  }
*/
}

final _model = PrimitiveModel(eventHandler);

PrimitiveModel initializeTestingModel() {
  _model.updateFromCbor(buildTableExample());
  return _model;
}
