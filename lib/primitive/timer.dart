// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/cbor_conversion.dart';
import 'package:cbor/cbor.dart';
import 'primitive_base.dart';
import 'fkey.dart';
import 'events.dart';
import 'dart:async';

abstract class TimerP {
  /// Storage for the PeriodMs field.
  ///
  /// The time period in milliseconds after which the timer fires an event.  If the period is -1 (or any negative number) then the timer is disabled.
  /// A period of 0 will cause the timer to fire immediately after the primitive is updated.
  late int periodMs;

  void timerFired();
}

/// The Timer primitive.
///
/// A timer is an invisible primitive that fires an event, triggering an update to the server.  This is useful for low-precision GUI updates
/// that originate on the server side.  An example is updating "live" readings from a running process on the server.
class TimerImpl extends PrimitiveBase implements TimerP {
  /// Creates a Timer primitive.
  ///
  /// A timer is an invisible primitive that fires an event, triggering an update to the server.  This is useful for low-precision GUI updates
  /// that originate on the server side.  An example is updating "live" readings from a running process on the server.
  TimerImpl(super.ctorArgs);

  Timer? timer;

  /// Storage for the PeriodMs field.
  @override
  int periodMs = 0;

  /// Notify that the timer was fired.
  ///
  /// Embodiments call this method whenever the timer fires.
  @override
  void timerFired() {
    var fieldUpdates = CborMap({
      // An empty update will suffice
    });

    eventHandler.call(EventType.timerFired, pkey, fieldUpdates);
  }

  // Overrides for PrimitiveBase class.
  @override
  bool get isNotificationPoint {
    return true;
  }

  /// Implements the unmarshalling and storage of fields.
  @override
  void updateFieldFromCbor(FKey fkey, CborValue v) {
    switch (fkey) {
      case FKey.periodMs:
        periodMs = cborToInt(v);
      default:
        assert(false);
    }
  }
}
