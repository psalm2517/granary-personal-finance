import 'package:flutter_test/flutter_test.dart';
import 'package:granary/util/money.dart';

void main() {
  group('fmtCents', () {
    test('formats whole dollars with two-digit cents', () {
      expect(fmtCents(123456), '\$1,234.56');
    });

    test('pads a single-digit cents value', () {
      expect(fmtCents(100), '\$1.00');
      expect(fmtCents(105), '\$1.05');
    });

    test('zero', () {
      expect(fmtCents(0), '\$0.00');
    });

    test('negative amounts keep the sign in front of the dollar sign', () {
      expect(fmtCents(-500), '-\$5.00');
      expect(fmtCents(-1), '-\$0.01');
    });

    test('commas land every three digits, not just once', () {
      expect(fmtCents(123456789), '\$1,234,567.89');
    });

    test('under a dollar has no leading comma or stray digit', () {
      expect(fmtCents(1), '\$0.01');
      expect(fmtCents(99), '\$0.99');
    });
  });

  group('parseDollarsToCents', () {
    test('plain dollars with no cents', () {
      expect(parseDollarsToCents('1234'), 123400);
    });

    test('dollars and cents', () {
      expect(parseDollarsToCents('1234.56'), 123456);
    });

    test('strips a leading dollar sign and thousands commas', () {
      expect(parseDollarsToCents('\$1,234.56'), 123456);
    });

    test('a value that is not exactly representable in binary floating '
        'point still rounds to the intended cents', () {
      // 19.1 * 100 is 1909.9999999999998 in IEEE 754 double, not 1910 — the
      // function must round rather than truncate, or this comes out a cent
      // short.
      expect(parseDollarsToCents('19.1'), 1910);
      expect(parseDollarsToCents('0.1'), 10);
      expect(parseDollarsToCents('29.99'), 2999);
    });

    test('blank input is invalid', () {
      expect(parseDollarsToCents(''), isNull);
      expect(parseDollarsToCents('   '), isNull);
    });

    test('non-numeric input is invalid', () {
      expect(parseDollarsToCents('abc'), isNull);
    });

    test('a negative amount is preserved, not rejected', () {
      expect(parseDollarsToCents('-50'), -5000);
    });
  });

  group('ordinalDay', () {
    test('the common 1st/2nd/3rd suffixes', () {
      expect(ordinalDay(1), '1st');
      expect(ordinalDay(2), '2nd');
      expect(ordinalDay(3), '3rd');
    });

    test('everything else takes -th', () {
      expect(ordinalDay(4), '4th');
      expect(ordinalDay(10), '10th');
    });

    test('the 11-13 teens take -th despite ending in 1, 2 or 3', () {
      expect(ordinalDay(11), '11th');
      expect(ordinalDay(12), '12th');
      expect(ordinalDay(13), '13th');
    });

    test('21st/22nd/23rd resume the normal pattern past the teens', () {
      expect(ordinalDay(21), '21st');
      expect(ordinalDay(22), '22nd');
      expect(ordinalDay(23), '23rd');
    });

    test('the last days of a 31-day month', () {
      expect(ordinalDay(31), '31st');
    });
  });
}
