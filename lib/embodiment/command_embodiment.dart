// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import '../embodiment_properties/command_embodiment_properties.dart';

class CommandEmbodiment extends StatelessWidget {
  CommandEmbodiment(
      {super.key,
      required this.command,
      required Map<String, dynamic>? embodimentMap})
      : embodimentProps = CommandEmbodimentProperties.fromMap(embodimentMap);

  final pg.Command command;
  final CommandEmbodimentProperties embodimentProps;

  Widget _buildAsElevatedButton(BuildContext context) {
    Function()? action;

    if (command.status == 0) {
      action = () {
        command.issueNow();
      };
    }

    return ElevatedButton(
      onPressed: action,
      child: Text(command.label),
    );
  }

  Widget _buildAsOutlinedButton(BuildContext context) {
    Function()? action;

    if (command.status == 0) {
      action = () {
        command.issueNow();
      };
    }

    return OutlinedButton(
      onPressed: action,
      child: Text(command.label),
    );
  }

  Widget _buildAsHidden(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    // Is the command hidden?
    if (command.status == 2) {
      return _buildAsHidden(context);
    }

    switch (embodimentProps.embodiment) {
      case "outlined-button":
        return _buildAsOutlinedButton(context);
      case "elevated-button":
        return _buildAsElevatedButton(context);
      default:
        // TODO:  invalid embodiment setting - log an error and maybe throw an exception
        return _buildAsHidden(context);
    }
  }
}
