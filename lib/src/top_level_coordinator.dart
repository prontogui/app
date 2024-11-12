// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'package:app/src/embodiment/embodifier.dart';
import 'inherited_primitive_model.dart';
import './embodiment_properties/frame_embodiment_properties.dart';
import 'log.dart';

/// The top-level coordinator is responsible for tracking the top-level primitives,
/// sorting them into background primitives, full-view frames, and diaglog-view
/// frames, and interacting with the Navigator to show these in the right manner.
/// It doesn't build any widgets directly and simply inserts the background view
/// into the widget tree as a child.
///
/// Definitions:
/// * A background primitive is any primitive that is not Frame embodied as a view.
/// * A full-view frame is a Frame primitive embodied as 'full-view', or a view that
/// consumes the screen.
/// * A dialog-view frame is a Frame primitive embodied as 'dialog-view' and is used
/// to display a model window containing the frame's content.
class TopLevelCoordinator extends StatefulWidget {
  const TopLevelCoordinator({super.key, required this.backgroundView});

  /// The background view that displays background primitives.  The background view
  /// serves as a catch-all for any top-level primitive that is not a view frame.
  final Widget backgroundView;

  @override
  State<TopLevelCoordinator> createState() => _TopLevelCoordinatorState();
}

/// Information tagged with every view we push onto the Navigator
class RouteArgs {
  const RouteArgs(
      {required this.index, required this.isFullView, required this.frame});

  /// The index into model's topPrimitives property.
  final int index;

  /// Is it s full-view (as opposed to a dialog view).
  final bool isFullView;

  /// The Frame primitive associated with this route.
  final pg.Frame frame;
}

/// A State object that listens to model notifications and interacts with the Navigator.
class _TopLevelCoordinatorState extends State<TopLevelCoordinator>
    implements pg.PrimitiveModelWatcher {
  /// Has the widget been built at least once yet?
  bool firstBuild = true;

  /// The model that has top-level primitives we're interested in
  late pg.PrimitiveModel model;

  /// The object responsible for creating embodiments for primitives
  late Embodifier embodifier;

  /// The index into model.topPrimitives of the full-view frame being shown right now.
  int fullViewShowingNow = -1;

  /// The sequence of dialog views being shown right now.  The list represents indices
  /// into model.topPrimitives property.  Note:  the user can dismiss a dialog by
  /// clicking out if its bounds so this may not represent what's actually visible.  It
  /// used mainly to know "what did we intend to show" and how is that different than
  /// "what we intend to show now".
  List<int> dialogsShowingNow = List<int>.empty();

  /// Have we started listening to model notifications yet?
  bool listeningToModel = false;

  @override
  void onSetField(pg.PKey pkey, pg.FKey fkeu, bool structural) {
    // Not handled
  }

  @override
  void onIngestField(pg.PKey pkey, pg.FKey fkeu, bool structural) {
    // Not handled
  }

  /// Called in response to structural updates (full updates) are made to the model, especially
  /// the top-level primitive list.
  @override
  void onFullModelUpdate() {
    logger.t('Entered onFullModelUpdate');

    // Pop all routes
    Navigator.of(context).popUntil((route) {
      if (route.settings.name == '/') {
        return true;
      } else {
        return false;
      }
    });

    // Analyze Showings
    var sa = _analyzeShowings(model.topPrimitives);

    logger.i('now showing: ${sa.showing}, dlglist: ${sa.dlglist}');

    // Show the right stuff
    if (sa.showing >= 0) {
      Navigator.of(context).push(_buildViewRoute(sa.showing));
    }

    // Remember this
    fullViewShowingNow = sa.showing;

    // Show additional dialogs in respective order
    for (int i = 0; i < sa.dlglist.length; i++) {
      _showFrameDialog(sa.dlglist[i]);
    }

    // Remember this
    dialogsShowingNow = sa.dlglist;
  }

  @override
  void onBeginPartialModelUpdate() {}

  @override
  void onPartialModelUpdate() {}

  /// Called in response to primitive(s) being updated (partial update).
  @override
  void onTopLevelPrimitiveUpdate() {
    logger.t('Entered onTopLevelPrimitiveUpdate');

    // Analyze Showings
    var sa = _analyzeShowings(model.topPrimitives);

    logger.i('now showing: ${sa.showing}, dlglist: ${sa.dlglist}');

    // Do we need to show a different full view (or no full-view) than previously?
    if (sa.showing != fullViewShowingNow) {
      // Pop all the dialog views that are on top
      Navigator.of(context).popUntil((Route route) {
        if (route.settings.name == '/') {
          return true;
        }
        var routeArgs = route.settings.arguments as RouteArgs;
        return routeArgs.isFullView;
      });

      // If there was a full view showing but now there isn't...
      if (fullViewShowingNow >= 0 && sa.showing == -1) {
        // Remove the previous full view
        Navigator.of(context).pop();
        // Or if there wasn't a full view shoing but now there is...
      } else if (fullViewShowingNow == -1 && sa.showing >= 0) {
        // Show the next full view
        Navigator.of(context).push(_buildViewRoute(sa.showing));
        // Or we are just swaping out the full view for another
      } else {
        // Replace the top view
        Navigator.of(context).pushReplacement(_buildViewRoute(sa.showing));
      }

      fullViewShowingNow = sa.showing;
    }

    // Figure out which dialogs need to be popped, and which need to be pushed
    var comparison = _compareDialogSequences(dialogsShowingNow, sa.dlglist);

    // Pop dialogs no longer with Showing = true and that havevn't been popped already (by the user)
    var lastKeeping = comparison.keeping.isEmpty ? -1 : comparison.keeping.last;

    Navigator.of(context).popUntil((Route route) {
      // We're done if we reach the home route
      if (route.settings.name == '/') {
        return true;
      }

      // The route must be one created by this object.  Get the route arguments.
      var routeArgs = route.settings.arguments as RouteArgs;

      // Have we reached a full-view frame?  (Remember:  the user could have dismissed
      // dialogs in the mean time.)  Or, have we reached the last dialog we will keep
      // showing?
      return routeArgs.isFullView || routeArgs.index == lastKeeping;
    });

    // Show additional dialogs in respective order
    for (int i = 0; i < comparison.adding.length; i++) {
      _showFrameDialog(comparison.adding[i]);
    }
  }

  /// Builds a new route for a full-view frame.
  Route _buildViewRoute(int index) {
    var primitive = model.topPrimitives[index];
    var frame = primitive as pg.Frame;

    return MaterialPageRoute(
        settings: RouteSettings(
            arguments: RouteArgs(index: index, frame: frame, isFullView: true)),
        builder: (BuildContext context) =>
            embodifier.buildPrimitive(context, primitive, "<Top>"));
  }

  /// Shows a new dialog-view frame.  Internally, this new view gets pushed onto the Navigator.
  void _showFrameDialog(int index) {
    var primitive = model.topPrimitives[index];
    var frame = primitive as pg.Frame;

    showDialog<void>(
        context: context,
        routeSettings: RouteSettings(
            arguments:
                RouteArgs(index: index, frame: frame, isFullView: false)),
        builder: (BuildContext context) {
          return Dialog(
              child: embodifier.buildPrimitive(context, primitive, "<Top>"));
        }).whenComplete(() {
      // Update the model to reflect that dialog was dismissed by the user
      frame.showing = false;
    });
  }

  /// Compares two dialog showing sequences and returns the sequence they have in common,
  /// that should be kept in tact, and the additional sequence of dialogs to show.
  static ({List<int> keeping, List<int> adding}) _compareDialogSequences(
      List<int> seq1, List<int> seq2) {
    // The dialogs we will keep showing
    var keeping = List<int>.empty(growable: true);

    // Figure out where the sequences diverge
    int i = 0;
    for (; i < seq1.length && i < seq2.length && seq1[i] == seq2[i]; i++) {
      keeping.add(seq1[i]);
    }

    // The dialogs we will be adding
    var adding = List<int>.empty(growable: true);

    // Figure out what dialogs we need to show in addition to what we're keeping
    for (; i < seq2.length; i++) {
      adding.add(seq2[i]);
    }

    return (keeping: keeping, adding: adding);
  }

  /// Analyzes the top level views to figure which one (if any) should be shown as the
  /// full (non-modal) view and what the sequnce of dialog (modal) views should be.
  static ({int showing, List<int> dlglist}) _analyzeShowings(
      List<pg.Primitive> primitives) {
    // Which full-view frame should be shown
    int showing = -1;

    // Which dialog-view frames should be shown
    List<int> dlglist = [];

    // Traverse the top-level primitives, looking for Frames embodied as views.
    for (int i = 0; i < primitives.length; i++) {
      if (primitives[i] is pg.Frame) {
        var frame = primitives[i] as pg.Frame;
        var ep = FrameEmbodimentProperties.fromMap(frame.embodimentProperties);

        switch (ep.embodiment) {
          case "full-view":
            if (frame.showing) {
              // Note, the rule is:  the frame with the highest index takes precedence.
              showing = i;
            }
          case "dialog-view":
            if (frame.showing) {
              // Note:  dialogs are stacked in the order of their indices.  Deeper-level dialogs should be
              // placed further along in the top-leve primitives list.
              dlglist.add(i);
            }
        }
      }
    }

    return (showing: showing, dlglist: dlglist);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    logger.i('handling didChangeDependencies');

    // If we aren't listening to the model yet, then add the listeners now
    if (!listeningToModel) {
      model = InheritedPrimitiveModel.of(context);

      // Get the embodifier
      embodifier = InheritedEmbodifier.of(context);

      logger.i('add self as model watcher');

      // Listen to the model for changes
      model.addWatcher(this);

      listeningToModel = true;
    }
  }

  @override
  void dispose() {
    logger.t('Entered dispose');

    // Stop listening to model changes
    model.removeWatcher(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.t('Entered build');
    // If this is the first time building the widget, then add a post-frame
    // callback to perform work we normally do when the model is updated.  This is
    // necessary in cases where the model is already populated in quiescent state and
    // we're finally getting around to showing something.
    if (firstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        onFullModelUpdate();
      });
      firstBuild = false;
    }

    // Just pass the child through.  This object doesn't actually build widgets
    // at this place in the widget tree.  Instead, it builds, pushes, and pops routes through the
    // Navigator.s
    return widget.backgroundView;
  }
}

/// For testing purposes only.  Acts as a public-visible proxy to an internal method.
@visibleForTesting
({List<int> keeping, List<int> adding}) testproxyCompareDialogSequences(
    List<int> seq1, List<int> seq2) {
  return _TopLevelCoordinatorState._compareDialogSequences(seq1, seq2);
}

/// For testing purposes only.  Acts as a public-visible proxy to an internal method.
@visibleForTesting
({int showing, List<int> dlglist}) testproxyAnalyzeShowings(
    List<pg.Primitive> primitives) {
  return _TopLevelCoordinatorState._analyzeShowings(primitives);
}
