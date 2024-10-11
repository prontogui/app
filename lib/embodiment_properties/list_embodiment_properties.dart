// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'embodiment_property_help.dart';

class ListEmbodimentProperties {
  String embodiment;

  static final Set<String> _validEmbodiments = {'card-list', 'normal-list'};

  ListEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap)
      : embodiment = getEnumStringProp(
            embodimentMap, 'embodiment', 'normal-list', _validEmbodiments);
}
