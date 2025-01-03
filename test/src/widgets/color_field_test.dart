import 'package:flutter_test/flutter_test.dart';
import 'package:app/src/widgets/color_field.dart';

void main() {
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
