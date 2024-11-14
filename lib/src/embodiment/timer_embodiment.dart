// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'dart:async';

class TimerEmbodiment extends StatefulWidget {
  const TimerEmbodiment({super.key, required this.timer});

  final pg.Timer timer;

  @override
  State<TimerEmbodiment> createState() => _TimerEmbodimentState();
}

class _TimerEmbodimentState extends State<TimerEmbodiment> {
  Timer? timer;

  void cancelTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }

  void configureTimer() {
    var periodMs = widget.timer.periodMs;

    cancelTimer();

    if (periodMs < 0) {
      // Timer = null
    } else if (periodMs == 0) {
      // Timer = null
      // Fire the timer once only
      widget.timer.fireTimer();
    } else {
      // Fire the timer periodically
      timer = Timer.periodic(Duration(milliseconds: periodMs), (Timer _) {
        widget.timer.fireTimer();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print('Timer initState called.');
    configureTimer();
  }

  @override
  void didUpdateWidget(TimerEmbodiment oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('Timer didUpdateWidget called.');

    configureTimer();
  }

  @override
  void dispose() {
    cancelTimer();
    print('Timer dispose called.');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Timer shows nothing by default.
    return const SizedBox();
  }
}
