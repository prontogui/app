// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import '../embodifier.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'embodiment_args.dart';
import 'embodiment_help.dart';
import 'properties.dart';


class PagedTableEmbodiment extends StatelessWidget {
  const PagedTableEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var table = args.primitive as pg.Table;
    var props = args.properties as TablePagedPropertyAccess;

    // Is status for this primitive set to Hidden?
    if (table.status == 2) {
      return const SizedBox();
    }

    // Figure out how max # columns to display from headings and length of first row
    int totalNumColumns = table.headerRow.length;
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

    var embodifier = InheritedEmbodifier.of(context);

    for (int col = 0; col < table.headings.length; col++) {
      var heading = table.headings[col];
      headerFingerprint = "$headerFingerprint|$heading";

      TableColumnWidth? columnWidth;

      if (col < props.columnSettings.length) {
        var columnSettings = props.columnSettings[col];

        var width = columnSettings.width;
        if (width != null) {
          columnWidth = FixedColumnWidth(width);
        }
      }

      var headingEmbodiment = embodifier.buildPrimitive(context, table.headerRow[col]);

      columnsD.add(DataColumn(
        label: Expanded(child: headingEmbodiment,),
        columnWidth: columnWidth,
//        headingRowAlignment: MainAxisAlignment.center
      ));
    }

    // Add additional headings to if needed to reach total num. columns
    for (int i = columnsD.length; i < totalNumColumns; i++) {
      columnsD.add(const DataColumn(
        label: Text(''),
      ));
    }

    // Build the data rows from primitive rows
    var rowsD = List<DataRow>.empty(growable: true);
    var modelRow = table.modelRow;

    for (var row in table.rows) {
      var cellsD = List<DataCell>.empty(growable: true);

      int col = 0;
      for (var cell in row) {
        pg.Primitive? modelPrimitive;

        // Is there a corresponding model primitive for the column?
        if (col < modelRow.length) {
          modelPrimitive = modelRow[col];
        }

        // Build the embodiment for the cell, incorporating any model primitive properties.
        var cellEmbodiment = embodifier.buildPrimitive(context, cell,
            modelPrimitive: modelPrimitive);

        cellsD.add(DataCell(cellEmbodiment));

        col++;
      }

      rowsD.add(DataRow(cells: cellsD));
    }

    var ds = TableDataSource(rowsD);

    // Construct a paginated data table and use a key. The key is neededed because
    // the state of which page the user is viewing will get reset in certain rebuild scenarios.
    //
    // NOTE: more thought should be put into generating an appropriate key for the table, due to the
    // dynamic nature of building user interfaces. For now, we'll use the fingerprint of the header
    // titles to form a key.
    var content = PaginatedDataTable(
        rowsPerPage: props.rowsPerPage,
        columns: columnsD,
        source: ds,
        key: Key(headerFingerprint));
        
    return encloseWithPBMSAF(content, args);
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
