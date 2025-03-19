/*
 This is code to generate icon_map.dart from icons2.txt, which is a subset of 
 Flutter's icons.dart file.  It was only used once and probably will never be used again.
*/

/*
import 'dart:io';

void _generateIconMap() async {
  var fileContents =
      await File('/Users/andy/dev/pg/app/test/src/embodiment/icons2.txt')
          .readAsString();

  // Parse the file line by line
  var rawLines = fileContents.split('\n');
  var ids = List<String>.empty(growable: true);

  for (var rawLine in rawLines) {
    var line = rawLine.trim();

    if (line.isEmpty) {
      continue;
    }

    var pieces = line.split(' ');
    if (pieces.isEmpty) {
      continue;
    }

    if (pieces[0] == 'static') {
      ids.add(pieces[3]);
    }
  }

  print(' # ids parsed = ${ids.length}');

  var filePath = '/Users/andy/dev/pg/app/lib/src/embodiment/icon_map.dart';

  var mappings = List<String>.generate(ids.length, (i) {
    var id = ids[i];
    return "  '$id' : Icons.$id,";
  });
  var mappingContent = mappings.join('\n');
  var code = '''
import 'package:flutter/material.dart';

IconData? translateIdToIconData(String id) {
  return _iconMap[id];
}

const _iconMap = <String, IconData>{
$mappingContent
};
''';

  var f = File(filePath);
  await f.writeAsString(code);
}
*/
