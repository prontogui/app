// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ImportFileEmbodiment extends StatelessWidget {
  const ImportFileEmbodiment({super.key, required this.importFile});

  final pg.ImportFile importFile;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        child: const Text("Select File"),
        onPressed: () async {
          // TODO:  wait asyncrhonously for user to pick file and handle it
          // using a Future.
          FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: importFile.validExtensions,
              dialogTitle: "Select file to import");

          if (result != null) {
            File file = File(result.files.single.path!);

            // TODO:  check the length against a maximum import size
            //var length = await file.length();

            // TODO:  read file asyncrhonously and use a Future to process data.
            file.readAsBytes().then((bytes) {
              importFile.importData(bytes, result.files.single.name);
            });
          }

          // Take Data and write to the file.
        });
  }
}
