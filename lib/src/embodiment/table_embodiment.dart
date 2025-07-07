// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dartlib/dartlib.dart' as pg;
import '../embodifier.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'embodiment_manifest.dart';
import 'embodiment_args.dart';
import 'embodiment_help.dart';
import 'properties.dart';
import 'paged_table_embodiment.dart';

EmbodimentPackageManifest getManifest() {
  return EmbodimentPackageManifest('Table', [
    EmbodimentManifestEntry(
        'default', DefaultTableEmbodiment.fromArgs, TableDefaultProperties.fromMap),
    EmbodimentManifestEntry(
        'paged', PagedTableEmbodiment.fromArgs, TablePagedProperties.fromMap),
  ]);
}

class DefaultTableEmbodiment extends StatelessWidget {
  const DefaultTableEmbodiment.fromArgs(this.args, {super.key});

  final EmbodimentArgs args;

  @override
  Widget build(BuildContext context) {
    var table = args.primitive as pg.Table;
    var props = args.properties as TableDefaultProperties;

    // Is status for this primitive set to Hidden?
    if (table.status == 2) {
      return const SizedBox();
    }

    // Figure out how max # columns to display from headings, model row, or the length of first row
    int numHeadings = table.headerRow.length;
    var numColumns = max(numHeadings, table.modelRow.length);
    if (table.rows.isNotEmpty) {
      numColumns = max(numColumns, table.rows[0].length);
    }

    // Handle the case where table is totally empty
    if (numColumns == 0) {
      // TODO:  show an error box or other visual and log an error
      return const SizedBox();
    }

    // Build the data rows from primitive rows
    var embodifier = InheritedEmbodifier.of(context);
    var rowsD = List<TableRow>.empty(growable: true);
    var modelRow = table.modelRow;

    // Builds a TableCell from a primitive and an optional model primitive.
    TableCell buildTableCell(pg.Primitive primitive, pg.Primitive? modelPrimitive) {
        // Build the embodiment for the cell, incorporating any model primitive properties.
        var cellEmbodiment = embodifier.buildPrimitive(context, primitive,
            modelPrimitive: modelPrimitive);

        // promote the vertical alignment from the cellEmbodiment to the TableCell
        TableCellVerticalAlignment? verticalAlignment;

        var cellEmbodimentProperties = embodifier.factory.getEmbodimentPropertiesFromInfo<CommonPropertyAccess>(primitive.embodimentInfo);
        if (cellEmbodimentProperties != null) {
          var cellVerticalAlignment = cellEmbodimentProperties.verticalAlignment;

          switch (cellVerticalAlignment) {
            case VerticalAlignment.top:
              verticalAlignment = TableCellVerticalAlignment.top;
            case VerticalAlignment.bottom:
              verticalAlignment = TableCellVerticalAlignment.bottom;
            case VerticalAlignment.middle:
              verticalAlignment = TableCellVerticalAlignment.middle;
            case VerticalAlignment.expand:
              verticalAlignment = TableCellVerticalAlignment.fill;
          }
        }

        return TableCell(verticalAlignment: verticalAlignment, child: cellEmbodiment);
    }

    // Insert a heading?
    if (numHeadings > 0) {
      var headerCells = List<TableCell>.generate(numHeadings, (int col) => buildTableCell(table.headerRow[col], null) , growable: false);
      rowsD.add(TableRow(children: headerCells));
    }

    for (var row in table.rows) {
      // Must have the expected number of cells
      if (row.length != numColumns) {
        // TODO:  show an error box or other visual and log an error
        return const SizedBox();
      }

      var cellsD = List<TableCell>.empty(growable: true);

      int col = 0;
      for (var cell in row) {
        pg.Primitive? modelPrimitive;

        // Is there a corresponding model primitive for the column?
        if (col < modelRow.length) {
          modelPrimitive = modelRow[col];
        }

        cellsD.add(buildTableCell(cell, modelPrimitive));
        col++;
      }

      rowsD.add(TableRow(children: cellsD));
    }

    // Handle borders
    TableBorder? border;
    if (props.isInsideBorder) {

      var color = Colors.black;
      var colorSetting = props.insideBorderColor;
      if (colorSetting != null) {
        color = colorSetting;
      }

      BorderSide makeBorderSide(double? b) {
        if (b != null) {
          return BorderSide(width: b, color: color);
        } else {
          var all = props.insideBorderAll;
          if (all != null) {
            return BorderSide(width: all, color: color);
          }
        }
        return BorderSide.none;
      }
   
      border = TableBorder(
        bottom: makeBorderSide(props.insideBorderBottom),
        horizontalInside: makeBorderSide(props.insideBorderHorizontals),
        left: makeBorderSide(props.insideBorderLeft),
        right: makeBorderSide(props.insideBorderRight),
        top: makeBorderSide(props.insideBorderTop),
        verticalInside: makeBorderSide(props.insideBorderVerticals)
        );
    }

    // Handle column setings
    Map<int, TableColumnWidth>? columnWidths;
    for (int col = 0; col < min(props.columnSettings.length, numColumns); col ++) {
      columnWidths ??= {};

      var columnSettings = props.columnSettings[col];

      late TableColumnWidth columnWidth;

      var width = columnSettings.width;
      if (width != null) {
        columnWidth = FixedColumnWidth(width);
      } else {
        columnWidth = FlexColumnWidth();
      }
      columnWidths[col] = columnWidth;
    }

    var content = Table(children: rowsD, border: border, columnWidths: columnWidths);

    return encloseWithPBMSAF(content, args);
  }
}
