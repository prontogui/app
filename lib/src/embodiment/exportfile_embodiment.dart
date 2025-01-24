// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('ExportFile', [
    EmbodimentManifestEntry('default', ExportFileEmbodiment.fromArgs),
  ]);
}

class ExportFileEmbodiment extends StatelessWidget {
  ExportFileEmbodiment.fromArgs(
    this.args, {
    super.key,
  }) : exportFile = args.primitive as pg.ExportFile;

  final EmbodimentArgs args;
  final pg.ExportFile exportFile;

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

            exportFile.exported = true;
          }

          // Take Data and write to the file.
        });
  }
}
