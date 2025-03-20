// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/widgets.dart';
import 'package:dartlib/dartlib.dart';

/// An adapter class to allow the pg.CommClient to notify listeners of state changes.
///
/// Note:  the ProntGUI Dartlib doesn't have direct access to Flutter, that is why
/// we need this adapter class.
class CommClientChangeNotifier extends ChangeNotifier {
  CommClientChangeNotifier();

  CommClientCtl? _comm;

  CommClientCtl get comm {
    if (_comm == null) {
      throw Exception('comm has not been assigned.');
    }
    return _comm!;
  }

  set comm(CommClientCtl value) {
    if (_comm != null) {
      throw Exception('comm can only be assigned once.');
    }
    _comm = value;
  }

  void onStateChange() {
    notifyListeners();
  }
}

/// A widget that is used to rebuild the widget tree if PGComm notifies of state change.
class InheritedCommClient extends InheritedNotifier<CommClientChangeNotifier> {
  const InheritedCommClient({
    super.key,
    super.notifier,
    required super.child,
  });

  static CommClientCtl of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedCommClient>()!
        .notifier!
        .comm;
  }
}
