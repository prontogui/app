// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'embodiment_property_help.dart';

class CommandEmbodimentProperties {
  String embodiment;

  static final Set<String> _validEmbodiments = {
    'outlined-button',
    'elevated-button'
  };

  CommandEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap)
      : embodiment = getEnumStringProp(
            embodimentMap, 'embodiment', 'elevated-button', _validEmbodiments);
}
