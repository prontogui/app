import 'dart:async';

import 'package:dartlib/dartlib.dart';

typedef UIEventHandler = void Function();

/// A model synchronizer that sends UI events to the server when certain fields are set.
class UIEventSynchro extends UpdateSynchro {
  UIEventSynchro({required PrimitiveLocator locator, required this.comm})
      : super(locator, _eventFKeys(), false, true);

  static Set<FKey> _eventFKeys() => const {
        fkeyChecked,
        fkeyChoice,
        fkeyCommandIssued,
        fkeyExported,
        fkeyImported,
        fkeyIssued,
        fkeySelected,
        fkeyShowing,
        fkeyState,
        fkeyTextEntry,
        fkeyTimerFired
      };

  /// Optional CommClient to send updates to the server.
  CommClient comm;

  Completer? _pendingWait;
  @override
  void onFullModelUpdate() {
    clearPendingUpdates();
  }

  @override
  void onBeginPartialModelUpdate() {}

  @override
  void onPartialModelUpdate() {
    clearPendingUpdates();
  }

  @override
  void onTopLevelPrimitiveUpdate() {
    clearPendingUpdates();
  }

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural) {
    super.onSetField(pkey, fkey, structural);

    if (!_eventFKeys().contains(fkey)) {
      return;
    }

    comm.streamUpdateToServer(getPartialUpdate());

    clearPendingUpdates();

    if (_pendingWait != null) {
      _pendingWait!.complete();
      _pendingWait = null;
    }
  }

  Future<void> wait() async {
    _pendingWait = Completer();
    return _pendingWait!.future;
  }
}
