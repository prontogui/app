// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'embodiment_property_help.dart';

mixin class CommonProperties {
  late double? width;
  late double? height;

  void fromMap(Map<String, dynamic>? embodimentMap) {
    width = getNumericProp(embodimentMap, 'width', 0, double.infinity);
    height = getNumericProp(embodimentMap, 'height', 0, double.infinity);
  }
}
