// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:app/primitive/table.dart';
import 'package:app/embodiment/embodifier.dart';
import 'package:flutter/material.dart';

class TableEmbodiment extends StatelessWidget {
  const TableEmbodiment({super.key, required this.table});

  final TableP table;

  @override
  Widget build(BuildContext context) {
    // Get the total number of columns to display
    var totalNumColumns = table.templateRow.length;

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
          label: Expanded(
        child: Text(heading),
      )));
    }

    // Add additional headings to if needed to reach total num. columns
    for (int i = columnsD.length; i < totalNumColumns; i++) {
      columnsD.add(const DataColumn(
          label: Expanded(
        child: Text(''),
      )));
    }

    // Build the data rows from primitive rows
    var embodifier = Embodifier.of(context);
    var rowsD = List<DataRow>.empty(growable: true);

    for (var row in table.rows) {
      var cellsD = List<DataCell>.empty(growable: true);

      for (var cell in row) {
        var cellEmbodiment = embodifier.buildPrimitive(context, cell);
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
    /*
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(columns: columnsD, rows: rowsD),
    );
		*/
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
