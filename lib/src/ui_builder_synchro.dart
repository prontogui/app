// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:dartlib/dartlib.dart';
import 'embodifier.dart';

/// A model synchronizer that rebuilds portions of the UI when changes are made to the model.
class UIBuilderSynchro extends SynchroBase {
  UIBuilderSynchro(Embodifier embodifier)
      : _embodifier = embodifier,
        super(null, true, true);

  final Embodifier _embodifier;

  @override
  void onBeginPartialModelUpdate() {
    clearPendingUpdates();
  }

  @override
  void onPartialModelUpdate() {
    _rebuildUI();
  }

  /// Rebuild the UI for all pending updates.  This should be done after a partial
  /// update cycle is complete.  (Note:  the UI gets rebuilt by a different mechanism
  /// upon a full model update.)
  void _rebuildUI() {
    logger.d('Rebuilding UI for ${pendingUpdates.length} updates');

    for (var update in pendingUpdates) {
      if (update.coalesced) {
        continue;
      }

      _embodifier.notifyBuilder(update.pkey);
    }
    clearPendingUpdates();
  }
}
