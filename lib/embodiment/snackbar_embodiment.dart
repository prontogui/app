// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/embodiment/embodifier.dart';
import 'package:app/primitive/frame.dart';
import 'package:app/primitive/text.dart' as pri;
import 'package:app/primitive/command.dart' as pri;
import 'package:flutter/material.dart';
import '../embodiment_properties/snackbar_embodiment_properties.dart';

class SnackBarEmbodiment extends StatefulWidget {
  SnackBarEmbodiment(
      {super.key,
      required this.frame,
      required Map<String, dynamic>? embodimentMap})
      : embodimentProps = SnackbarEmbodimentProperties.fromMap(embodimentMap);
  final Frame frame;
  final SnackbarEmbodimentProperties embodimentProps;

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
    if (frameItems[1] is! pri.Command) {
      return null;
    }

    var commandPrimitive = frameItems[1] as pri.Command;

    return SnackBarAction(
      // Employ embodiment properties here, eventually...
      label: commandPrimitive.label,
      onPressed: () {
        // Execute the command
        commandPrimitive.issueCommand();
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
    if (frameItems[0] is! pri.Text) {
      return const SnackBar(
          content:
              Text('Internal error: first item in SnackBar must be Text.'));
    }

    var textPrimitive = frameItems[0];

    // If there is a second item, it must be a Command primitive
    if (frameItems.length > 1 && frameItems[1] is! pri.Command) {
      return const SnackBar(
          content: Text(
              'Internal error: second item in SnackBar can only be a Command.'));
    }

    var textEmbodiment =
        _embodifier.buildPrimitive(context, textPrimitive, "SnackBarAction");

    // This is a placeholder for the actual SnackBar content.
    return SnackBar(
      content: textEmbodiment,
      action: buildSnackBarAction(),
      duration: widget.embodimentProps.duration,
      behavior: widget.embodimentProps.behavior,
      showCloseIcon: widget.embodimentProps.showCloseIcon,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Stash away the embodifier
    _embodifier = Embodifier.of(context);
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
            widget.frame.updateWasDismissed();
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
