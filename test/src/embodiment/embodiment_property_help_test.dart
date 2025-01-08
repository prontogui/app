import 'package:app/src/embodiment/embodiment_property_help.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main() {
  group('getEnumStringProp', () {
    test('returns default value when map is null', () {
      expect(getEnumStringProp(null, 'prop', 'default', {'valid'}), 'default');
    });

    test('returns default value when property is not in map', () {
      expect(getEnumStringProp({}, 'prop', 'default', {'valid'}), 'default');
    });

    test('throws exception when property value is not a string', () {
      expect(
          () => getEnumStringProp({'prop': 123}, 'prop', 'default', {'valid'}),
          throwsException);
    });

    test('throws exception when property value is not in valid enums', () {
      expect(
          () => getEnumStringProp(
              {'prop': 'invalid'}, 'prop', 'default', {'valid'}),
          throwsException);
    });

    test('returns property value when it is valid', () {
      expect(getEnumStringProp({'prop': 'valid'}, 'prop', 'default', {'valid'}),
          'valid');
    });
  });

  group('getColorProp', () {
    test('returns null when map is null', () {
      expect(getColorProp(null, 'color'), null);
    });

    test('returns null when property is not in map', () {
      expect(getColorProp({}, 'color'), null);
    });

    test('throws exception when property value is not a string', () {
      expect(() => getColorProp({'color': 123}, 'color'), throwsException);
    });

    test('returns Color when property value is valid ARGB', () {
      expect(getColorProp({'color': 'argb:0xFFFFFFFF'}, 'color'),
          Color(0xFFFFFFFF));
    });

    test('throws exception when property value is invalid', () {
      expect(
          () => getColorProp({'color': 'invalid'}, 'color'), throwsException);
    });
  });

  group('getFontWeight', () {
    test('returns null when map is null', () {
      expect(getFontWeight(null), null);
    });

    test('returns null when property is not in map', () {
      expect(getFontWeight({}), null);
    });

    test('throws exception when property value is not a string', () {
      expect(() => getFontWeight({'fontWeight': 123}), throwsException);
    });

    test('returns FontWeight when property value is valid', () {
      expect(getFontWeight({'fontWeight': 'bold'}), FontWeight.bold);
    });

    test('throws exception when property value is invalid', () {
      expect(() => getFontWeight({'fontWeight': 'invalid'}), throwsException);
    });
  });

  group('getNumericProp', () {
    test('returns null when map is null', () {
      expect(getNumericProp(null, 'prop', 0, 10), null);
    });

    test('returns null when property is not in map', () {
      expect(getNumericProp({}, 'prop', 0, 10), null);
    });

    test('throws exception when property value is not a string', () {
      expect(
          () => getNumericProp({'prop': 123}, 'prop', 0, 10), throwsException);
    });

    test('returns null when property value is out of range', () {
      expect(getNumericProp({'prop': '15'}, 'prop', 0, 10), null);
    });

    test('returns numeric value when property value is valid', () {
      expect(getNumericProp({'prop': '5'}, 'prop', 0, 10), 5);
    });
  });

  group('getNumericPropOrDefault', () {
    test('returns default value when map is null', () {
      expect(getNumericPropOrDefault(null, 'prop', 0, 10, 5), 5);
    });

    test('returns default value when property is not in map', () {
      expect(getNumericPropOrDefault({}, 'prop', 0, 10, 5), 5);
    });

    test('returns default value when property value is out of range', () {
      expect(getNumericPropOrDefault({'prop': '15'}, 'prop', 0, 10, 5), 5);
    });

    test('returns numeric value when property value is valid', () {
      expect(getNumericPropOrDefault({'prop': '5'}, 'prop', 0, 10, 5), 5);
    });
  });

  group('getBoolPropOrDefault', () {
    test('returns default value when map is null', () {
      expect(getBoolPropOrDefault(null, 'prop', true), true);
    });

    test('returns default value when property is not in map', () {
      expect(getBoolPropOrDefault({}, 'prop', true), true);
    });

    test('throws exception when property value is not a string', () {
      expect(() => getBoolPropOrDefault({'prop': 123}, 'prop', true),
          throwsException);
    });

    test('returns default value when property value is invalid', () {
      expect(getBoolPropOrDefault({'prop': 'invalid'}, 'prop', true), true);
    });

    test('returns boolean value when property value is valid', () {
      expect(getBoolPropOrDefault({'prop': 'true'}, 'prop', false), true);
    });
  });

  group('getStringArrayProp', () {
    test('returns a valid array', () {
      var embodiment = '''
{"someProp" : ["orange", "banana", "pear", "10"]}
''';
      var map = jsonDecode(embodiment) as Map<String, dynamic>;
      var array = getStringArrayProp(map, 'someProp');
      expect(array, isNotNull);
      expect(array!.length, equals(4));
      expect(array[0], equals('orange'));
      expect(array[1], equals('banana'));
      expect(array[2], equals('pear'));
      expect(array[3], equals('10'));
    });
    test('returns null if map is null', () {
      var array = getStringArrayProp(null, 'someProp');
      expect(array, isNull);
    });
    test('returns null if property not found in map', () {
      var embodiment = '''
{"someProp" : ["orange", "banana", "pear", "10"]}
''';
      var map = jsonDecode(embodiment) as Map<String, dynamic>;
      var array = getStringArrayProp(map, 'otherProp');
      expect(array, isNull);
    });
    test('throws exception if property is a string', () {
      var embodiment = '''
{"someProp" : "value"}
''';
      var map = jsonDecode(embodiment) as Map<String, dynamic>;
      expect(() => getStringArrayProp(map, 'someProp'), throwsException);
    });
    test('throws exception if property is a structure', () {
      var embodiment = '''
{"someProp" : {"innerProp":"value"}}
''';
      var map = jsonDecode(embodiment) as Map<String, dynamic>;
      expect(() => getStringArrayProp(map, 'someProp'), throwsException);
    });

    test('throws exception if array property contains items other than strings',
        () {
      var embodiment = '''
{"someProp" : ["orange", "banana", 99]}
''';
      var map = jsonDecode(embodiment) as Map<String, dynamic>;
      expect(() => getStringArrayProp(map, 'someProp'), throwsException);
    });
  });
}
