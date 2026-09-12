import 'package:flutter_test/flutter_test.dart';
import 'package:clearly/data/csv_import.dart';

void main() {
  group('readCsvTable', () {
    test('detects a header row and separates it from the data', () {
      final result = readCsvTable('Date,Description,Amount\n'
          '01/15/2026,Coffee Shop,-4.50\n'
          '01/16/2026,Paycheck,1850.00\n');
      expect(result.headers, ['Date', 'Description', 'Amount']);
      expect(result.rows, hasLength(2));
    });

    test('a file with no header still works, with generic column names', () {
      final result = readCsvTable('01/15/2026,Coffee Shop,-4.50\n');
      expect(result.headers, ['Column 1', 'Column 2', 'Column 3']);
      expect(result.rows, hasLength(1));
    });

    test('an empty file throws', () {
      expect(() => readCsvTable(''), throwsA(isA<CsvParseException>()));
    });
  });

  group('parseImportRows', () {
    test('parses a signed amount column', () {
      final rows = parseImportRows([
        ['01/15/2026', 'Coffee Shop', '-4.50'],
        ['01/16/2026', 'Paycheck', '1850.00'],
      ], const CsvColumnMapping(
          dateColumn: 0, descriptionColumn: 1, amountColumn: 2));

      expect(rows, hasLength(2));
      expect(rows[0].date, DateTime(2026, 1, 15));
      expect(rows[0].description, 'Coffee Shop');
      expect(rows[0].amountCents, -450);
      expect(rows[1].amountCents, 185000);
    });

    test('parses separate debit/credit columns', () {
      final rows = parseImportRows([
        ['01/15/2026', 'Coffee Shop', '4.50', ''],
        ['01/16/2026', 'Paycheck', '', '1850.00'],
      ], const CsvColumnMapping(
          dateColumn: 0, descriptionColumn: 1, debitColumn: 2, creditColumn: 3));

      expect(rows[0].amountCents, -450, reason: 'a debit is an expense');
      expect(rows[1].amountCents, 185000, reason: 'a credit is income');
    });

    test('handles parenthesized negatives and currency symbols', () {
      final rows = parseImportRows([
        ['01/15/2026', 'Refund fee', r'($1,234.56)'],
      ], const CsvColumnMapping(
          dateColumn: 0, descriptionColumn: 1, amountColumn: 2));

      expect(rows.single.amountCents, -123456);
    });

    test('skips a row with an unparseable date instead of throwing', () {
      final rows = parseImportRows([
        ['not a date', 'Coffee Shop', '-4.50'],
        ['01/16/2026', 'Paycheck', '1850.00'],
      ], const CsvColumnMapping(
          dateColumn: 0, descriptionColumn: 1, amountColumn: 2));

      expect(rows, hasLength(1));
      expect(rows.single.description, 'Paycheck');
    });

    test('skips a row with a blank amount', () {
      final rows = parseImportRows([
        ['01/15/2026', 'Pending', ''],
      ], const CsvColumnMapping(
          dateColumn: 0, descriptionColumn: 1, amountColumn: 2));

      expect(rows, isEmpty);
    });

    test('two-digit years are read as 2000s', () {
      final rows = parseImportRows([
        ['1/5/26', 'Coffee Shop', '-4.50'],
      ], const CsvColumnMapping(
          dateColumn: 0, descriptionColumn: 1, amountColumn: 2));

      expect(rows.single.date, DateTime(2026, 1, 5));
    });

    test('ISO dates (YYYY-MM-DD) are also understood', () {
      final rows = parseImportRows([
        ['2026-01-15', 'Coffee Shop', '-4.50'],
      ], const CsvColumnMapping(
          dateColumn: 0, descriptionColumn: 1, amountColumn: 2));

      expect(rows.single.date, DateTime(2026, 1, 15));
    });
  });
}
