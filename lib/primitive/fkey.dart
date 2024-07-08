// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

const invalidFKey = '';

enum FKey {
  // ALL PRIMITIVE FKEYS START HERE
  checked,
  choice,
  choices,
  content,
  data,
  embodiment,
  exported,
  frameItems,
  groupItems,
  headings,
  imported,
  label,
  listItems,
  name,
  periodMs,
  rows,
  selected,
  showing,
  state,
  status,
  templateItem,
  templateRow,
  textEntry,
  validExtensions,

  // RESERVED ENUM - DO NOT USE FOR PRIMITIVE FIELD
  invalidFieldName,
}

final fkeyToFieldnameMap = {
  FKey.invalidFieldName: '',
  FKey.checked: 'Checked',
  FKey.choice: 'Choice',
  FKey.choices: 'Choices',
  FKey.content: 'Content',
  FKey.data: 'Data',
  FKey.embodiment: 'Embodiment',
  FKey.exported: 'Exported',
  FKey.frameItems: 'FrameItems',
  FKey.groupItems: 'GroupItems',
  FKey.headings: 'Headings',
  FKey.imported: 'Imported',
  FKey.label: 'Label',
  FKey.listItems: 'ListItems',
  FKey.name: 'Name',
  FKey.periodMs: 'PeriodMs',
  FKey.rows: 'Rows',
  FKey.selected: 'Selected',
  FKey.showing: 'Showing',
  FKey.state: 'State',
  FKey.status: 'Status',
  FKey.templateItem: 'TemplateItem',
  FKey.templateRow: 'TemplateRow',
  FKey.textEntry: 'TextEntry',
  FKey.validExtensions: 'ValidExtensions'
};

final List<String> _fkeyToFieldname = _lazyLoading1();
final Map<String, FKey> _fieldnameToFKey = _lazyLoading2();

List<String> _lazyLoading1() {
  var numFKeys = fkeyToFieldnameMap.length;
  var fkeyToFieldname = List<String>.filled(numFKeys, '', growable: false);

  fkeyToFieldnameMap.forEach((key, value) {
    fkeyToFieldname[key.index] = value;
  });

  return fkeyToFieldname;
}

Map<String, FKey> _lazyLoading2() {
  Map<String, FKey> fieldnameToFKey = {};

  fkeyToFieldnameMap.forEach((key, value) {
    fieldnameToFKey[value] = key;
  });

  return fieldnameToFKey;
}

FKey fkeyFor(String fieldname) {
  var found = _fieldnameToFKey[fieldname];
  if (found != null) {
    return found;
  }
  return FKey.invalidFieldName;
}

String fieldnameFor(FKey fkey) {
  return _fkeyToFieldname[fkey.index];
}
