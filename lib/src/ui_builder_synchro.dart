import 'package:dartlib/dartlib.dart';
import './embodiment/embodifier.dart';

class UIBuilderSynchro extends SynchroBase {
  UIBuilderSynchro(Embodifier embodifier)
      : _embodifier = embodifier,
        super(null);

  final Embodifier _embodifier;

  @override
  void onTopLevelPrimitiveUpdate() {
    // Need to handle??
  }

  @override
  void onBeginPartialModelUpdate() {
    clearPendingUpdates();
  }

  @override
  void onPartialModelUpdate() {
    rebuildUI();
  }

  void rebuildUI() {
    for (var update in pendingUpdates) {
      if (update.coalesced) {
        continue;
      }

      _embodifier.notifyBuilder(update.pkey);
    }
    clearPendingUpdates();
  }
}
