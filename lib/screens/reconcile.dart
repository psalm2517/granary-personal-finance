import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';

/// Compares an account's tracked balance against a real statement, and — if
/// they don't match — gives a checklist of everything that happened since
/// the last reconciliation to audit against the statement by hand. This
/// isn't a double-entry ledger, so it can't derive which line is wrong on
/// its own; it can only help a person spot it faster.
class ReconcileScreen extends ConsumerStatefulWidget {
  const ReconcileScreen({super.key, required this.accountId});

  final int accountId;

  @override
  ConsumerState<ReconcileScreen> createState() => _ReconcileScreenState();
}

class _ReconcileScreenState extends ConsumerState<ReconcileScreen> {
  final _statementBalance = TextEditingController();
  DateTime _statementDate = DateTime.now();
  int? _statementBalanceCents;
  final Set<int> _checked = {};

  @override
  void dispose() {
    _statementBalance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    final scheme = Theme.of(context).colorScheme;

    return StreamBuilder<List<Account>>(
      stream: repo.watchAccounts(profileId: profileId),
      builder: (context, snap) {
        final account = (snap.data ?? [])
            .where((a) => a.id == widget.accountId)
            .firstOrNull;
        if (account == null) {
          return const Scaffold(body: SizedBox.shrink());
        }

        return Scaffold(
          appBar: AppBar(title: Text('Reconcile ${account.name}')),
          body: ListView(
            padding: kPagePadding,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tracked balance'),
                          MoneyText(fmtCents(account.balanceCents),
                              style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        account.reconciledAt == null
                            ? 'Never reconciled'
                            : 'Last reconciled ${_fmtDate(account.reconciledAt!)} '
                                'to ${fmtCents(account.reconciledBalanceCents!)}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
              kSectionGap,
              SectionHeader('Statement', icon: Icons.receipt_long_outlined),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _statementBalance,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Statement ending balance',
                            prefixText: '\$',
                            border: OutlineInputBorder()),
                        onChanged: (_) => setState(() {
                          _statementBalanceCents = null;
                        }),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text('As of ${_fmtDate(_statementDate)}'),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _statementDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                              helpText: 'Statement date',
                            );
                            if (picked != null) {
                              setState(() {
                                _statementDate = picked;
                                _statementBalanceCents = null;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () {
                          final cents =
                              parseDollarsToCents(_statementBalance.text);
                          if (cents == null) {
                            warnNotSaved(context,
                                'enter the statement balance first');
                            return;
                          }
                          setState(() => _statementBalanceCents = cents);
                        },
                        child: const Text('Compare'),
                      ),
                    ],
                  ),
                ),
              ),
              if (_statementBalanceCents != null) ...[
                kSectionGap,
                _comparisonResult(
                    context, repo, profileId, account, _statementBalanceCents!),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _comparisonResult(BuildContext context, HomebaseRepository repo,
      int profileId, Account account, int statementBalanceCents) {
    final scheme = Theme.of(context).colorScheme;
    final diff = statementBalanceCents - account.balanceCents;

    if (diff == 0) {
      return Card(
        color: scheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: scheme.onPrimaryContainer),
                  const SizedBox(width: 8),
                  Text('Balances match',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: scheme.onPrimaryContainer)),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  await repo.reconcileAccount(
                    profileId: profileId,
                    accountId: account.id,
                    statementBalanceCents: statementBalanceCents,
                    statementDate: _statementDate,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reconciled')));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Mark reconciled'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: scheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: scheme.onErrorContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Off by ${fmtCents(diff.abs())} — the statement shows '
                    '${diff > 0 ? 'more' : 'less'} than the tracked balance.',
                    style: TextStyle(color: scheme.onErrorContainer),
                  ),
                ),
              ],
            ),
          ),
        ),
        kSectionGap,
        Text(
          'Activity since '
          '${account.reconciledAt == null ? 'the start' : _fmtDate(account.reconciledAt!)}'
          ' — check each one off against the statement:',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        StreamBuilder<List<AccountActivity>>(
          stream: repo.watchAccountHistory(
              profileId: profileId, accountId: account.id),
          builder: (context, snap) {
            final all = snap.data ?? [];
            final since = account.reconciledAt;
            final activity = [
              for (final a in all)
                if ((since == null || !a.date.isBefore(since)) &&
                    !a.date.isAfter(_statementDate))
                  a,
            ];
            if (activity.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('No activity in that window.'),
              );
            }
            return Card(
              child: Column(
                children: [
                  for (var i = 0; i < activity.length; i++)
                    CheckboxListTile(
                      value: _checked.contains(i),
                      onChanged: (v) => setState(() {
                        if (v == true) {
                          _checked.add(i);
                        } else {
                          _checked.remove(i);
                        }
                      }),
                      title: Text(activity[i].label),
                      subtitle: Text(_fmtDate(activity[i].date)),
                      secondary: MoneyText(
                        '${activity[i].amountCents >= 0 ? '+' : '-'}'
                        '${fmtCents(activity[i].amountCents.abs())}',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                          color: activity[i].amountCents >= 0
                              ? scheme.primary
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        kSectionGap,
        OutlinedButton(
          onPressed: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Mark reconciled anyway?'),
                content: Text(
                    'The tracked balance is still off by ${fmtCents(diff.abs())}. '
                    'Marking reconciled records the statement balance as '
                    'correct without explaining the difference.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Mark reconciled anyway')),
                ],
              ),
            );
            if (ok != true) return;
            await repo.reconcileAccount(
              profileId: profileId,
              accountId: account.id,
              statementBalanceCents: statementBalanceCents,
              statementDate: _statementDate,
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Reconciled')));
              Navigator.pop(context);
            }
          },
          child: const Text('Mark reconciled anyway'),
        ),
      ],
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
