// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'embodiment_property_help.dart';

class FrameEmbodimentProperties {
  String embodiment;
  String layoutMethod;
  String flowDirection;

  static final Set<String> _embodimentChoices = {
    'other',
    'full-view',
    'dialog-view'
  };

  static final Set<String> _layoutMethodChoices = {
    'flow',
  };

  static final Set<String> _flowDirectionChoices = {
    'left-to-right',
    'top-to-bottom'
  };

  bool get isViewFrame {
    return embodiment == 'full-view' || embodiment == 'dialog-view';
  }

  /// General constructor for testing purposes.  In practice, other constructors
  /// should be called instead.
  @visibleForTesting
  FrameEmbodimentProperties(
      {this.embodiment = "", this.layoutMethod = "", this.flowDirection = ""});

  FrameEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap)
      : layoutMethod = getEnumStringProp(
            embodimentMap, 'layoutMethod', 'flow', _layoutMethodChoices),
        flowDirection = getEnumStringProp(embodimentMap, 'flowDirection',
            'top-to-bottom', _flowDirectionChoices),
        embodiment = getEnumStringProp(
            embodimentMap, 'embodiment', 'other', _embodimentChoices);
}
