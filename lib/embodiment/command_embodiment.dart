// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/command.dart';
import 'package:flutter/material.dart';
import '../embodiment_properties/command_embodiment_properties.dart';

class CommandEmbodiment extends StatelessWidget {
  CommandEmbodiment(
      {super.key,
      required this.command,
      required Map<String, dynamic>? embodimentMap})
      : embodimentProps = CommandEmbodimentProperties.fromMap(embodimentMap);

  final Command command;
  final CommandEmbodimentProperties embodimentProps;

  Widget _buildAsEnabledElevatedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        command.issueCommand();
      },
      child: Text(command.label),
    );
  }

  Widget _buildAsEnabledOutlinedButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        command.issueCommand();
      },
      child: Text(command.label),
    );
  }

  Widget _buildAsEnabled(BuildContext context) {
    switch (embodimentProps.embodiment) {
      case "outlined-button":
        return _buildAsEnabledOutlinedButton(context);
      case "elevated-button":
        return _buildAsEnabledElevatedButton(context);
      default:
        // TODO:  invalid embodiment setting - log an error and maybe throw an exception
        return _buildAsHidden(context);
    }
  }

  Widget _buildAsDisabled(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: null,
      label: Text(command.label),
    );
  }

  Widget _buildAsHidden(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    switch (command.status) {
      case 0:
        return _buildAsEnabled(context);
      case 1:
        return _buildAsDisabled(context);
      case 2:
      default:
        return _buildAsHidden(context);
    }
  }
}
