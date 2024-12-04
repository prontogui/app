// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'common_properties.dart';
import 'embodiment_property_help.dart';

class ListEmbodimentProperties with CommonProperties {
  String embodiment;

  static final Set<String> _validEmbodiments = {
    'card-list',
    'normal-list',
    'property-list'
  };

  ListEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap)
      : embodiment = getEnumStringProp(
            embodimentMap, 'embodiment', 'normal-list', _validEmbodiments) {
    super.initializeFromMap(embodimentMap);
  }
}
