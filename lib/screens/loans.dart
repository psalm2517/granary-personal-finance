import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';
import '../widgets/payment_dialog.dart';
import '../widgets/payoff_simulator.dart';
import '../widgets/payment_history.dart';
import '../util/payoff.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder<List<Loan>>(
            stream: repo.watchLoans(profileId: profileId),
            builder: (context, snap) {
              final loans = snap.data ?? [];
              if (loans.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FloatingActionButton.extended(
                  heroTag: 'loanPayment',
                  onPressed: () => _logPayment(context, ref, loans, null),
                  icon: const Icon(Icons.payments_outlined),
                  label: const Text('Log payment'),
                ),
              );
            },
          ),
          FloatingActionButton.extended(
            heroTag: 'addLoan',
            onPressed: () => _edit(context, ref, null),
            icon: const Icon(Icons.add),
            label: const Text('Add loan'),
          ),
        ],
      ),
      body: StreamBuilder<List<Loan>>(
        stream: repo.watchLoans(profileId: profileId),
        builder: (context, snap) {
          final loans = snap.data ?? [];
          if (loans.isEmpty) {
            return const EmptyState(
              icon: Icons.request_quote_outlined,
              title: 'No loans yet',
              message:
                  'Add a loan to track payoff progress and compare snowball '
                  'versus avalanche strategies.',
            );
          }
          return ListView(
            padding: kPagePadding,
            children: [
              ...[
                _PayoffCalculator(loans: loans),
                const SizedBox(height: 16),
                for (final l in loans)
                  Card(
                    child: ExpansionTile(
                      leading: const Icon(Icons.request_quote_outlined),
                      title: Text(l.name),
                      subtitle: LinearProgressIndicator(
                        value: l.originalAmountCents == 0
                            ? 0
                            : 1 - l.balanceCents / l.originalAmountCents,
                      ),
                      trailing: Text(
                        fmtCents(l.balanceCents),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      childrenPadding: const EdgeInsets.all(16),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailRow('Balance', fmtCents(l.balanceCents)),
                        DetailRow('Original', fmtCents(l.originalAmountCents)),
                        DetailRow('APR', '${l.apr.toStringAsFixed(2)}%'),
                        DetailRow(
                          'Monthly payment',
                          fmtCents(l.monthlyPaymentCents),
                        ),
                        PaymentHistory(
                          accountType: PaymentAccountType.loan,
                          accountId: l.id,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () =>
                                  _logPayment(context, ref, [l], l),
                              icon: const Icon(Icons.payments_outlined),
                              label: const Text('Pay'),
                            ),
                            FilledButton.tonalIcon(
                              onPressed: () => _whatIf(context, l),
                              icon: const Icon(Icons.query_stats),
                              label: const Text('What if?'),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () => _edit(context, ref, l),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Edit'),
                            ),
                            TextButton.icon(
                              onPressed: () => _delete(context, ref, l),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _whatIf(BuildContext context, Loan l) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.query_stats),
        title: Text('What if — ${l.name}'),
        content: SizedBox(
          width: 640,
          child: SingleChildScrollView(
            child: PayoffSimulator(
              name: l.name,
              balanceCents: l.balanceCents,
              apr: l.apr,
              basePaymentCents: l.monthlyPaymentCents,
            ),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _logPayment(
    BuildContext context,
    WidgetRef ref,
    List<Loan> loans,
    Loan? preselect,
  ) async {
    final accounts = [
      for (final l in loans)
        PayableAccount(
          type: PaymentAccountType.loan,
          id: l.id,
          name: l.name,
          balanceCents: l.balanceCents,
          suggestedCents: l.monthlyPaymentCents > 0
              ? l.monthlyPaymentCents
              : null,
        ),
    ];
    final logged = await showQuickPaymentDialog(
      context,
      ref,
      accounts: accounts,
      preselected: preselect == null
          ? null
          : accounts.firstWhere((a) => a.id == preselect.id),
    );
    if (logged && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment logged and balance updated')),
      );
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Loan l) async {
    final profileId = ref.read(activeProfileProvider)!.id;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${l.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          DangerButton(
            label: 'Delete',
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref
          .read(repositoryProvider)
          .deleteLoan(profileId: profileId, id: l.id);
    }
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    Loan? existing,
  ) async {
    final profileId = ref.read(activeProfileProvider)!.id;
    final name = TextEditingController(text: existing?.name);
    final balance = TextEditingController(
      text: existing == null ? '' : (existing.balanceCents / 100).toString(),
    );
    final original = TextEditingController(
      text: existing == null
          ? ''
          : (existing.originalAmountCents / 100).toString(),
    );
    final apr = TextEditingController(text: existing?.apr.toString() ?? '');
    final payment = TextEditingController(
      text: existing == null
          ? ''
          : (existing.monthlyPaymentCents / 100).toString(),
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => SubmitOnEnter(
        onSubmit: () => Navigator.pop(context, true),
        child: AlertDialog(
          title: Text(existing == null ? 'Add loan' : 'Edit loan'),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DialogField(name, 'Name', autofocus: true),
                DialogField(balance, 'Balance (\$)'),
                DialogField(original, 'Original amount (\$)'),
                DialogField(apr, 'APR (%)'),
                DialogField(payment, 'Monthly payment (\$)'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (saved != true) return;
    if (name.text.trim().isEmpty) {
      if (context.mounted) warnNotSaved(context, 'the loan needs a name');
      return;
    }
    await ref
        .read(repositoryProvider)
        .upsertLoan(
          LoansCompanion(
            id: existing == null ? const Value.absent() : Value(existing.id),
            profileId: Value(profileId),
            name: Value(name.text.trim()),
            balanceCents: Value(parseDollarsToCents(balance.text) ?? 0),
            originalAmountCents: Value(parseDollarsToCents(original.text) ?? 0),
            apr: Value(double.tryParse(apr.text) ?? 0),
            monthlyPaymentCents: Value(parseDollarsToCents(payment.text) ?? 0),
          ),
        );
  }
}

/// Snowball (smallest balance first) vs avalanche (highest APR first).
class _PayoffCalculator extends StatefulWidget {
  const _PayoffCalculator({required this.loans});
  final List<Loan> loans;

  @override
  State<_PayoffCalculator> createState() => _PayoffCalculatorState();
}

class _PayoffCalculatorState extends State<_PayoffCalculator> {
  final _extra = TextEditingController(text: '0');

  List<DebtInput> get _debts => [
    for (final l in widget.loans)
      DebtInput(
        id: l.id,
        balanceCents: l.balanceCents,
        apr: l.apr,
        minimumPaymentCents: l.monthlyPaymentCents,
      ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final extraCents = parseDollarsToCents(_extra.text) ?? 0;
    final debts = _debts;
    final live = debts.where((d) => d.balanceCents > 0).length;

    final snowball = simulateMultiDebtPayoff(
      debts: debts,
      strategy: PayoffStrategy.snowball,
      extraCents: extraCents,
    );
    final avalanche = simulateMultiDebtPayoff(
      debts: debts,
      strategy: PayoffStrategy.avalanche,
      extraCents: extraCents,
    );

    final saving = (snowball != null && avalanche != null)
        ? snowball.totalInterestCents - avalanche.totalInterestCents
        : 0;
    final monthsSaved = (snowball != null && avalanche != null)
        ? snowball.months - avalanche.months
        : 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              'Payoff calculator',
              icon: Icons.calculate_outlined,
              info: InfoButton(
                title: 'Snowball vs avalanche',
                body: [
                  'Two ways to order your debts. Both assume you keep '
                      'paying every minimum, and put any spare money '
                      'toward one debt at a time.',
                  'Snowball targets the smallest balance first, so '
                      'individual debts disappear sooner. Avalanche '
                      'targets the highest APR first, which always costs '
                      'the least interest.',
                  'They only differ when there is a real choice to make: '
                      'spare money, and more than one debt left to aim it '
                      'at. With a single debt, or with two debts and no '
                      'extra payment, both plans do exactly the same thing '
                      '— so Granary says they match rather than inventing '
                      'a difference.',
                  'As each debt clears, its minimum rolls onto the next '
                      'one, which is why both plans speed up over time.',
                ],
              ),
            ),
            SizedBox(
              width: 260,
              child: TextField(
                controller: _extra,
                decoration: const InputDecoration(
                  labelText: 'Extra per month (\$)',
                  helperText: 'Spare money beyond the minimums',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _strategy(
                    context,
                    'Snowball',
                    'Smallest balance first',
                    snowball,
                    scheme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _strategy(
                    context,
                    'Avalanche',
                    'Highest APR first',
                    avalanche,
                    scheme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _verdict(
              context,
              scheme,
              live: live,
              extraCents: extraCents,
              saving: saving,
              monthsSaved: monthsSaved,
              bothWork: snowball != null && avalanche != null,
            ),
          ],
        ),
      ),
    );
  }

  /// Explains the comparison in words, including *why* the two plans match
  /// when they do — otherwise "about the same" reads like a broken result.
  Widget _verdict(
    BuildContext context,
    ColorScheme scheme, {
    required int live,
    required int extraCents,
    required int saving,
    required int monthsSaved,
    required bool bothWork,
  }) {
    if (!bothWork) {
      return _note(
        context,
        Icons.warning_amber_outlined,
        'These minimums do not cover the interest, so the debt never '
        'clears. Add an extra amount above to find what does.',
        scheme.error,
      );
    }
    if (live < 2) {
      return _note(
        context,
        Icons.info_outline,
        'With one debt there is no order to choose, so both plans are the '
        'same. They start to differ once you have two or more.',
        scheme.onSurfaceVariant,
      );
    }
    if (saving > 0) {
      return _note(
        context,
        Icons.trending_down,
        'Avalanche saves ${fmtCents(saving)} in interest'
        '${monthsSaved > 0 ? ' and finishes $monthsSaved '
                  '${monthsSaved == 1 ? 'month' : 'months'} sooner' : ''}. '
        'Snowball clears individual debts faster, which some people '
        'find easier to stick with.',
        scheme.primary,
      );
    }
    if (extraCents == 0) {
      return _note(
        context,
        Icons.info_outline,
        'With no extra payment there is nothing to redirect, so both plans '
        'are identical. Add an extra amount above to see them diverge.',
        scheme.onSurfaceVariant,
      );
    }
    return _note(
      context,
      Icons.info_outline,
      'These debts happen to cost the same either way — the ordering makes '
      'no difference at this extra amount. Pick whichever you find '
      'easier to keep up.',
      scheme.onSurfaceVariant,
    );
  }

  Widget _note(BuildContext context, IconData icon, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: color),
          ),
        ),
      ],
    );
  }

  Widget _strategy(
    BuildContext context,
    String name,
    String detail,
    MultiDebtProjection? result,
    ColorScheme scheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: Theme.of(context).textTheme.titleSmall),
          Text(detail, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          if (result == null)
            Text(
              'Never pays off at these payments',
              style: TextStyle(color: scheme.error),
            )
          else ...[
            Text(
              '${result.months ~/ 12}y ${result.months % 12}m to debt-free',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '${fmtCents(result.totalInterestCents)} total interest',
              style: TextStyle(color: scheme.error),
            ),
          ],
        ],
      ),
    );
  }
}
