// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:dartlib/dartlib.dart' as pg;

class ServerField extends StatefulWidget {
  const ServerField({super.key, required this.comm});

  final pg.CommClientCtl comm;

  @override
  State<ServerField> createState() => _ServerFieldState();
}

class _ServerFieldState extends State<ServerField> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    String serverAddressText = widget.comm.serverAddress.isEmpty
        ? ''
        : '${widget.comm.serverAddress}:${widget.comm.serverPort}';
    _controller = TextEditingController(text: serverAddressText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTextField(BuildContext context) {
    return TextField(
      minLines: 1,
      maxLines: 1,
      controller: _controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: const Text('Server address:port'),
          errorText: _errorText),
      onChanged: (value) {
        // Parse server option as addr:port
        final serverParts = value.split(':');

        if (serverParts.length != 2) {
          setState(() => _errorText = 'Must specifiy address and port.');
          return;
        }

        final serverAddress = serverParts[0];

        final port = int.tryParse(serverParts[1]);
        if (port == null) {
          setState(() => _errorText = 'Invalid port number.');
          return;
        }

        widget.comm.serverAddress = serverAddress;
        widget.comm.serverPort = port;

        setState(() => _errorText = null);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Add the following Expanded widget to avoid getting an exception during rendering.
    // See item #2 in the Problem Solving section in README.md file.
    // The Expanded widget was removed. [10/10/24 - aj]
    return _buildTextField(context);
  }
}
