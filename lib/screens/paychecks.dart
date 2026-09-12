import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';

class PaychecksScreen extends ConsumerStatefulWidget {
  const PaychecksScreen({super.key});

  @override
  ConsumerState<PaychecksScreen> createState() => _PaychecksScreenState();
}

class _PaychecksScreenState extends ConsumerState<PaychecksScreen> {
  @override
  void initState() {
    super.initState();
    // Generate paychecks 90 days out, then mark the ones whose payday has
    // arrived as received.
    Future.microtask(() async {
      final now = DateTime.now();
      final repo = ref.read(repositoryProvider);
      final profileId = ref.read(activeProfileProvider)!.id;
      await repo.generateDuePaychecks(
        profileId: profileId,
        until: now.add(HomebaseRepository.paycheckHorizon),
      );
      await repo.materializeReceivedPaychecks(profileId: profileId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editSchedule(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Add schedule'),
      ),
      body: SingleChildScrollView(
        padding: kPagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader('Schedules',
                icon: Icons.repeat,
                info: InfoButton(
                  title: 'Paycheck schedules',
                  body: [
                    'Set a schedule once and Clearly generates the '
                        'individual paychecks for you, 90 days ahead, so '
                        'you never type a payday date twice.',
                    'Weekly is every 7 days and bi-weekly every 14 days, '
                        'which means 52 and 26 checks a year — bi-weekly '
                        'gives you two three-check months annually.',
                    'Semi-monthly is twice a month on fixed days such as the '
                        '1st and 15th, so it is always 24 checks a year. It '
                        'looks similar to bi-weekly but is not the same.',
                    'Enter the amount you actually take home, after taxes and '
                        'deductions.',
                  ],
                )),
            StreamBuilder<List<PaycheckSchedule>>(
              stream: repo.watchSchedules(profileId: profileId),
              builder: (context, snap) {
                final schedules = snap.data ?? [];
                if (schedules.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: EmptyState(
                        icon: Icons.repeat,
                        title: 'No schedules yet',
                        message:
                            'Add a weekly, bi-weekly, semi-monthly or monthly '
                            'schedule and paychecks generate automatically.',
                      ),
                    ),
                  );
                }
                return Card(
                  child: Column(children: [
                    for (final s in schedules)
                      ListTile(
                        leading: Icon(Icons.repeat,
                            color: s.active
                                ? Theme.of(context).colorScheme.primary
                                : null),
                        title: Text(s.name),
                        subtitle: Text(
                            '${_freqLabel(s.frequency)} • ${fmtCents(s.amountCents)} after tax'),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              onPressed: () => _editSchedule(context, s)),
                          IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18),
                              onPressed: () => repo.deleteSchedule(
                                  profileId: profileId, id: s.id)),
                        ]),
                      ),
                  ]),
                );
              },
            ),
            const SizedBox(height: 24),
            const SectionHeader('Paychecks',
                icon: Icons.payments_outlined,
                info: InfoButton(
                  title: 'Allocating a paycheck',
                  body: [
                    'Open a check and assign parts of it to where the money '
                        'is going — rent, savings, a card payment. This is '
                        'envelope budgeting at the paycheck level rather '
                        'than the month level.',
                    'The card shows what is still unassigned, and warns you '
                        'in red if your allocations add up to more than the '
                        'check is worth.',
                    'A paycheck marks itself received once its payday '
                        'arrives, and an income entry appears on the Budget '
                        'screen automatically — nothing to click.',
                    'Override it only if reality differs: mark it not '
                        'received if a check was delayed or never came. Your '
                        'override sticks and is not undone on the next '
                        'launch.',
                    'Use Bonus to add a one-off amount to a single check '
                        'without changing the schedule.',
                  ],
                )),
            StreamBuilder<List<Paycheck>>(
              stream: repo.watchPaychecks(profileId: profileId),
              builder: (context, snap) {
                final checks = snap.data ?? [];
                if (checks.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: EmptyState(
                        icon: Icons.payments_outlined,
                        title: 'No paychecks yet',
                        message:
                            'Paychecks appear here once you add a schedule.',
                      ),
                    ),
                  );
                }
                return Column(children: [
                  for (final p in checks) _PaycheckCard(paycheck: p),
                ]);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _freqLabel(PayFrequency f) => switch (f) {
        PayFrequency.weekly => 'Weekly',
        PayFrequency.biweekly => 'Bi-weekly',
        PayFrequency.semimonthly => 'Semi-monthly (1st & 15th style)',
        PayFrequency.monthly => 'Monthly',
      };

  Future<void> _editSchedule(
      BuildContext context, PaycheckSchedule? existing) async {
    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;
    final name = TextEditingController(text: existing?.name);
    final amount = TextEditingController(
        text: existing == null ? '' : (existing.amountCents / 100).toString());
    var frequency = existing?.frequency ?? PayFrequency.biweekly;
    var anchor = existing?.anchorDate ?? DateTime.now();

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SubmitOnEnter(
          onSubmit: () => Navigator.pop(context, true),
          child: AlertDialog(
          title: Text(existing == null ? 'Add schedule' : 'Edit schedule'),
          content: SizedBox(
            width: 360,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              DialogField(name, 'Name (e.g. Day job)', autofocus: true),
              DialogField(amount, 'After-tax amount (\$)'),
              DropdownButtonFormField<PayFrequency>(
                initialValue: frequency,
                decoration: const InputDecoration(
                    labelText: 'Frequency', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(
                      value: PayFrequency.weekly, child: Text('Weekly')),
                  DropdownMenuItem(
                      value: PayFrequency.biweekly, child: Text('Bi-weekly')),
                  DropdownMenuItem(
                      value: PayFrequency.semimonthly,
                      child: Text('Semi-monthly (1st & 15th)')),
                  DropdownMenuItem(
                      value: PayFrequency.monthly, child: Text('Monthly')),
                ],
                onChanged: (v) => setState(() => frequency = v!),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(
                    'Next payday: ${anchor.year}-${anchor.month.toString().padLeft(2, '0')}-${anchor.day.toString().padLeft(2, '0')}'),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: anchor,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2040),
                  );
                  if (picked != null) setState(() => anchor = picked);
                },
              ),
            ]),
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
      if (context.mounted) warnNotSaved(context, 'the schedule needs a name');
      return;
    }
    final cents = parseDollarsToCents(amount.text);
    if (cents == null) {
      if (context.mounted) warnNotSaved(context, 'enter the take-home amount');
      return;
    }
    await repo.upsertSchedule(PaycheckSchedulesCompanion(
      id: existing == null ? const Value.absent() : Value(existing.id),
      profileId: Value(profileId),
      name: Value(name.text.trim()),
      frequency: Value(frequency),
      anchorDate: Value(DateTime(anchor.year, anchor.month, anchor.day)),
      amountCents: Value(cents),
      active: const Value(true),
    ));
    final now = DateTime.now();
    await repo.generateDuePaychecks(
        profileId: profileId,
          until: now.add(HomebaseRepository.paycheckHorizon));
  }
}

class _PaycheckCard extends ConsumerWidget {
  const _PaycheckCard({required this.paycheck});
  final Paycheck paycheck;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    final scheme = Theme.of(context).colorScheme;
    final total = paycheck.amountCents + paycheck.bonusCents;

    return Card(
      child: StreamBuilder<List<PaycheckAllocation>>(
        stream: repo.watchAllocations(
            profileId: profileId, paycheckId: paycheck.id),
        builder: (context, snap) {
          final allocations = snap.data ?? [];
          final allocated =
              allocations.fold(0, (s, a) => s + a.amountCents);
          final remaining = total - allocated;
          return ExpansionTile(
            leading: Icon(
                paycheck.received
                    ? Icons.check_circle
                    : Icons.schedule_outlined,
                color: paycheck.received ? scheme.primary : null),
            title: Text(
                '${paycheck.name} — ${paycheck.date.year}-${paycheck.date.month.toString().padLeft(2, '0')}-${paycheck.date.day.toString().padLeft(2, '0')}'),
            subtitle: Text(
              '${fmtCents(total)}${paycheck.bonusCents != 0 ? ' (incl. ${fmtCents(paycheck.bonusCents)} bonus)' : ''} • '
              '${remaining == 0 ? 'fully allocated' : remaining > 0 ? '${fmtCents(remaining)} unassigned' : '${fmtCents(-remaining)} OVER-allocated'}',
              style: TextStyle(
                  color: remaining < 0
                      ? scheme.error
                      : remaining == 0
                          ? scheme.primary
                          : null),
            ),
            childrenPadding: const EdgeInsets.all(16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final a in allocations)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(a.target),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(fmtCents(a.amountCents)),
                    IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        onPressed: () => repo.deleteAllocation(
                            profileId: profileId, id: a.id)),
                  ]),
                ),
              Row(children: [
                TextButton.icon(
                    onPressed: () => _addAllocation(context, ref),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Allocate')),
                TextButton.icon(
                    onPressed: () => _editBonus(context, ref),
                    icon: const Icon(Icons.star_outline, size: 18),
                    label: const Text('Bonus')),
                TextButton.icon(
                    onPressed: () => repo.upsertPaycheck(PaychecksCompanion(
                          id: Value(paycheck.id),
                          profileId: Value(profileId),
                          name: Value(paycheck.name),
                          date: Value(paycheck.date),
                          amountCents: Value(paycheck.amountCents),
                          bonusCents: Value(paycheck.bonusCents),
                          scheduleId: Value(paycheck.scheduleId),
                          received: Value(!paycheck.received),
                          // Flagged manual so automation leaves it alone.
                          receivedIsManual: const Value(true),
                        )),
                    icon: Icon(
                        paycheck.received
                            ? Icons.undo
                            : Icons.check_circle_outline,
                        size: 18),
                    label: Text(paycheck.received
                        ? 'Mark not received'
                        : 'Mark received')),
                TextButton.icon(
                    onPressed: () => repo.deletePaycheck(
                        profileId: profileId, id: paycheck.id),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete')),
              ]),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addAllocation(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;
    final target = TextEditingController();
    final amount = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Allocate from this paycheck'),
        content: SizedBox(
          width: 320,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            DialogField(target, 'Goes to (e.g. Savings, Rent)',
                autofocus: true),
            DialogField(amount, 'Amount (\$)'),
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Add')),
        ],
      ),
    );
    if (saved != true) return;
    final cents = parseDollarsToCents(amount.text);
    if (cents == null || target.text.trim().isEmpty) {
      if (context.mounted) warnNotSaved(context, 'enter where the money goes and how much');
      return;
    }
    await repo.upsertAllocation(PaycheckAllocationsCompanion.insert(
      profileId: profileId,
      paycheckId: paycheck.id,
      target: target.text.trim(),
      amountCents: cents,
    ));
  }

  Future<void> _editBonus(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;
    final bonus = TextEditingController(
        text: (paycheck.bonusCents / 100).toString());
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bonus on this check'),
        content: TextField(
            controller: bonus,
            autofocus: true,
            onSubmitted: (_) => Navigator.pop(context, true),
            decoration: const InputDecoration(
                labelText: 'Bonus (\$)', border: OutlineInputBorder())),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save')),
        ],
      ),
    );
    if (saved != true) return;
    await repo.upsertPaycheck(PaychecksCompanion(
      id: Value(paycheck.id),
      profileId: Value(profileId),
      name: Value(paycheck.name),
      date: Value(paycheck.date),
      amountCents: Value(paycheck.amountCents),
      bonusCents: Value(parseDollarsToCents(bonus.text) ?? 0),
      scheduleId: Value(paycheck.scheduleId),
      received: Value(paycheck.received),
    ));
  }
}
