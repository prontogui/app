import 'package:flutter_test/flutter_test.dart';
import 'package:app/src/widgets/numeric_field.dart';

void main() {
  group('formatNumericValue', () {
    test('decimal places 0 to n', () {
      expect(formatNumericValue('0.12345', 0), '0');
      expect(formatNumericValue('0.123456', 1), '0.1');
      expect(formatNumericValue('0.123456', 2), '0.12');
      expect(formatNumericValue('0.123456', 3), '0.123');
      expect(formatNumericValue('0.123456', 4), '0.1235');
      expect(formatNumericValue('0.123456', 5), '0.12346');
      expect(formatNumericValue('0.123456', 6), '0.123456');
      expect(formatNumericValue('0.123456', 7), '0.1234560');
    });

    test('decimal places -1 to -n', () {
      expect(formatNumericValue('0.12345', -1), '0.1');
      expect(formatNumericValue('0.12345', -2), '0.12');
      expect(formatNumericValue('0.12345', -3), '0.123');
      expect(formatNumericValue('0.12345', -4), '0.1235');
      expect(formatNumericValue('0', -1), '0');
      expect(formatNumericValue('0.1', -2), '0.1');
      expect(formatNumericValue('0.12', -7), '0.12');
      expect(formatNumericValue('0.12345', -4), '0.1235');
    });

    test('decimal places as-is (default)', () {
      expect(formatNumericValue('0.12345'), '0.12345');
      expect(formatNumericValue('0'), '0');
      expect(formatNumericValue('0.1'), '0.1');
    });

    test('negative formats', () {
      expect(
          formatNumericValue(
              '-340.12345', null, NegativeDisplayFormat.absolute),
          '340.12345');
      expect(formatNumericValue('-981.12', null, NegativeDisplayFormat.parens),
          '(981.12)');
      expect(
          formatNumericValue(
              '-981.12', null, NegativeDisplayFormat.minusSignPrefix),
          '-981.12');
    });

    test('ignore negative formats when positive', () {
      expect(
          formatNumericValue('340.12345', null, NegativeDisplayFormat.absolute),
          '340.12345');
      expect(formatNumericValue('981.12', null, NegativeDisplayFormat.parens),
          '981.12');
      expect(
          formatNumericValue(
              '981.12', null, NegativeDisplayFormat.minusSignPrefix),
          '981.12');
    });

    test('various combinations of specifications', () {
      expect(
          formatNumericValue('-340.12345', 3, NegativeDisplayFormat.absolute),
          '340.123');
      expect(formatNumericValue('-981.12', -1, NegativeDisplayFormat.parens),
          '(981.1)');
    });

    test('display thousandths separators', () {
      expect(formatNumericValue('123456789.4566', null, null, true),
          '123,456,789.4566');
      expect(formatNumericValue('-123456789.4566', null, null, true),
          '-123,456,789.4566');
    });

    test('getPrecisionOfNumericValue', () {
      expect(getPrecisionOfNumericValue('- 340'), 0);
      expect(getPrecisionOfNumericValue('-340 '), 0);
      expect(getPrecisionOfNumericValue('  -340 '), 0);
      expect(getPrecisionOfNumericValue('-340.'), 0);
      expect(getPrecisionOfNumericValue('-340. '), 0);

      expect(getPrecisionOfNumericValue('-340.1'), 1);
      expect(getPrecisionOfNumericValue('-340.12'), 2);
      expect(getPrecisionOfNumericValue('-340.12    '), 2);
      expect(getPrecisionOfNumericValue('-340.12345'), 5);
    });

    test('addThousandthsSeparators', () {
      expect(addThousandthsSeparators('3'), '3');
      expect(addThousandthsSeparators('34'), '34');
      expect(addThousandthsSeparators('340'), '340');
      expect(addThousandthsSeparators('3400'), '3,400');
      expect(addThousandthsSeparators('1234567890'), '1,234,567,890');
      expect(addThousandthsSeparators('3.14159'), '3.14159');
      expect(addThousandthsSeparators('1234567890.0123'), '1,234,567,890.0123');
    });
  });
}
