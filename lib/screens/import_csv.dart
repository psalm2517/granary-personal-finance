import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/csv_import.dart';
import '../data/database.dart';
import '../data/repository.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';
import 'accounts.dart' show accountIcon, accountTypeColor;

/// Column-map → review → commit, for turning a bank's CSV export into
/// transactions. A generic mapper rather than fixed columns, since every
/// bank shapes its export differently and this way none of them need
/// special-casing.
class ImportCsvScreen extends ConsumerStatefulWidget {
  const ImportCsvScreen({
    super.key,
    required this.sourceFilename,
    required this.headers,
    required this.rawRows,
  });

  final String sourceFilename;
  final List<String> headers;
  final List<List<dynamic>> rawRows;

  @override
  ConsumerState<ImportCsvScreen> createState() => _ImportCsvScreenState();
}

enum _AmountMode { signed, debitCredit }

class _ImportCsvScreenState extends ConsumerState<ImportCsvScreen> {
  int _step = 0;
  int? _accountId;
  int _dateColumn = 0;
  int _descriptionColumn = 1;
  int _amountColumn = 2;
  int _debitColumn = 2;
  int _creditColumn = 3;
  var _amountMode = _AmountMode.signed;
  var _updateBalance = false;

  List<ParsedImportRow>? _parsed;
  List<({ParsedImportRow row, bool isDuplicate})>? _reviewed;
  late Set<int> _included;
  var _committing = false;

  CsvColumnMapping get _mapping => _amountMode == _AmountMode.signed
      ? CsvColumnMapping(
          dateColumn: _dateColumn,
          descriptionColumn: _descriptionColumn,
          amountColumn: _amountColumn)
      : CsvColumnMapping(
          dateColumn: _dateColumn,
          descriptionColumn: _descriptionColumn,
          debitColumn: _debitColumn,
          creditColumn: _creditColumn);

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;

    return Scaffold(
      appBar: AppBar(title: Text('Import ${widget.sourceFilename}')),
      body: StreamBuilder<List<Account>>(
        stream: repo.watchAccounts(profileId: profileId),
        builder: (context, snap) {
          final accounts = (snap.data ?? [])
              .where((a) => HomebaseRepository.cashAccountTypes.contains(a.type))
              .toList();
          _accountId ??= accounts.firstOrNull?.id;
          if (_step == 0) {
            return _mappingStep(context, accounts);
          }
          return _reviewStep(context, profileId);
        },
      ),
    );
  }

  Widget _mappingStep(BuildContext context, List<Account> accounts) {
    final columnItems = [
      for (var i = 0; i < widget.headers.length; i++)
        DropdownMenuItem(value: i, child: Text(widget.headers[i])),
    ];
    return ListView(
      padding: kPagePadding,
      children: [
        const SectionHeader('Which account is this for?',
            icon: Icons.account_balance_outlined),
        if (accounts.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Add a checking, savings or cash account first — '
                  'that\'s where these transactions will land.'),
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<int>(
                initialValue: _accountId,
                decoration:
                    const InputDecoration(border: OutlineInputBorder()),
                items: [
                  for (final a in accounts)
                    DropdownMenuItem(
                      value: a.id,
                      child: Row(children: [
                        Icon(accountIcon(a.type),
                            size: 16, color: accountTypeColor(context, a.type)),
                        const SizedBox(width: 8),
                        Text(a.name),
                      ]),
                    ),
                ],
                onChanged: (v) => setState(() => _accountId = v),
              ),
            ),
          ),
        kSectionGap,
        SectionHeader('Match the columns',
            icon: Icons.view_column_outlined,
            info: const InfoButton(
              title: 'Column mapping',
              body: [
                'Every bank exports CSVs a little differently, so pick '
                    'which column in your file is which.',
                'Amount can be one column with a sign (negative for '
                    'spending), or two separate Debit and Credit columns — '
                    'whichever your file actually has.',
              ],
            )),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              DropdownButtonFormField<int>(
                initialValue: _dateColumn,
                decoration: const InputDecoration(
                    labelText: 'Date', border: OutlineInputBorder()),
                items: columnItems,
                onChanged: (v) => setState(() => _dateColumn = v!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _descriptionColumn,
                decoration: const InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
                items: columnItems,
                onChanged: (v) => setState(() => _descriptionColumn = v!),
              ),
              const SizedBox(height: 12),
              SegmentedButton<_AmountMode>(
                segments: const [
                  ButtonSegment(
                      value: _AmountMode.signed,
                      label: Text('One signed amount')),
                  ButtonSegment(
                      value: _AmountMode.debitCredit,
                      label: Text('Separate debit/credit')),
                ],
                selected: {_amountMode},
                onSelectionChanged: (s) =>
                    setState(() => _amountMode = s.first),
              ),
              const SizedBox(height: 12),
              if (_amountMode == _AmountMode.signed)
                DropdownButtonFormField<int>(
                  initialValue: _amountColumn,
                  decoration: const InputDecoration(
                      labelText: 'Amount', border: OutlineInputBorder()),
                  items: columnItems,
                  onChanged: (v) => setState(() => _amountColumn = v!),
                )
              else
                Row(children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _debitColumn,
                      decoration: const InputDecoration(
                          labelText: 'Debit', border: OutlineInputBorder()),
                      items: columnItems,
                      onChanged: (v) => setState(() => _debitColumn = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _creditColumn,
                      decoration: const InputDecoration(
                          labelText: 'Credit', border: OutlineInputBorder()),
                      items: columnItems,
                      onChanged: (v) => setState(() => _creditColumn = v!),
                    ),
                  ),
                ]),
            ]),
          ),
        ),
        kSectionGap,
        FilledButton(
          onPressed: _accountId == null ? null : _goToReview,
          child: const Text('Preview'),
        ),
      ],
    );
  }

  void _goToReview() {
    final parsed = parseImportRows(widget.rawRows, _mapping);
    if (parsed.isEmpty) {
      warnNotSaved(context,
          'nothing could be parsed with those columns — check the mapping');
      return;
    }
    setState(() {
      _parsed = parsed;
      _step = 1;
    });
  }

  Widget _reviewStep(BuildContext context, int profileId) {
    final repo = ref.read(repositoryProvider);
    return FutureBuilder<List<({ParsedImportRow row, bool isDuplicate})>>(
      future: _reviewed != null
          ? Future.value(_reviewed)
          : repo
              .previewImport(
                  profileId: profileId,
                  accountId: _accountId!,
                  rows: _parsed!)
              .then((r) {
              _reviewed = r;
              _included = {
                for (var i = 0; i < r.length; i++)
                  if (!r[i].isDuplicate) i,
              };
              return r;
            }),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final rows = snap.data!;
        final includedCount = _included.length;
        final includedTotal = [
          for (final i in _included) rows[i].row.amountCents
        ].fold(0, (s, c) => s + c);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: kPagePadding,
                itemCount: rows.length,
                itemBuilder: (context, i) {
                  final entry = rows[i];
                  final included = _included.contains(i);
                  return CheckboxListTile(
                    value: included,
                    onChanged: (v) => setState(() {
                      if (v == true) {
                        _included.add(i);
                      } else {
                        _included.remove(i);
                      }
                    }),
                    title: Text(entry.row.description),
                    subtitle: Text(
                        '${_fmtDate(entry.row.date)}'
                        '${entry.isDuplicate ? ' • looks like a duplicate' : ''}'),
                    secondary: Text(
                      '${entry.row.amountCents < 0 ? '-' : '+'}'
                      '${fmtCents(entry.row.amountCents.abs())}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: entry.isDuplicate
                              ? Theme.of(context).colorScheme.error
                              : null),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: kPagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Also update this account\'s balance'),
                    subtitle: Text(
                        'Adds the net of the included rows '
                        '(${fmtCents(includedTotal)}) to the current '
                        'balance. Leave off if the balance is already '
                        'correct and you\'re just importing history.'),
                    value: _updateBalance,
                    onChanged: (v) => setState(() => _updateBalance = v),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _step = 0),
                        child: const Text('Back'),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: includedCount == 0 || _committing
                            ? null
                            : () => _commit(profileId, rows),
                        child: Text(_committing
                            ? 'Importing…'
                            : 'Import $includedCount '
                                '${includedCount == 1 ? 'transaction' : 'transactions'}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _commit(int profileId,
      List<({ParsedImportRow row, bool isDuplicate})> rows) async {
    setState(() => _committing = true);
    final repo = ref.read(repositoryProvider);
    try {
      final included = [for (final i in _included) rows[i].row];
      await repo.commitImport(
        profileId: profileId,
        accountId: _accountId!,
        sourceFilename: widget.sourceFilename,
        rows: included,
        updateAccountBalance: _updateBalance,
      );
      if (context.mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _committing = false);
    }
  }

  static String _fmtDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${ordinalDay(d.day)}, ${d.year}';
  }
}
