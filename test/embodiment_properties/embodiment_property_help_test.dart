import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/src/embodiment_properties/embodiment_property_help.dart';

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
}
