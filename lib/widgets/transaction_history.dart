import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../util/money.dart';
import 'common.dart';

IconData _activityIcon(AccountActivityKind kind) => switch (kind) {
      AccountActivityKind.income => Icons.arrow_downward,
      AccountActivityKind.expense => Icons.arrow_upward,
      AccountActivityKind.transferIn => Icons.call_received,
      AccountActivityKind.transferOut => Icons.call_made,
    };

/// Recent activity for one account or card — everything that has actually
/// moved its balance, newest first. Used by both the Accounts and Cards
/// screens, so it takes the already-built stream rather than an id, since
/// an account's history and a card's history come from different queries.
class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key, required this.stream, this.limit = 8});

  final Stream<List<AccountActivity>> stream;
  final int limit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return StreamBuilder<List<AccountActivity>>(
      stream: stream,
      builder: (context, snap) {
        final activity = snap.data ?? [];
        if (activity.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('No transactions linked to this yet.',
                style: TextStyle(color: scheme.onSurfaceVariant)),
          );
        }
        final shown = activity.take(limit).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Recent activity',
                style: Theme.of(context).textTheme.labelMedium),
            for (final a in shown)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(_activityIcon(a.kind),
                    size: 18,
                    color: a.amountCents < 0 ? scheme.error : scheme.primary),
                title: Text(a.label),
                subtitle: Text(_fmtDate(a.date)),
                trailing: MoneyText(
                  '${a.amountCents < 0 ? '-' : '+'}'
                  '${fmtCents(a.amountCents.abs())}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                    color: a.amountCents < 0 ? scheme.error : scheme.primary,
                  ),
                ),
              ),
            if (activity.length > shown.length)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                    '${activity.length - shown.length} older not shown',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant)),
              ),
          ],
        );
      },
    );
  }

  static String _fmtDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${ordinalDay(d.day)}';
  }
}
