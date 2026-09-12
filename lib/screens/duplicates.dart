import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';

/// Finds entries that look like accidental duplicates — same day, amount,
/// direction, description and account/card — and lets a person clear the
/// extras out. Grouping never deletes on its own: two identical purchases
/// on the same day happen, so every group is shown for a human to decide.
class DuplicatesScreen extends ConsumerStatefulWidget {
  const DuplicatesScreen({super.key});

  @override
  ConsumerState<DuplicatesScreen> createState() => _DuplicatesScreenState();
}

class _DuplicatesScreenState extends ConsumerState<DuplicatesScreen> {
  final Set<int> _selected = {};
  // Entries a default selection has already been applied to, so a later
  // rebuild (e.g. from an unrelated account/card change) never re-checks
  // a box the user just unchecked by hand.
  final Set<int> _defaulted = {};
  var _deleting = false;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Duplicate transactions')),
      body: StreamBuilder<List<dynamic>>(
        stream: combineLatest<dynamic>([
          repo.watchDuplicateGroups(profileId: profileId),
          repo.watchAccounts(profileId: profileId),
          repo.watchCards(profileId: profileId),
        ]),
        builder: (context, snap) {
          if (!snap.hasData) return const SizedBox.shrink();
          final groups = snap.data![0] as List<List<BudgetEntry>>;
          final accounts = snap.data![1] as List<Account>;
          final cards = snap.data![2] as List<CreditCard>;

          // Default selection: everything but the first (oldest) entry in
          // each group, so accepting the suggestion keeps one of each. Only
          // applied the first time an entry is seen, so it never overrides
          // a choice the user already made by hand.
          for (final g in groups) {
            for (var i = 0; i < g.length; i++) {
              if (_defaulted.add(g[i].id) && i > 0) {
                _selected.add(g[i].id);
              }
            }
          }
          final liveIds = {for (final g in groups) for (final e in g) e.id};
          _selected.retainAll(liveIds);
          _defaulted.retainAll(liveIds);

          if (groups.isEmpty) {
            return const EmptyState(
              icon: Icons.checklist_outlined,
              title: 'No duplicates found',
              message:
                  'Entries matching in day, amount, description and account '
                  'or card would show up here.',
            );
          }

          String? sourceLabel(BudgetEntry e) {
            if (e.accountId != null) {
              return accounts.where((a) => a.id == e.accountId).firstOrNull?.name;
            }
            if (e.cardId != null) {
              return cards.where((c) => c.id == e.cardId).firstOrNull?.name;
            }
            return null;
          }

          return ListView(
            padding: kPagePadding,
            children: [
              Text(
                '${groups.length} possible ${groups.length == 1 ? 'duplicate' : 'duplicates'} '
                'found. The oldest of each group is unchecked by default — '
                'review before deleting.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              kSectionGap,
              for (final group in groups)
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      for (final e in group)
                        CheckboxListTile(
                          value: _selected.contains(e.id),
                          onChanged: (v) => setState(() {
                            if (v == true) {
                              _selected.add(e.id);
                            } else {
                              _selected.remove(e.id);
                            }
                          }),
                          title: Text(e.description ?? e.category),
                          subtitle: Text('${_fmtDate(e.date)}'
                              '${sourceLabel(e) != null ? ' • ${sourceLabel(e)}' : ''}'),
                          secondary: MoneyText(
                            '${e.type == EntryType.income ? '+' : '-'}${fmtCents(e.amountCents)}',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600,
                              color: e.type == EntryType.income
                                  ? scheme.primary
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: _selected.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: _deleting ? null : () => _delete(profileId),
                  icon: const Icon(Icons.delete_outline),
                  label: Text(_deleting
                      ? 'Deleting…'
                      : 'Delete ${_selected.length} selected'),
                ),
              ),
            ),
    );
  }

  Future<void> _delete(int profileId) async {
    final count = _selected.length;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete these transactions?'),
        content: Text('$count ${count == 1 ? 'transaction' : 'transactions'} '
            'will be removed, and any balance they affected will be put '
            'back the way it was.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _deleting = true);
    final repo = ref.read(repositoryProvider);
    try {
      final ids = _selected.toList();
      await repo.deleteBudgetEntries(profileId: profileId, ids: ids);
      _selected.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('$count ${count == 1 ? 'transaction' : 'transactions'} deleted')));
      }
    } finally {
      if (mounted) setState(() => _deleting = false);
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
