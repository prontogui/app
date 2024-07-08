// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/pkey.dart';
import 'package:cbor/cbor.dart';

enum EventType {
  checkedChanged,
  choiceChanged,
  commandIssued,
  exportComplete,
  importComplete,
  stateChanged,
  selectedChanged,
  textEntered,
  frameDismissed,
  timerFired
}

typedef EventHandler = void Function(
    EventType eventType, PKey pkey, CborMap fieldUpdates);
