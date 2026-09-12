import 'package:csv/csv.dart';

/// One row parsed from an uploaded CSV, before it has been reviewed.
typedef ParsedImportRow = ({
  DateTime date,
  String description,
  int amountCents, // signed: positive = income, negative = expense
});

/// How the uploaded CSV's columns map to a transaction. Either
/// [amountColumn] alone (a signed amount, negative meaning an expense) or
/// [debitColumn]/[creditColumn] together (unsigned, in separate columns) —
/// banks export both shapes about equally often.
class CsvColumnMapping {
  const CsvColumnMapping({
    required this.dateColumn,
    required this.descriptionColumn,
    this.amountColumn,
    this.debitColumn,
    this.creditColumn,
  });

  final int dateColumn;
  final int descriptionColumn;
  final int? amountColumn;
  final int? debitColumn;
  final int? creditColumn;
}

class CsvParseException implements Exception {
  CsvParseException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Splits a raw CSV file into a header row and data rows, for the
/// column-mapping screen to show a preview against. A file with no
/// detectable header still works — the columns are just labelled
/// generically instead of by name.
({List<String> headers, List<List<dynamic>> rows}) readCsvTable(
    String csvText) {
  final table = const CsvToListConverter(shouldParseNumbers: false)
      .convert(csvText, eol: '\n');
  if (table.isEmpty) {
    throw CsvParseException('That file has no rows.');
  }
  final first = table.first.map((c) => c.toString()).toList();
  // Heuristic: a header row has no cell that parses as a number or a date —
  // real transaction data almost always has at least one of each.
  final looksLikeHeader = first.every((cell) =>
      double.tryParse(cell.replaceAll(RegExp(r'[,$]'), '')) == null &&
      _parseDate(cell) == null);
  return (
    headers: looksLikeHeader
        ? first
        : [for (var i = 0; i < first.length; i++) 'Column ${i + 1}'],
    rows: looksLikeHeader ? table.skip(1).toList() : table,
  );
}

/// Parses each data row into a transaction using [mapping]. A row that
/// can't be parsed (bad date, blank amount) is skipped rather than
/// aborting the whole import — a stray blank line at the end of a bank's
/// export is common and shouldn't sink an otherwise-good file.
List<ParsedImportRow> parseImportRows(
  List<List<dynamic>> rows,
  CsvColumnMapping mapping,
) {
  final result = <ParsedImportRow>[];
  for (final row in rows) {
    if (row.length <= mapping.dateColumn ||
        row.length <= mapping.descriptionColumn) {
      continue;
    }
    final date = _parseDate(row[mapping.dateColumn].toString());
    if (date == null) continue;

    int? amountCents;
    if (mapping.amountColumn != null) {
      if (row.length <= mapping.amountColumn!) continue;
      amountCents = _parseAmountCents(row[mapping.amountColumn!].toString());
    } else {
      final debit = mapping.debitColumn != null &&
              row.length > mapping.debitColumn!
          ? _parseAmountCents(row[mapping.debitColumn!].toString())
          : null;
      final credit = mapping.creditColumn != null &&
              row.length > mapping.creditColumn!
          ? _parseAmountCents(row[mapping.creditColumn!].toString())
          : null;
      if (debit != null && debit != 0) {
        amountCents = -debit.abs();
      } else if (credit != null && credit != 0) {
        amountCents = credit.abs();
      }
    }
    if (amountCents == null || amountCents == 0) continue;

    result.add((
      date: date,
      description: row[mapping.descriptionColumn].toString().trim(),
      amountCents: amountCents,
    ));
  }
  return result;
}

DateTime? _parseDate(String raw) {
  final s = raw.trim();
  if (s.isEmpty) return null;
  // MM/DD/YYYY or M/D/YY — the near-universal US bank export format —
  // checked first, since DateTime.parse would otherwise misread it.
  final m = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{2,4})$').firstMatch(s);
  if (m != null) {
    final month = int.parse(m.group(1)!);
    final day = int.parse(m.group(2)!);
    var year = int.parse(m.group(3)!);
    if (year < 100) year += 2000;
    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }
  final iso = DateTime.tryParse(s);
  if (iso != null) return DateTime(iso.year, iso.month, iso.day);
  return null;
}

int? _parseAmountCents(String raw) {
  var s = raw.trim();
  if (s.isEmpty) return null;
  var negative = false;
  if (s.startsWith('(') && s.endsWith(')')) {
    negative = true;
    s = s.substring(1, s.length - 1);
  }
  s = s.replaceAll(RegExp(r'[,$\s]'), '');
  if (s.startsWith('-')) {
    negative = true;
    s = s.substring(1);
  }
  final value = double.tryParse(s);
  if (value == null) return null;
  final cents = (value * 100).round();
  return negative ? -cents : cents;
}
