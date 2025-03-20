// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../embodifier.dart';
import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'embodiment_args.dart';
import 'properties.dart';

class SnackBarEmbodiment extends StatefulWidget {
  SnackBarEmbodiment.fromArgs(this.args, {super.key})
      : frame = args.primitive as pg.Frame,
        props = args.properties as FrameSnackbarProperties;

  final EmbodimentArgs args;
  final pg.Frame frame;
  final FrameSnackbarProperties props;

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

    var textEmbodiment = _embodifier.buildPrimitive(context, textPrimitive);

    Duration duration = widget.props.snackbarDuration != null
        ? Duration(
            milliseconds: (widget.props.snackbarDuration! * 1000).toInt())
        : const Duration(seconds: 3);

    late SnackBarBehavior behavior;
    switch (widget.props.snackbarBehavior) {
      case SnackbarBehavior.fixed:
        behavior = SnackBarBehavior.fixed;
      case SnackbarBehavior.floating:
        behavior = SnackBarBehavior.floating;
    }

    // This is a placeholder for the actual SnackBar content.
    return SnackBar(
      content: textEmbodiment,
      action: buildSnackBarAction(),
      duration: duration,
      behavior: behavior,
      showCloseIcon: widget.props.snackbarShowCloseIcon,
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
