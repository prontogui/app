// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

// Unfortunately, the class ChangeNotifier must be subclassed to call notifyListeners method.  Crazy, huh?
class Notifier extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
