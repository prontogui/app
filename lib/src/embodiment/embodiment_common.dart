// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'properties.dart' as prop;
import '../widgets/widget_common.dart' as wc;

// This file contains code and types that are common across multiple embodiments.
//
// Why? One reaoson is we need to convert from enums defined in properties.dart, which will eventually be auto-generated,
// to enums in other packages or the Flutter framework. Chances are good that most enums in properties.dart are used
// by multiple embodiments.

//
// Enum adapters to get between generated enums in properties.dart to those in other packages.
//

wc.FocusSelection adaptFocusSelection(prop.FocusSelection fs) {
  switch (fs) {
    case prop.FocusSelection.begin:
      return wc.FocusSelection.begin;
    case prop.FocusSelection.end:
      return wc.FocusSelection.end;
    case prop.FocusSelection.all:
      return wc.FocusSelection.all;
  }
}

