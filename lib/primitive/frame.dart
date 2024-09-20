// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'primitive.dart';
import 'primitive_base.dart';
import 'pkey.dart';
import 'fkey.dart';
import 'cbor_conversion.dart';
import 'events.dart';
import '../embodiment_properties/frame_embodiment_properties.dart';

/// The Frame primitive.
///
/// A frame represents a complete user interface to show on the screen.  It could be
/// the main user interface or a sub-screen in the app.  It includes the ability
/// to layout controls in a specific manner.
abstract class Frame {
  /// Accessor for the GroupItems field.
  ///
  /// The frame items are individual primitives that are displayed accordiing to the embodiment.
  List<Primitive> get frameItems;

  /// Whether or not this frame is showing in the GUI.
  bool get showing;

  /// Returns whether or not this frame is a view.
  bool get isView;

  /// Storage for the Tag field.
  ///
  /// Tag is an optional arbitrary string that is assigned by the developer of the server
  /// for identification purposes.  It is not used by this application.
  late String tag;

  /// Returns the embodiment properties.
  FrameEmbodimentProperties get embodimentProperties;

  /// Update the showing field to false and notify listeners with an update.
  ///
  /// This is called by other object(s) in response to the user dismissing a frame
  /// embodied as a dialog.  This usually happen when the user clicks away from the dialog.
  void updateWasDismissed();
}

class FrameImpl extends PrimitiveBase implements Frame {
  /// Creates a Frame primitive.
  ///
  /// A frame represents a complete user interface to show on the screen.  It could be
  /// the main user interface or a sub-screen in the app.  It includes the ability
  /// to layout controls in a specific manner.
  FrameImpl(super.ctorArgs);

  /// Storage for the GroupItems field.
  @override
  List<Primitive> frameItems = [];

  /// Storage for the showing field.
  @override
  bool showing = false;

  /// Storage for the Tag field.
  @override
  String tag = "";

  /// Returns whether or not this frame is a view.
  @override
  bool get isView {
    var ep = embodimentProperties;
    return ep.embodiment == 'full-view' || ep.embodiment == 'dialog-view';
  }

  // Overrides for PrimitiveBase class.
  @override
  bool get isNotificationPoint {
    return true;
  }

  @override
  FrameEmbodimentProperties get embodimentProperties {
    return FrameEmbodimentProperties.fromMap(getEmbodimentProperties());
  }

  /// Implements the unmarshalling and storage of fields.
  @override
  void updateFieldFromCbor(FKey fkey, CborValue v) {
    // Note:  fields should be handled in alphabetical order with containerIndex
    // increasing monotonically in the switch structure below.
    switch (fkey) {
      case FKey.frameItems:
        frameItems = createPrimitivesFromCborList1D(v, 0);
      case FKey.tag:
        tag = cborToString(v);
      case FKey.showing:
        showing = cborToBool(v);
      default:
        assert(false);
    }
  }

  /// Implements the locating of descendant primitives, since this is a container.
  @override
  Primitive locateDescendant(PKeyLocator locator) {
    // The first index is always 0 since there is only one field that contains primitives.
    assert(locator.nextIndex() == 0);
    var index = locator.nextIndex();
    assert(index < frameItems.length);
    return frameItems[index];
  }
/*
  @override
  Listenable get updateNotifier {
    return doesNotify()!;
  }
*/

  // TODO - add a unit test for this.
  @override
  void updateWasDismissed() {
    showing = false;

    var fieldUpdates = CborMap({
      CborString("Showing"): const CborBool(false),
    });

    eventHandler.call(EventType.frameDismissed, pkey, fieldUpdates);
  }
}
