// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../embodifier.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'embodiment_property_help.dart';

class SnackBarEmbodiment extends StatefulWidget {
  const SnackBarEmbodiment(
      {super.key, required this.frame, required this.props});
  final pg.Frame frame;
  final SnackBarEmbodimentProperties props;

  @override
  State<SnackBarEmbodiment> createState() => _SnackBarEmbodimentState();
}

class _SnackBarEmbodimentState extends State<SnackBarEmbodiment> {
  bool? _prevShowing;
  ScaffoldFeatureController? _ctrl;
  late Embodifier _embodifier;

  SnackBarAction? buildSnackBarAction() {
    var frameItems = widget.frame.frameItems;

    // If there is no second item, there is no action.
    if (frameItems.length < 2) {
      return null;
    }

    // Second item must be a Command primitive
    if (frameItems[1] is! pg.Command) {
      return null;
    }

    var commandPrimitive = frameItems[1] as pg.Command;

    return SnackBarAction(
      // Employ embodiment properties here, eventually...
      label: commandPrimitive.label,
      onPressed: () {
        // Execute the command
        commandPrimitive.issueNow();
      },
    );
  }

  SnackBar buildSnackBar() {
    var frameItems = widget.frame.frameItems;

    // Must be at least one item in the frame.
    if (frameItems.isEmpty) {
      return const SnackBar(
          content: Text('Internal error: no content in SnackBar.'));
    }

    // First item must be a Text primitive
    if (frameItems[0] is! pg.Text) {
      return const SnackBar(
          content:
              Text('Internal error: first item in SnackBar must be Text.'));
    }

    var textPrimitive = frameItems[0];

    // If there is a second item, it must be a Command primitive
    if (frameItems.length > 1 && frameItems[1] is! pg.Command) {
      return const SnackBar(
          content: Text(
              'Internal error: second item in SnackBar can only be a Command.'));
    }

    var textEmbodiment =
        _embodifier.buildPrimitive(context, textPrimitive, "SnackBarAction");

    //var textP = textPrimitive as pg.Text;
    //print("Building snackbar:  ${textP.content}");

    // This is a placeholder for the actual SnackBar content.
    return SnackBar(
      content: textEmbodiment,
      action: buildSnackBarAction(),
      duration: widget.props.duration,
      behavior: widget.props.behavior,
      showCloseIcon: widget.props.showCloseIcon,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Stash away the embodifier
    _embodifier = InheritedEmbodifier.of(context);
  }

  @override
  Widget build(BuildContext context) {
    // Time to show the SnackBar?
    if (_prevShowing == null || widget.frame.showing != _prevShowing) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        handleShowOrHideSnackBar();
      });
    }

    // This doesn't actually build anything and is a "hidden" widget for that matter.
    return const SizedBox();
  }

  void handleShowOrHideSnackBar() {
    setState(() {
      _prevShowing = widget.frame.showing;
    });
    if (widget.frame.showing) {
      // Show the SnackBar
      _ctrl = ScaffoldMessenger.of(context).showSnackBar(buildSnackBar());

      // Get notified when the SnackBar is dismissed
      _ctrl!.closed.then((reason) {
        if (mounted) {
          setState(() {
            _ctrl = null;
            widget.frame.showing = false;
          });
        }
      });
    } else {
      // Hide the SnackBar
      if (_ctrl != null) {
        _ctrl!.close();
        _ctrl = null;
      }
    }
  }
}

class SnackBarEmbodimentProperties {
  Duration duration;
  bool showCloseIcon;
  SnackBarBehavior? behavior;

  /// General constructor for testing purposes.  In practice, other constructors
  /// should be called instead.
  @visibleForTesting
  SnackBarEmbodimentProperties(
      {this.duration = const Duration(seconds: 0), this.showCloseIcon = false});

  SnackBarEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap)
      // Note:  The default duration is 4.0 seconds and ranges between 1 to 60 seconds
      : duration = Duration(
            seconds: getIntPropOrDefault(embodimentMap, "duration", 1, 60, 4)),
        showCloseIcon =
            getBoolPropOrDefault(embodimentMap, "showCloseIcon", false),
        behavior = getSnackBarBehavior(embodimentMap, "behavior");
}
