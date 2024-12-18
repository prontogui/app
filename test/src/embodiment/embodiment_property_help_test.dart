import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/src/embodiment/embodiment_property_help.dart';

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

  group('isNormalizedHexColorValue', () {
    test('correct values', () {
      expect(isNormalizedHexColorValue('#'), true);
      expect(isNormalizedHexColorValue('#0'), true);
      expect(isNormalizedHexColorValue('#01234567'), true);
      expect(isNormalizedHexColorValue('#ABCDEF'), true);
    });

    test('incorrect values', () {
      expect(isNormalizedHexColorValue(' #'), false);
      expect(isNormalizedHexColorValue('# '), false);
      expect(isNormalizedHexColorValue(' #0 '), false);
      expect(isNormalizedHexColorValue('#0 '), false);
      expect(isNormalizedHexColorValue('#012345678'), false);
      expect(isNormalizedHexColorValue('#0123456G'), false);
    });
  });

  group('normalizeHexColorValue', () {
    test('various values', () {
      expect(normalizeHexColorValue(' #'), '#');
      expect(normalizeHexColorValue('#0 '), '#0');
      expect(normalizeHexColorValue('0 '), '#0');
      expect(normalizeHexColorValue('FF0 '), '#FF0');
      expect(normalizeHexColorValue(' #01234567 '), '#01234567');
      expect(normalizeHexColorValue('#abCDef'), '#ABCDEF');
      expect(normalizeHexColorValue('01234567 '), '#01234567');
      expect(normalizeHexColorValue('abCDef'), '#ABCDEF');
    });
  });

  group('canonizeHexColorValue', () {
    test('various values', () {
      expect(canonizeHexColorValue('#'), '#FF000000');
      expect(canonizeHexColorValue('#1'), '#FF010000');
      expect(canonizeHexColorValue('#12'), '#FF120000');
      expect(canonizeHexColorValue('#123'), '#FF120300');
      expect(canonizeHexColorValue('#1234'), '#FF123400');
      expect(canonizeHexColorValue('#12345'), '#FF123405');
      expect(canonizeHexColorValue('#123456'), '#FF123456');
      expect(canonizeHexColorValue('#A123456'), '#0A123456');
      expect(canonizeHexColorValue('#BB123456'), '#BB123456');
    });
  });
}
