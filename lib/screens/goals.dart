import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';
import 'accounts.dart';

IconData goalIcon(GoalType type) => switch (type) {
      GoalType.savings => Icons.savings_outlined,
      GoalType.payoff => Icons.trending_down,
    };

String goalLabel(GoalType type) => switch (type) {
      GoalType.savings => 'Saving up',
      GoalType.payoff => 'Paying off',
    };

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Add goal'),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: combineLatest<dynamic>([
          repo.watchGoals(profileId: profileId),
          repo.watchAccounts(profileId: profileId),
        ]),
        builder: (context, snap) {
          final goals = (snap.data?[0] as List<Goal>?) ?? [];
          final accounts = (snap.data?[1] as List<Account>?) ?? [];
          if (goals.isEmpty) {
            return const EmptyState(
              icon: Icons.flag_outlined,
              title: 'No goals yet',
              message:
                  'Set a target to save toward, or a debt to clear, and track '
                  'how close you are.',
            );
          }

          // A goal linked to an account tracks that account's real balance
          // instead of the manually-entered number, so it never drifts out
          // of sync with what is actually saved.
          int currentFor(Goal g) {
            if (g.accountId == null) return g.currentAmountCents;
            final account =
                accounts.where((a) => a.id == g.accountId).firstOrNull;
            return account?.balanceCents ?? g.currentAmountCents;
          }

          final saved = goals.fold(0, (s, g) => s + currentFor(g));
          final targets =
              goals.fold(0, (s, g) => s + g.targetAmountCents);
          final done =
              goals.where((g) => currentFor(g) >= g.targetAmountCents).length;

          return ListView(
            padding: kPagePadding,
            children: [
              Wrap(spacing: 16, runSpacing: 16, children: [
                StatCard(
                  label: 'Put aside so far',
                  value: fmtCents(saved),
                  icon: Icons.savings_outlined,
                  color: scheme.primary,
                  note: 'of ${fmtCents(targets)} across all goals',
                ),
                StatCard(
                  label: 'Still to go',
                  value: fmtCents((targets - saved).clamp(0, 1 << 62)),
                  icon: Icons.flag_outlined,
                  color: scheme.secondary,
                  note: done == 0
                      ? '${goals.length} '
                          '${goals.length == 1 ? 'goal' : 'goals'} open'
                      : '$done of ${goals.length} reached',
                ),
              ]),
              kSectionGap,
              SectionHeader('Goals',
                  icon: Icons.flag_outlined,
                  info: const InfoButton(
                    title: 'Goals',
                    body: [
                      'Something you are saving toward, or a debt you want '
                          'gone. Each goal tracks what you have put aside '
                          'against the target.',
                      'Progress is manual: use "Add progress" whenever you '
                          'move money toward it. Clearly does not guess, '
                          'because the money usually sits in an account it '
                          'cannot tell apart from the rest.',
                      'Give a goal a target date and it works out what you '
                          'need to put aside each month to land on time.',
                      'Goals are per profile, like everything else.',
                    ],
                  )),
              for (final g in goals)
                _goalCard(context, ref, g, currentFor(g),
                    accounts.where((a) => a.id == g.accountId).firstOrNull,
                    scheme),
            ],
          );
        },
      ),
    );
  }

  Widget _goalCard(BuildContext context, WidgetRef ref, Goal g,
      int currentCents, Account? linkedAccount, ColorScheme scheme) {
    final complete = currentCents >= g.targetAmountCents;
    final ratio = g.targetAmountCents == 0
        ? 0.0
        : (currentCents / g.targetAmountCents).clamp(0.0, 1.0);
    final remaining =
        (g.targetAmountCents - currentCents).clamp(0, 1 << 62);
    final monthly =
        HomebaseRepository.monthlyNeededFor(g, currentCents: currentCents);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(complete ? Icons.check_circle : goalIcon(g.type),
                    color: complete ? scheme.primary : scheme.secondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.name,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                          '${goalLabel(g.type)}'
                          '${g.targetDate == null ? '' : ' • by '
                              '${_fmtMonthYear(g.targetDate!)}'}'
                          '${linkedAccount == null ? '' : ' • tracks '
                              '${linkedAccount.name}'}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Text('${(ratio * 100).round()}%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color:
                            complete ? scheme.primary : scheme.secondary)),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 10,
                color: complete ? scheme.primary : scheme.secondary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('${fmtCents(currentCents)} '
                    'of ${fmtCents(g.targetAmountCents)}'),
                const Spacer(),
                if (complete)
                  Text('Reached',
                      style: TextStyle(
                          color: scheme.primary,
                          fontWeight: FontWeight.w600))
                else
                  Text('${fmtCents(remaining)} to go',
                      style: TextStyle(color: scheme.onSurfaceVariant)),
              ],
            ),
            if (monthly != null) ...[
              const SizedBox(height: 4),
              Text('${fmtCents(monthly)} a month to reach it on time',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.secondary)),
            ],
            if (g.targetDate != null &&
                !complete &&
                monthly == null) ...[
              const SizedBox(height: 4),
              Text('Target date has passed',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.error)),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                if (!complete && linkedAccount == null)
                  FilledButton.tonalIcon(
                    onPressed: () => _addProgress(context, ref, g),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add progress'),
                  ),
                if (!complete && linkedAccount == null)
                  const SizedBox(width: 8),
                TextButton.icon(
                    onPressed: () => _edit(context, ref, g),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit')),
                TextButton.icon(
                    onPressed: () => _delete(context, ref, g),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addProgress(
      BuildContext context, WidgetRef ref, Goal g) async {
    final amount = TextEditingController();
    final remaining =
        (g.targetAmountCents - g.currentAmountCents).clamp(0, 1 << 62);

    final action = await showDialog<String>(
      context: context,
      builder: (context) => SubmitOnEnter(
        onSubmit: () => Navigator.pop(context, 'add'),
        child: AlertDialog(
          icon: Icon(goalIcon(g.type)),
          title: Text('Add progress — ${g.name}'),
          content: SizedBox(
            width: 340,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    '${fmtCents(g.currentAmountCents)} of '
                    '${fmtCents(g.targetAmountCents)} so far — '
                    '${fmtCents(remaining)} to go.',
                    style: Theme.of(context).textTheme.bodySmall),
              ),
              const SizedBox(height: 12),
              DialogField(amount, 'Amount to add (\$)',
                  autofocus: true,
                  helper: 'Use a negative amount to correct a mistake'),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, 'cancel'),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(context, 'finish'),
                child: const Text('Mark reached')),
            FilledButton(
                onPressed: () => Navigator.pop(context, 'add'),
                child: const Text('Add')),
          ],
        ),
      ),
    );
    if (action == null || action == 'cancel') return;

    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;

    if (action == 'finish') {
      await repo.upsertGoal(GoalsCompanion(
        id: Value(g.id),
        profileId: Value(profileId),
        name: Value(g.name),
        type: Value(g.type),
        targetAmountCents: Value(g.targetAmountCents),
        currentAmountCents: Value(g.targetAmountCents),
        targetDate: Value(g.targetDate),
      ));
      return;
    }

    final cents = parseDollarsToCents(amount.text);
    if (cents == null || cents == 0) return;
    await repo.addGoalProgress(
        profileId: profileId, id: g.id, amountCents: cents);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Goal g) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${g.name}?'),
        content: const Text('The goal and its progress are removed.'),
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
    if (ok != true) return;
    await ref.read(repositoryProvider).deleteGoal(
        profileId: ref.read(activeProfileProvider)!.id, id: g.id);
  }

  Future<void> _edit(
      BuildContext context, WidgetRef ref, Goal? existing) async {
    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;
    final accounts = await repo.watchAccounts(profileId: profileId).first;
    if (!context.mounted) return;
    final name = TextEditingController(text: existing?.name);
    final target = TextEditingController(
        text: existing == null
            ? ''
            : (existing.targetAmountCents / 100).toString());
    final current = TextEditingController(
        text: existing == null
            ? ''
            : (existing.currentAmountCents / 100).toString());
    var type = existing?.type ?? GoalType.savings;
    DateTime? targetDate = existing?.targetDate;
    int? accountId = existing?.accountId;
    String? nameError;
    String? targetError;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => SubmitOnEnter(
          onSubmit: () => Navigator.pop(context, true),
          child: AlertDialog(
            title: Text(existing == null ? 'Add goal' : 'Edit goal'),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                    controller: name,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'What is it for',
                      errorText: nameError,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      if (nameError != null) {
                        setLocal(() => nameError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<GoalType>(
                    initialValue: type,
                    decoration: const InputDecoration(
                        labelText: 'Kind', border: OutlineInputBorder()),
                    items: [
                      for (final t in GoalType.values)
                        DropdownMenuItem(
                          value: t,
                          child: Row(children: [
                            Icon(goalIcon(t), size: 16),
                            const SizedBox(width: 8),
                            Text(goalLabel(t)),
                          ]),
                        ),
                    ],
                    onChanged: (v) => setLocal(() => type = v!),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: target,
                    decoration: InputDecoration(
                      labelText: 'Target amount (\$)',
                      helperText: 'How much you are aiming for',
                      errorText: targetError,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      if (targetError != null) {
                        setLocal(() => targetError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  if (accountId == null)
                    DialogField(current, 'Already put aside (\$)',
                        helper: 'Leave blank to start from zero'),
                  if (accounts.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int?>(
                      initialValue: accountId,
                      decoration: const InputDecoration(
                          labelText: 'Track an account (optional)',
                          helperText: 'Progress follows this account\'s '
                              'balance instead of a manual number',
                          helperMaxLines: 2,
                          border: OutlineInputBorder()),
                      items: [
                        const DropdownMenuItem(
                            value: null, child: Text('Not linked')),
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
                      onChanged: (v) => setLocal(() => accountId = v),
                    ),
                  ],
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 16),
                      label: Text(targetDate == null
                          ? 'Target date (optional)'
                          : 'By ${_fmtMonthYear(targetDate!)}'),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: targetDate ??
                              DateTime.now().add(const Duration(days: 180)),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2060),
                          helpText: 'When do you want this by?',
                        );
                        if (picked != null) {
                          setLocal(() => targetDate = picked);
                        }
                      },
                    ),
                  ),
                  if (targetDate != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(Icons.clear, size: 14),
                        label: const Text('Clear date'),
                        onPressed: () => setLocal(() => targetDate = null),
                      ),
                    ),
                ]),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () {
                    // Validate here rather than after the dialog closes —
                    // returning silently made a filled-in goal look like it
                    // simply failed to save.
                    final missingName = name.text.trim().isEmpty;
                    final cents = parseDollarsToCents(target.text);
                    final badTarget = cents == null || cents <= 0;
                    if (missingName || badTarget) {
                      setLocal(() {
                        nameError = missingName ? 'Give the goal a name' : null;
                        targetError = badTarget
                            ? 'Enter an amount greater than zero'
                            : null;
                      });
                      return;
                    }
                    Navigator.pop(context, true);
                  },
                  child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
    if (saved != true) return;
    // Already validated in the dialog; this is belt and braces.
    final targetCents = parseDollarsToCents(target.text);
    if (name.text.trim().isEmpty || targetCents == null || targetCents <= 0) {
      return;
    }

    await ref.read(repositoryProvider).upsertGoal(GoalsCompanion(
          id: existing == null ? const Value.absent() : Value(existing.id),
          profileId: Value(profileId),
          name: Value(name.text.trim()),
          type: Value(type),
          targetAmountCents: Value(targetCents),
          // When linked to an account, leave the stored column alone rather
          // than overwriting it with a blank field's zero — the account
          // balance is the real number now, and the stored value becomes
          // the fallback again if the account is later unlinked or deleted.
          currentAmountCents: accountId != null
              ? const Value.absent()
              : Value(parseDollarsToCents(current.text) ?? 0),
          targetDate: Value(targetDate),
          accountId: Value(accountId),
        ));
  }

  static String _fmtMonthYear(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.year}';
  }
}
