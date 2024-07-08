// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/exportfile.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ExportFileEmbodiment extends StatelessWidget {
  const ExportFileEmbodiment({
    super.key,
    required this.exportFile,
  });

  final ExportFile exportFile;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        child: const Text("Select File"),
        onPressed: () async {
          // TODO:  wait asyncrhonously for user to pick file and handle it
          // using a Future.
          var saveTo = await FilePicker.platform.saveFile(
              fileName: exportFile.name.toString(),
              dialogTitle: "Select location to export PDF file to");

          if (saveTo != null) {
            File file = File(saveTo);

            // TODO:  write file asyncrhonously and use a Future to process data.
            await file.writeAsBytes(exportFile.data);

            exportFile.exportComplete();
          }

          // Take Data and write to the file.
        });
  }
}
