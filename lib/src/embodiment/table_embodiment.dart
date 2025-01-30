// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import '../embodifier.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'properties.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Table', [
    EmbodimentManifestEntry('default', TableEmbodiment.fromArgs),
  ]);
}

class TableEmbodiment extends StatelessWidget {
  TableEmbodiment.fromArgs(this.args, {super.key})
      : table = args.primitive as pg.Table,
        props = CommonProperties.fromMap(args.primitive.embodimentProperties);

  final EmbodimentArgs args;
  final pg.Table table;
  final CommonProperties props;

  @override
  Widget build(BuildContext context) {
    // Is status for this primitive set to Hidden?
    if (table.status == 2) {
      return const SizedBox();
    }

    // Figure out how max # columns to display from headings and length of first row
    int totalNumColumns = table.headings.length;
    if (table.rows.isNotEmpty) {
      totalNumColumns = max(totalNumColumns, table.rows[0].length);
    }

    // Handle the case where table has an empty template row.
    if (totalNumColumns == 0) {
      // TODO:  show an error box or other visual and log an error
      return const SizedBox();
    }
    // Build the column configurations and a "fingerprint" of the headers
    var headerFingerprint = "";
    var columnsD = List<DataColumn>.empty(growable: true);

    for (var heading in table.headings) {
      headerFingerprint = "$headerFingerprint|$heading";

      columnsD.add(DataColumn(
        label: Text(heading),
      ));
    }

    // Add additional headings to if needed to reach total num. columns
    for (int i = columnsD.length; i < totalNumColumns; i++) {
      columnsD.add(const DataColumn(
        label: Text(''),
      ));
    }

    // Build the data rows from primitive rows
    var embodifier = InheritedEmbodifier.of(context);
    var rowsD = List<DataRow>.empty(growable: true);

    for (var row in table.rows) {
      var cellsD = List<DataCell>.empty(growable: true);

      for (var cell in row) {
        // TODO:  utilize the template row cells when calling .buildPrimitive
        var cellEmbodiment =
            embodifier.buildPrimitive(context, EmbodimentArgs(cell));
        cellsD.add(DataCell(cellEmbodiment));
      }

      rowsD.add(DataRow(cells: cellsD));
    }

    var ds = TableDataSource(rowsD);

    // NOTE:  more thought should be put into generating an appropriate key for the table, due to the
    // dynamic nature of building user interfaces.  For now, we'll use the fingerprint of the header
    // titles to form a key.
    return PaginatedDataTable(
        rowsPerPage: 5,
        columns: columnsD,
        source: ds,
        key: Key(headerFingerprint));
  }
}

class TableDataSource extends DataTableSource {
  TableDataSource(this.rows);

  final List<DataRow> rows;

  @override
  int get rowCount => rows.length;

  @override
  DataRow? getRow(int index) {
    if (index < rows.length) {
      return rows[index];
    }
    return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
