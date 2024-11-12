// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'embodiment_property_help.dart';

mixin class CommonProperties {
  late double width;
  late double height;

  void initializeFromMap(Map<String, dynamic>? embodimentMap) {
    width = getNumericPropOrDefault(embodimentMap, 'width',
        double.negativeInfinity, double.infinity, double.nan);
    height = getNumericPropOrDefault(embodimentMap, 'height',
        double.negativeInfinity, double.infinity, double.nan);
  }
}
