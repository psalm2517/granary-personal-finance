import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';
import '../widgets/payment_dialog.dart';
import '../widgets/payoff_simulator.dart';
import '../widgets/payment_history.dart';
import '../widgets/transaction_history.dart';
import '../util/payoff.dart';

class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder<List<CreditCard>>(
            stream: repo.watchCards(profileId: profileId),
            builder: (context, snap) {
              final cards = snap.data ?? [];
              if (cards.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FloatingActionButton.extended(
                  heroTag: 'cardPayment',
                  onPressed: () => _logPayment(context, ref, cards, null),
                  icon: const Icon(Icons.payments_outlined),
                  label: const Text('Log payment'),
                ),
              );
            },
          ),
          FloatingActionButton.extended(
            heroTag: 'addCard',
            onPressed: () => _edit(context, ref, null),
            icon: const Icon(Icons.add),
            label: const Text('Add card'),
          ),
        ],
      ),
      body: StreamBuilder<List<CreditCard>>(
        stream: repo.watchCards(profileId: profileId),
        builder: (context, snap) {
          final cards = snap.data ?? [];
          if (cards.isEmpty) {
            return const EmptyState(
              icon: Icons.credit_card_outlined,
              title: 'No credit cards yet',
              message:
                  'Add a card to track its balance, utilization and fees.',
            );
          }
          return ListView(
            padding: kPagePadding,
            children: [
              const SectionHeader('Cards',
                  icon: Icons.credit_card_outlined,
                  info: InfoButton(
                    title: 'Statement cycles',
                    body: [
                      'A card has two dates each month: the statement closing '
                          'day, and the payment due day roughly 21-25 days '
                          'later.',
                      'Granary uses these purely for timing — reminders and '
                          'the "closes in N days" chip. Balance and '
                          'utilization always reflect what you owe right now.',
                      'Set both days when you edit a card and Granary works '
                          'out the next occurrence of each automatically, '
                          'including short months.',
                    ],
                  )),
              for (final c in cards)
                Card(
                  child: ExpansionTile(
                    leading: const Icon(Icons.credit_card),
                    title: Text(c.name),
                    subtitle: Text(
                        '${fmtCents(c.balanceCents)} of '
                        '${fmtCents(c.creditLimitCents)}'),
                    trailing: _cycleChip(context, c),
                    childrenPadding: const EdgeInsets.all(16),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailRow('Balance', fmtCents(c.balanceCents)),
                      DetailRow('Limit', fmtCents(c.creditLimitCents)),
                      DetailRow(
                          'Utilization',
                          c.creditLimitCents == 0
                              ? '—'
                              : '${(HomebaseRepository.utilizationOf(c) * 100).toStringAsFixed(1)}%'),
                      if (c.minimumPaymentDueCents != null)
                        DetailRow('Minimum due',
                            fmtCents(c.minimumPaymentDueCents!)),
                      DetailRow('APR', '${c.apr.toStringAsFixed(2)}%'),
                      DetailRow(
                          'Annual fee',
                          c.annualFeeCents == 0
                              ? 'none'
                              : '${fmtCents(c.annualFeeCents)}'
                                  '${c.annualFeeDate == null ? '' : ' — next '
                                      '${_fmtDate(HomebaseRepository.nextAnnualFeeDate(c)!)}'}'),
                      DetailRow('Monthly fee', fmtCents(c.monthlyFeeCents)),
                      DetailRow(
                          'Statement closes',
                          c.statementCloseDay == null
                              ? 'not set'
                              : _fmtDate(HomebaseRepository.cycleFor(c)
                                  .statementCloses!)),
                      DetailRow(
                          'Payment due',
                          c.paymentDueDay == null
                              ? 'not set'
                              : _fmtDate(
                                  HomebaseRepository.cycleFor(c).paymentDue!)),
                      TransactionHistory(
                          stream: repo.watchCardHistory(
                              profileId: profileId, cardId: c.id)),
                      PaymentHistory(
                          accountType: PaymentAccountType.card,
                          accountId: c.id),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          TextButton.icon(
                              onPressed: () =>
                                  _logPayment(context, ref, [c], c),
                              icon: const Icon(Icons.payments_outlined),
                              label: const Text('Pay')),
                          FilledButton.tonalIcon(
                              onPressed: () => _whatIf(context, c),
                              icon: const Icon(Icons.query_stats),
                              label: const Text('What if?')),
                          const SizedBox(width: 8),
                          TextButton.icon(
                              onPressed: () => _edit(context, ref, c),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Edit')),
                          TextButton.icon(
                              onPressed: () => _delete(context, ref, c),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Delete')),
                        ],
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

  Future<void> _whatIf(BuildContext context, CreditCard c) async {
    // A real minimum from the statement beats our estimate.
    final minimum = c.minimumPaymentDueCents ??
        estimateCardMinimumPayment(balanceCents: c.balanceCents, apr: c.apr);
    final usingEstimate = c.minimumPaymentDueCents == null;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.query_stats),
        title: Text('What if — ${c.name}'),
        content: SizedBox(
          width: 640,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  usingEstimate
                      ? 'No minimum payment is set for this card, so this '
                          'starts from a typical one: 1% of the balance plus '
                          'interest, at least \$25. Add the real figure when '
                          'you edit the card.'
                      : 'Starting from the minimum payment on your statement.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 12),
              PayoffSimulator(
                name: c.name,
                balanceCents: c.balanceCents,
                apr: c.apr,
                basePaymentCents: minimum,
                basePaymentLabel: usingEstimate
                    ? 'Estimated minimum payment'
                    : 'Minimum payment due',
              ),
            ]),
          ),
        ),
        actions: [
          FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done')),
        ],
      ),
    );
  }

  Future<void> _logPayment(BuildContext context, WidgetRef ref,
      List<CreditCard> cards, CreditCard? preselect) async {
    final accounts = [
      for (final c in cards)
        PayableAccount(
            type: PaymentAccountType.card,
            id: c.id,
            name: c.name,
            balanceCents: c.balanceCents),
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Payment logged and balance updated')));
    }
  }

  Future<void> _delete(
      BuildContext context, WidgetRef ref, CreditCard c) async {
    final profileId = ref.read(activeProfileProvider)!.id;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${c.name}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          DangerButton(
              label: 'Delete',
              onPressed: () => Navigator.pop(context, true)),
        ],
      ),
    );
    if (ok == true) {
      await ref
          .read(repositoryProvider)
          .deleteCard(profileId: profileId, id: c.id);
    }
  }

  Future<void> _edit(
      BuildContext context, WidgetRef ref, CreditCard? existing) async {
    final profileId = ref.read(activeProfileProvider)!.id;
    final name = TextEditingController(text: existing?.name);
    final balance = TextEditingController(
        text: existing == null ? '' : (existing.balanceCents / 100).toString());
    final limit = TextEditingController(
        text: existing == null
            ? ''
            : (existing.creditLimitCents / 100).toString());
    final apr =
        TextEditingController(text: existing?.apr.toString() ?? '');
    final annualFee = TextEditingController(
        text:
            existing == null ? '' : (existing.annualFeeCents / 100).toString());
    final monthlyFee = TextEditingController(
        text: existing == null
            ? ''
            : (existing.monthlyFeeCents / 100).toString());
    final statementDay = TextEditingController(
        text: existing?.statementCloseDay?.toString() ?? '');
    final minimumDue = TextEditingController(
        text: existing?.minimumPaymentDueCents == null
            ? ''
            : (existing!.minimumPaymentDueCents! / 100).toString());
    DateTime? annualFeeDate = existing?.annualFeeDate;
    final paymentDueDay =
        TextEditingController(text: existing?.paymentDueDay?.toString() ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => SubmitOnEnter(
        onSubmit: () => Navigator.pop(context, true),
        child: AlertDialog(
        title: Text(existing == null ? 'Add card' : 'Edit card'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogField(name, 'Name', autofocus: true),
              DialogField(balance, 'Balance (\$)',
                  helper: 'What you owe right now'),
              DialogField(limit, 'Credit limit (\$)'),
              DialogField(apr, 'APR (%)'),
              DialogField(annualFee, 'Annual fee (\$)'),
              // Paired with the amount above so the reminder knows when.
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.event_repeat, size: 16),
                    label: Text(annualFeeDate == null
                        ? 'Annual fee date (optional)'
                        : 'Annual fee charged '
                            '${_fmtDate(annualFeeDate!)}'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: annualFeeDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040),
                        helpText: 'When does the annual fee hit?',
                      );
                      if (picked != null) {
                        setLocal(() => annualFeeDate = picked);
                      }
                    },
                  ),
                ),
              ),
              if (annualFeeDate != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.clear, size: 14),
                    label: const Text('Clear fee date'),
                    onPressed: () => setLocal(() => annualFeeDate = null),
                  ),
                ),
              DialogField(monthlyFee, 'Monthly fee (\$)'),
              DialogField(statementDay, 'Statement closing day (optional)',
                  helper: 'Day of the month your statement closes'),
              DialogField(minimumDue, 'Minimum payment due (optional)',
                  helper: 'From your statement. Used by the What if '
                      'simulator instead of an estimate'),
              DialogField(paymentDueDay, 'Payment due day (optional)',
                  helper: 'Usually 21-25 days after the statement closes'),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save')),
        ],
      ),
      ),
      ),
    );
    if (saved != true) return;
    if (name.text.trim().isEmpty) {
      if (context.mounted) warnNotSaved(context, 'the card needs a name');
      return;
    }
    await ref.read(repositoryProvider).upsertCard(CreditCardsCompanion(
          id: existing == null ? const Value.absent() : Value(existing.id),
          profileId: Value(profileId),
          name: Value(name.text.trim()),
          balanceCents: Value(parseDollarsToCents(balance.text) ?? 0),
          creditLimitCents: Value(parseDollarsToCents(limit.text) ?? 0),
          apr: Value(double.tryParse(apr.text) ?? 0),
          annualFeeCents: Value(parseDollarsToCents(annualFee.text) ?? 0),
          monthlyFeeCents: Value(parseDollarsToCents(monthlyFee.text) ?? 0),
          statementCloseDay: Value(_parseDay(statementDay.text)),
          minimumPaymentDueCents:
              Value(parseDollarsToCents(minimumDue.text)),
          annualFeeDate: Value(annualFeeDate),
          paymentDueDay: Value(_parseDay(paymentDueDay.text)),
        ));
  }


  static int? _parseDay(String text) {
    final value = int.tryParse(text.trim());
    if (value == null) return null;
    return value.clamp(1, 31);
  }

  static String _fmtDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}';
  }

  /// Compact "closes in N days" / "due Mar 3" chip for the collapsed row.
  Widget _cycleChip(BuildContext context, CreditCard c) {
    final scheme = Theme.of(context).colorScheme;
    final cycle = HomebaseRepository.cycleFor(c);
    if (cycle.statementCloses == null && cycle.paymentDue == null) {
      return Text('${c.apr.toStringAsFixed(2)}% APR');
    }
    final days = cycle.daysToClose;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (cycle.statementCloses != null)
          Text(
            days == 0
                ? 'Statement closes today'
                : 'Closes in $days ${days == 1 ? 'day' : 'days'}',
            style: TextStyle(
                fontSize: 12,
                color: (days ?? 99) <= 3 ? scheme.error : scheme.primary),
          ),
        if (cycle.paymentDue != null)
          Text('Payment due ${_fmtDate(cycle.paymentDue!)}',
              style: TextStyle(
                  fontSize: 11,
                  color: scheme.onSurface.withValues(alpha: 0.7))),
      ],
    );
  }
}
