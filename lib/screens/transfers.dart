import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';
import 'accounts.dart';

String transferFreqLabel(PayFrequency f) => switch (f) {
      PayFrequency.weekly => 'Weekly',
      PayFrequency.biweekly => 'Bi-weekly',
      PayFrequency.semimonthly => 'Semi-monthly (1st & 15th style)',
      PayFrequency.monthly => 'Monthly',
    };

/// Recurring, automatic money movements between two of your own accounts —
/// e.g. $200 checking -> savings every month. Not income or spending, so it
/// never shows up on the Budget screen, only here and in the two accounts'
/// balances.
class TransfersScreen extends ConsumerWidget {
  const TransfersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FloatingActionButton.extended(
              heroTag: 'transferNow',
              onPressed: () => _transferNow(context, ref),
              icon: const Icon(Icons.bolt_outlined),
              label: const Text('Transfer now'),
            ),
          ),
          FloatingActionButton.extended(
            heroTag: 'addTransfer',
            onPressed: () => _edit(context, ref, null),
            icon: const Icon(Icons.add),
            label: const Text('Add transfer'),
          ),
        ],
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: combineLatest<dynamic>([
          repo.watchRecurringTransfers(profileId: profileId),
          repo.watchAccounts(profileId: profileId),
          repo.watchTransferHistory(profileId: profileId),
        ]),
        builder: (context, snap) {
          if (!snap.hasData) return const SizedBox.shrink();
          final transfers = snap.data![0] as List<RecurringTransfer>;
          final accounts = snap.data![1] as List<Account>;
          final history = snap.data![2] as List<TransferLog>;
          String accountName(int id) =>
              accounts.where((a) => a.id == id).firstOrNull?.name ??
              'Deleted account';

          if (transfers.isEmpty && history.isEmpty) {
            return const EmptyState(
              icon: Icons.sync_alt_outlined,
              title: 'No recurring transfers',
              message: 'Automatically move money between your own accounts '
                  'on a schedule — like sending \$200 to savings every month.',
            );
          }

          return ListView(
            padding: kPagePadding,
            children: [
              SectionHeader('Scheduled',
                  icon: Icons.sync_alt_outlined,
                  info: const InfoButton(
                    title: 'Recurring transfers',
                    body: [
                      'Moves a fixed amount from one of your accounts to '
                          'another, automatically, on a schedule — the same '
                          'way autopay bills and paychecks handle themselves.',
                      'This is not income or spending: it never appears on '
                          'the Budget screen, since money moving between your '
                          'own accounts is not money in or out of the '
                          'household.',
                      'Deleting either account deletes the transfer too — a '
                          'transfer with only one side left cannot mean '
                          'anything.',
                    ],
                  )),
              if (transfers.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: EmptyState(
                      icon: Icons.sync_alt_outlined,
                      title: 'Nothing scheduled',
                      message: 'Add one to move money automatically.',
                    ),
                  ),
                )
              else
                Card(
                  child: Column(
                    children: [
                      for (final t in transfers)
                        ListTile(
                          leading: Icon(
                              t.active
                                  ? Icons.sync_alt_outlined
                                  : Icons.pause_circle_outline,
                              color: t.active
                                  ? scheme.primary
                                  : scheme.onSurfaceVariant),
                          title: Text(t.name),
                          subtitle: Text(
                              '${accountName(t.fromAccountId)} → '
                              '${accountName(t.toAccountId)} • '
                              '${transferFreqLabel(t.frequency)}'
                              '${t.active ? '' : ' • paused'}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(fmtCents(t.amountCents),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              IconButton(
                                  tooltip: 'Edit',
                                  icon: const Icon(Icons.edit_outlined,
                                      size: 18),
                                  onPressed: () => _edit(context, ref, t)),
                              IconButton(
                                  tooltip: 'Delete',
                                  icon: const Icon(Icons.delete_outline,
                                      size: 18),
                                  onPressed: () => _delete(context, ref, t)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              if (history.isNotEmpty) ...[
                kSectionGap,
                const SectionHeader('Recent transfers',
                    icon: Icons.history_outlined),
                Card(
                  child: Column(
                    children: [
                      for (final log in history)
                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.sync_alt_outlined,
                              size: 18),
                          title: Text(transfers
                                  .where((t) => t.id == log.transferId)
                                  .firstOrNull
                                  ?.name ??
                              'Deleted transfer'),
                          subtitle: Text(
                              '${log.date.month}/${log.date.day}/${log.date.year}'),
                          trailing: Text(fmtCents(log.amountCents)),
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

  Future<void> _delete(
      BuildContext context, WidgetRef ref, RecurringTransfer transfer) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${transfer.name}?'),
        content: const Text(
            'Past transfers stay in history; future ones stop running.'),
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
      await ref.read(repositoryProvider).deleteRecurringTransfer(
          profileId: ref.read(activeProfileProvider)!.id, id: transfer.id);
    }
  }

  /// A one-off transfer, moved immediately rather than scheduled — for
  /// something like moving a bonus to savings today, distinct from
  /// [_edit]'s recurring schedule.
  Future<void> _transferNow(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;
    final accounts = (await repo.watchAccounts(profileId: profileId).first)
        .where((a) => HomebaseRepository.cashAccountTypes.contains(a.type))
        .toList();
    if (!context.mounted) return;
    if (accounts.length < 2) {
      warnNotSaved(context, 'you need at least two accounts to transfer '
          'between — add one on the Cash tab first');
      return;
    }

    final name = TextEditingController();
    final amount = TextEditingController();
    int fromId = accounts[0].id;
    int toId = accounts.firstWhere((a) => a.id != fromId, orElse: () => accounts[1]).id;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => SubmitOnEnter(
          onSubmit: () => Navigator.pop(context, true),
          child: AlertDialog(
            title: const Text('Transfer now'),
            content: SizedBox(
              width: 380,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                DialogField(name, 'Name (optional)', autofocus: true),
                const SizedBox(height: 12),
                DialogField(amount, 'Amount (\$)'),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: fromId,
                  decoration:
                      const InputDecoration(labelText: 'From', border: OutlineInputBorder()),
                  items: [
                    for (final a in accounts)
                      DropdownMenuItem(
                        value: a.id,
                        child: Row(children: [
                          Icon(accountIcon(a.type), size: 16, color: accountTypeColor(context, a.type)),
                          const SizedBox(width: 8),
                          Text(a.name),
                        ]),
                      ),
                  ],
                  onChanged: (v) => setLocal(() => fromId = v!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: toId,
                  decoration:
                      const InputDecoration(labelText: 'To', border: OutlineInputBorder()),
                  items: [
                    for (final a in accounts)
                      DropdownMenuItem(
                        value: a.id,
                        child: Row(children: [
                          Icon(accountIcon(a.type), size: 16, color: accountTypeColor(context, a.type)),
                          const SizedBox(width: 8),
                          Text(a.name),
                        ]),
                      ),
                  ],
                  onChanged: (v) => setLocal(() => toId = v!),
                ),
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Transfer')),
            ],
          ),
        ),
      ),
    );
    if (saved != true) return;
    final cents = parseDollarsToCents(amount.text);
    if (cents == null || cents <= 0) {
      if (context.mounted) warnNotSaved(context, 'enter an amount');
      return;
    }
    if (fromId == toId) {
      if (context.mounted) {
        warnNotSaved(context, 'the two accounts must be different');
      }
      return;
    }
    await repo.postManualTransfer(
      profileId: profileId,
      fromAccountId: fromId,
      toAccountId: toId,
      amountCents: cents,
      date: DateTime.now(),
      name: name.text.trim().isEmpty ? 'Transfer' : name.text.trim(),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref,
      RecurringTransfer? existing) async {
    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;
    // Retirement and investment accounts aren't something you'd manually
    // transfer into or out of — left out of the picker, unless a transfer
    // already uses one, so editing it doesn't strand the dropdown on a
    // value with no matching item.
    final accounts = (await repo.watchAccounts(profileId: profileId).first)
        .where((a) =>
            HomebaseRepository.cashAccountTypes.contains(a.type) ||
            a.id == existing?.fromAccountId ||
            a.id == existing?.toAccountId)
        .toList();
    if (!context.mounted) return;
    if (accounts.length < 2) {
      warnNotSaved(context, 'you need at least two accounts to transfer '
          'between — add one on the Accounts tab first');
      return;
    }

    final name = TextEditingController(text: existing?.name);
    final amount = TextEditingController(
        text: existing == null
            ? ''
            : (existing.amountCents / 100).toString());
    int? fromId = existing?.fromAccountId ?? accounts[0].id;
    int? toId = existing?.toAccountId ??
        accounts.firstWhere((a) => a.id != fromId, orElse: () => accounts[1]).id;
    var frequency = existing?.frequency ?? PayFrequency.monthly;
    var anchorDate = existing?.anchorDate ?? DateTime.now();
    var active = existing?.active ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => SubmitOnEnter(
          onSubmit: () => Navigator.pop(context, true),
          child: AlertDialog(
            title: Text(existing == null ? 'Add transfer' : 'Edit transfer'),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  DialogField(name, 'Name', autofocus: true),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: fromId,
                    decoration: const InputDecoration(
                        labelText: 'From', border: OutlineInputBorder()),
                    items: [
                      for (final a in accounts)
                        DropdownMenuItem(
                          value: a.id,
                          child: Row(children: [
                            Icon(accountIcon(a.type), size: 16, color: accountTypeColor(context, a.type)),
                            const SizedBox(width: 8),
                            Text(a.name),
                          ]),
                        ),
                    ],
                    onChanged: (v) => setLocal(() => fromId = v),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: toId,
                    decoration: const InputDecoration(
                        labelText: 'To', border: OutlineInputBorder()),
                    items: [
                      for (final a in accounts)
                        DropdownMenuItem(
                          value: a.id,
                          child: Row(children: [
                            Icon(accountIcon(a.type), size: 16, color: accountTypeColor(context, a.type)),
                            const SizedBox(width: 8),
                            Text(a.name),
                          ]),
                        ),
                    ],
                    onChanged: (v) => setLocal(() => toId = v),
                  ),
                  const SizedBox(height: 12),
                  DialogField(amount, 'Amount (\$)'),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<PayFrequency>(
                    initialValue: frequency,
                    decoration: const InputDecoration(
                        labelText: 'Frequency', border: OutlineInputBorder()),
                    items: [
                      for (final f in PayFrequency.values)
                        DropdownMenuItem(
                            value: f, child: Text(transferFreqLabel(f))),
                    ],
                    onChanged: (v) => setLocal(() => frequency = v!),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: Text(
                          'Starts ${anchorDate.month}/${anchorDate.day}/${anchorDate.year}'),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: anchorDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2060),
                          helpText: 'First transfer date',
                        );
                        if (picked != null) {
                          setLocal(() => anchorDate = picked);
                        }
                      },
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Active'),
                    contentPadding: EdgeInsets.zero,
                    value: active,
                    onChanged: (v) => setLocal(() => active = v),
                  ),
                ]),
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
      if (context.mounted) warnNotSaved(context, 'the transfer needs a name');
      return;
    }
    if (fromId == toId) {
      if (context.mounted) {
        warnNotSaved(context, 'from and to must be different accounts');
      }
      return;
    }
    final cents = parseDollarsToCents(amount.text);
    if (cents == null || cents <= 0) {
      if (context.mounted) {
        warnNotSaved(context, 'enter an amount greater than zero');
      }
      return;
    }

    await repo.upsertRecurringTransfer(RecurringTransfersCompanion(
      id: existing == null ? const Value.absent() : Value(existing.id),
      profileId: Value(profileId),
      name: Value(name.text.trim()),
      fromAccountId: Value(fromId!),
      toAccountId: Value(toId!),
      amountCents: Value(cents),
      frequency: Value(frequency),
      anchorDate: Value(anchorDate),
      active: Value(active),
    ));
  }
}
