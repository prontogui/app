// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'embodiment_property_help.dart';

class SnackbarEmbodimentProperties {
  Duration duration;
  bool showCloseIcon;
  SnackBarBehavior? behavior;

  /// General constructor for testing purposes.  In practice, other constructors
  /// should be called instead.
  @visibleForTesting
  SnackbarEmbodimentProperties(
      {this.duration = const Duration(seconds: 0), this.showCloseIcon = false});

  SnackbarEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap)
      // Note:  The default duration is 4.0 seconds and ranges between 1 to 60 seconds
      : duration = Duration(
            seconds: getIntPropOrDefault(embodimentMap, "duration", 1, 60, 4)),
        showCloseIcon =
            getBoolPropOrDefault(embodimentMap, "showCloseIcon", false),
        behavior = getSnackBarBehavior(embodimentMap, "behavior");
}
