import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';

/// A full, searchable ledger across every month — the Budget screen only
/// ever shows one month at a time, so finding an older transaction meant
/// paging back one month at a stretch. This is the "find something" view;
/// Budget stays the "plan this month" view.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() =>
      _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String _search = '';
  EntryType? _typeFilter;
  String? _sourceFilter; // "account:3" or "card:2"

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: StreamBuilder<List<dynamic>>(
        stream: combineLatest<dynamic>([
          repo.watchAllEntries(profileId: profileId),
          repo.watchAccounts(profileId: profileId),
          repo.watchCards(profileId: profileId),
          repo.watchEntryTagNames(profileId: profileId),
          repo.watchSplitsByEntry(profileId: profileId),
        ]),
        builder: (context, snap) {
          if (!snap.hasData) return const SizedBox.shrink();
          final entries = snap.data![0] as List<BudgetEntry>;
          final accounts = snap.data![1] as List<Account>;
          final cards = snap.data![2] as List<CreditCard>;
          final tagsByEntry = snap.data![3] as Map<int, List<String>>;
          final splitsByEntry =
              snap.data![4] as Map<int, List<TransactionSplit>>;

          final search = _search.trim().toLowerCase();
          final visible = entries.where((e) {
            if (_typeFilter != null && e.type != _typeFilter) return false;
            if (_sourceFilter != null) {
              final parts = _sourceFilter!.split(':');
              final id = int.parse(parts[1]);
              final matches = parts[0] == 'account'
                  ? e.accountId == id
                  : e.cardId == id;
              if (!matches) return false;
            }
            if (search.isEmpty) return true;
            return e.category.toLowerCase().contains(search) ||
                (e.description?.toLowerCase().contains(search) ?? false) ||
                (e.payee?.toLowerCase().contains(search) ?? false);
          }).toList();

          String? sourceLabel(BudgetEntry e) {
            if (e.accountId != null) {
              return accounts.where((a) => a.id == e.accountId).firstOrNull?.name;
            }
            if (e.cardId != null) {
              return cards.where((c) => c.id == e.cardId).firstOrNull?.name;
            }
            return null;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText:
                              'Search description, payee or category',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() => _search = v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SegmentedButton<EntryType?>(
                      segments: const [
                        ButtonSegment(value: null, label: Text('All')),
                        ButtonSegment(
                            value: EntryType.income, label: Text('Income')),
                        ButtonSegment(
                            value: EntryType.expense, label: Text('Expense')),
                      ],
                      selected: {_typeFilter},
                      onSelectionChanged: (s) =>
                          setState(() => _typeFilter = s.first),
                    ),
                    if (accounts.isNotEmpty || cards.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      DropdownButton<String?>(
                        value: _sourceFilter,
                        hint: const Text('Any account'),
                        items: [
                          const DropdownMenuItem(
                              value: null, child: Text('Any account')),
                          for (final a in accounts)
                            DropdownMenuItem(
                                value: 'account:${a.id}', child: Text(a.name)),
                          for (final c in cards)
                            DropdownMenuItem(
                                value: 'card:${c.id}', child: Text(c.name)),
                        ],
                        onChanged: (v) => setState(() => _sourceFilter = v),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: visible.isEmpty
                    ? const EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: 'No transactions found',
                        message:
                            'Try a different search or clear the filters.',
                      )
                    : ListView(
                        padding: kPagePadding,
                        children: [
                          Card(
                            child: Column(
                              children: [
                                for (final e in visible)
                                  _row(
                                    context,
                                    e,
                                    tagsByEntry[e.id] ?? [],
                                    splitsByEntry[e.id] ?? [],
                                    sourceLabel(e),
                                    scheme,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _row(
    BuildContext context,
    BudgetEntry e,
    List<String> tags,
    List<TransactionSplit> splits,
    String? sourceLabel,
    ColorScheme scheme,
  ) {
    return ListTile(
      leading: Icon(
        e.type == EntryType.income ? Icons.arrow_downward : Icons.arrow_upward,
        color: e.type == EntryType.income ? scheme.primary : scheme.error,
      ),
      title: Text(e.description ?? e.category),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${splits.isEmpty ? e.category : 'Split'}'
              '${e.payee != null ? ' • ${e.payee}' : ''}'
              '${sourceLabel != null ? ' • $sourceLabel' : ''} • '
              '${_fmtDate(e.date)}'),
          if (tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 6,
                children: [
                  for (final tag in tags)
                    Pill(tag, color: categoryColor(context, tag), fontSize: 11),
                ],
              ),
            ),
        ],
      ),
      trailing: MoneyText(
        '${e.type == EntryType.income ? '+' : '-'}${fmtCents(e.amountCents)}',
        style: TextStyle(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w600,
          color: e.type == EntryType.income ? scheme.primary : null,
        ),
      ),
    );
  }

  static String _fmtDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${ordinalDay(d.day)}, ${d.year}';
  }
}
