// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/timer.dart' as pri;
import 'package:flutter/material.dart';

class TimerEmbodiment extends StatelessWidget {
  const TimerEmbodiment({super.key, required this.timer});

  final pri.TimerP timer;

  @override
  Widget build(BuildContext context) {
    // Timer shows nothing by default.
    return const SizedBox();
  }
}
