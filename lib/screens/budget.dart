import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';
import '../widgets/sankey_chart.dart';
import 'accounts.dart';

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];

/// A simple month view: what came in, what went out, what is left, and where
/// it went. Forward-looking planning lives on the Dashboard instead, so this
/// screen only ever describes the month you are looking at.
class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  String? _tagFilter;

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _month.year == now.year && _month.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editEntry(context),
        icon: const Icon(Icons.add),
        label: const Text('Add entry'),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: combineLatest<dynamic>([
          repo.watchBudgetForMonth(profileId: profileId, month: _month),
          repo.watchBudgetTargets(profileId: profileId),
          repo.watchExpectedIncomeForMonth(
              profileId: profileId, month: _month),
          repo.watchBillsDueThisMonthCents(
              profileId: profileId, month: _month),
          repo.watchCardFeesDueThisMonthCents(profileId: profileId),
          repo.watchReserveForIrregularBillsCents(profileId: profileId),
          repo.watchReserveForCardFeesCents(profileId: profileId),
          repo.watchEntryTagNames(profileId: profileId),
          repo.watchSplitsByEntry(profileId: profileId),
        ]),
        builder: (context, snap) {
          if (!snap.hasData) return const SizedBox.shrink();
          final entries = snap.data![0] as List<BudgetEntry>;
          final targets = snap.data![1] as List<BudgetTarget>;
          final expectedIncome = snap.data![2] as int;
          final billsDue = (snap.data![3] as int) + (snap.data![4] as int);
          final setAside = (snap.data![5] as int) + (snap.data![6] as int);
          final tagsByEntry = snap.data![7] as Map<int, List<String>>;
          final splitsByEntry =
              snap.data![8] as Map<int, List<TransactionSplit>>;
          return _body(context, entries, targets, expectedIncome, billsDue,
              setAside, tagsByEntry, splitsByEntry, scheme);
        },
      ),
    );
  }

  Widget _body(
      BuildContext context,
      List<BudgetEntry> entries,
      List<BudgetTarget> targets,
      int expectedIncomeCents,
      int billsDueCents,
      int setAsideCents,
      Map<int, List<String>> tagsByEntry,
      Map<int, List<TransactionSplit>> splitsByEntry,
      ColorScheme scheme) {
    final moneyIn = entries
        .where((e) => e.type == EntryType.income)
        .fold(0, (s, e) => s + e.amountCents);
    final moneyOut = entries
        .where((e) => e.type == EntryType.expense)
        .fold(0, (s, e) => s + e.amountCents);

    // Targets are money you have already committed to a category, so they
    // count as allocated even before you spend it.
    final targetsTotal =
        targets.fold(0, (sum, t) => sum + t.monthlyTargetCents);
    final unallocated = expectedIncomeCents - billsDueCents - targetsTotal;

    // A split entry counts under each of its own categories here, not once
    // under its parent's fallback category.
    final categoryRows =
        HomebaseRepository.expandForCategoryTotals(entries, splitsByEntry);
    final spentByCategory = <String, int>{};
    final incomeByCategory = <String, int>{};
    for (final r in categoryRows) {
      final map = r.type == EntryType.expense ? spentByCategory : incomeByCategory;
      map[r.category] = (map[r.category] ?? 0) + r.amountCents;
    }
    final categories = {
      ...spentByCategory.keys,
      ...targets.map((t) => t.category)
    }.toList()
      ..sort((a, b) =>
          (spentByCategory[b] ?? 0).compareTo(spentByCategory[a] ?? 0));

    final allTags = tagsByEntry.values.expand((t) => t).toSet().toList()
      ..sort();
    final visibleEntries = _tagFilter == null
        ? entries
        : entries
            .where((e) => (tagsByEntry[e.id] ?? []).contains(_tagFilter))
            .toList();

    return Column(
      children: [
        _monthBar(context),
        Expanded(
          child: ListView(
            padding: kPagePadding,
            children: [
              Wrap(spacing: 16, runSpacing: 16, children: [
                StatCard(
                  label: 'Income this month',
                  value: fmtCents(expectedIncomeCents),
                  icon: Icons.arrow_downward,
                  color: scheme.primary,
                  note: moneyIn == expectedIncomeCents
                      ? 'all received'
                      : '${fmtCents(moneyIn)} received so far',
                  info: const InfoButton(
                    title: 'Income this month',
                    body: [
                      'What your paychecks for this month add up to, whether '
                          'or not payday has arrived yet — so you can budget '
                          'the whole month from the 1st instead of watching '
                          'the number climb.',
                      'It is the real sum of this month\'s paychecks, not an '
                          'average, so a month with three paydays shows three '
                          'paychecks. Bonuses are included.',
                      'The smaller line underneath tells you how much of it '
                          'has actually landed so far.',
                      'Add or remove paychecks on the Paychecks screen; they '
                          'are generated 90 days ahead from your schedule.',
                    ],
                  ),
                ),
                StatCard(
                  label: 'Spent so far',
                  value: fmtCents(moneyOut),
                  icon: Icons.arrow_upward,
                  color: scheme.error,
                  note: billsDueCents > 0
                      ? '${fmtCents(billsDueCents)} of bills due this month'
                      : null,
                ),
                StatCard(
                  label: 'Free to spend',
                  value: fmtCents(unallocated),
                  icon: Icons.savings_outlined,
                  color:
                      unallocated >= 0 ? scheme.secondary : scheme.error,
                  note: targetsTotal > 0
                      ? (unallocated >= 0
                          ? 'after bills and targets'
                          : 'over-allocated')
                      : 'income minus this month\'s bills',
                  info: const InfoButton(
                    title: 'Free to spend',
                    body: [
                      'This month\'s paycheck total minus everything already '
                          'spoken for: the bills that actually charge this '
                          'month, and any category targets you have set.',
                      'A target is a commitment, so it counts as allocated '
                          'even before you spend it — setting a \$400 '
                          'grocery target lowers this by \$400 immediately.',
                      'It is steady from the 1st, because it counts paychecks '
                          'you are due as well as ones already received.',
                      'If it goes red you have allocated more than you earn '
                          'this month — lower a target or trim a bill.',
                      'The breakdown is in the plan below.',
                    ],
                  ),
                ),
              ]),
              kSectionGap,
              SectionHeader('Plan for this month',
                  icon: Icons.calculate_outlined,
                  info: const InfoButton(
                    title: 'Plan for this month',
                    body: [
                      'The arithmetic behind "free to spend": this month\'s '
                          'paycheck total, minus the bills that actually '
                          'charge this month, minus any category targets you '
                          'have committed to.',
                      '"Set aside" is a recommendation, not a bill. Annual '
                          'and quarterly costs are divided across their term '
                          '— a \$325 card fee is \$27.08 a month — so the '
                          'charge does not blindside you when it lands. That '
                          'money has not left your account, which is why it '
                          'is listed separately rather than subtracted above.',
                      'The last line is what is genuinely yours to spend once '
                          'you have put that reserve away.',
                    ],
                  )),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _planRow(context, 'Income this month',
                          fmtCents(expectedIncomeCents)),
                      _planRow(context, 'Bills due this month',
                          '-${fmtCents(billsDueCents)}'),
                      if (targetsTotal > 0)
                        _planRow(context, 'Category targets you have set',
                            '-${fmtCents(targetsTotal)}'),
                      const Divider(),
                      _planRow(context, 'Left to budget',
                          fmtCents(unallocated),
                          bold: true,
                          color: unallocated >= 0 ? null : scheme.error),
                      if (setAsideCents > 0) ...[
                        const SizedBox(height: 12),
                        Row(children: [
                          Icon(Icons.savings_outlined,
                              size: 14, color: scheme.secondary),
                          const SizedBox(width: 6),
                          Text('Recommended',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: scheme.secondary)),
                        ]),
                        const SizedBox(height: 4),
                        _planRow(
                            context,
                            'Put away for annual and quarterly costs',
                            fmtCents(setAsideCents),
                            color: scheme.secondary),
                        _planRow(
                            context,
                            'Left after setting that aside',
                            fmtCents(unallocated - setAsideCents),
                            color: scheme.secondary),
                      ],
                    ],
                  ),
                ),
              ),
              if (moneyIn > 0 || moneyOut > 0) ...[
                kSectionGap,
                SectionHeader('Cash flow',
                    icon: Icons.alt_route,
                    info: const InfoButton(
                      title: 'Cash flow',
                      body: [
                        'Where this month\'s money came from on the left, '
                            'and where it went on the right — income sources '
                            'flow into a single total, which then splits '
                            'across spending categories.',
                        'Whatever is left over flows out as Savings. If '
                            'spending exceeds income this month, Savings '
                            'drops out and the categories on the right simply '
                            'add up to more than what came in.',
                      ],
                    )),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 320,
                      child: IncomeSankeyChart(
                        incomeByCategory: incomeByCategory,
                        expenseByCategory: spentByCategory,
                        leftoverCents: moneyIn - moneyOut,
                      ),
                    ),
                  ),
                ),
              ],
              kSectionGap,
              SectionHeader('Where it went',
                  icon: Icons.donut_small_outlined,
                  info: const InfoButton(
                    title: 'Where it went',
                    body: [
                      'This month\'s spending grouped by category, biggest '
                          'first.',
                      'If you set a target for a category, a bar shows how '
                          'much of it you have used, turning red once you go '
                          'over. Targets are optional — without one you just '
                          'see the amount.',
                      'Set one with the button on any row here, or manage '
                          'them all with Targets at the top.',
                    ],
                  )),
              if (categories.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: EmptyState(
                      icon: Icons.donut_small_outlined,
                      title: 'Nothing spent yet',
                      message:
                          'Expenses appear here as you mark bills paid or add '
                          'entries.',
                    ),
                  ),
                )
              else
                Card(
                  child: Column(
                    children: [
                      for (final cat in categories)
                        _categoryTile(context, cat,
                            spentByCategory[cat] ?? 0, _targetFor(targets, cat),
                            scheme),
                    ],
                  ),
                ),
              kSectionGap,
              const SectionHeader('Everything this month',
                  icon: Icons.list_alt_outlined),
              if (allTags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      for (final tag in allTags)
                        ChoiceChip(
                          label: Text(tag),
                          selected: _tagFilter == tag,
                          onSelected: (selected) => setState(
                              () => _tagFilter = selected ? tag : null),
                        ),
                    ],
                  ),
                ),
              if (visibleEntries.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: EmptyState(
                      icon: Icons.list_alt_outlined,
                      title: 'Nothing yet this month',
                      message:
                          'Paychecks and paid bills land here on their own. '
                          'Use Add entry for anything else.',
                    ),
                  ),
                )
              else
                Card(
                  child: Column(
                    children: [
                      for (final e in visibleEntries)
                        _entryTile(context, e, tagsByEntry[e.id] ?? [],
                            splitsByEntry[e.id] ?? [], scheme),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _monthBar(BuildContext context) {
    return Material(
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Previous month',
              icon: const Icon(Icons.chevron_left),
              onPressed: () => setState(
                  () => _month = DateTime(_month.year, _month.month - 1)),
            ),
            Text('${_monthNames[_month.month - 1]} ${_month.year}',
                style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              tooltip: 'Next month',
              icon: const Icon(Icons.chevron_right),
              onPressed: () => setState(
                  () => _month = DateTime(_month.year, _month.month + 1)),
            ),
            if (!_isCurrentMonth)
              TextButton.icon(
                icon: const Icon(Icons.today, size: 16),
                label: const Text('This month'),
                onPressed: () {
                  final now = DateTime.now();
                  setState(() => _month = DateTime(now.year, now.month));
                },
              ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _manageTargets(context),
              icon: const Icon(Icons.track_changes, size: 18),
              label: const Text('Targets'),
            ),
            const SizedBox(width: 4),
            TextButton.icon(
              onPressed: () => _manageRules(context),
              icon: const Icon(Icons.rule, size: 18),
              label: const Text('Auto-categorize'),
            ),
            const SizedBox(width: 4),
            TextButton.icon(
              onPressed: () => _manageTags(context),
              icon: const Icon(Icons.label_outline, size: 18),
              label: const Text('Tags'),
            ),
          ],
        ),
      ),
    );
  }

  /// A misspelled or abandoned tag has no other way to go away — it can
  /// only ever be created by typing it into an entry, never browsed or
  /// removed from anywhere else.
  Future<void> _manageTags(BuildContext context) async {
    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tags'),
        content: SizedBox(
          width: 360,
          child: StreamBuilder<List<Tag>>(
            stream: repo.watchTags(profileId: profileId),
            builder: (context, snap) {
              final tags = snap.data ?? [];
              if (tags.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: EmptyState(
                    icon: Icons.label_outline,
                    title: 'No tags yet',
                    message: 'Add one by typing it into an entry\'s Tags '
                        'field when you add it.',
                  ),
                );
              }
              return SizedBox(
                height: 320,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final t in tags)
                      ListTile(
                        leading: CategoryDot(t.name),
                        title: Text(t.name),
                        trailing: IconButton(
                          tooltip: 'Delete tag',
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () async {
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete "${t.name}"?'),
                                content: const Text(
                                    'Removed from every entry it was on. '
                                    'The entries themselves are unaffected.'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel')),
                                  DangerButton(
                                      label: 'Delete',
                                      onPressed: () =>
                                          Navigator.pop(context, true)),
                                ],
                              ),
                            );
                            if (ok == true) {
                              await repo.deleteTag(
                                  profileId: profileId, id: t.id);
                            }
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _entryTile(BuildContext context, BudgetEntry e, List<String> tags,
      List<TransactionSplit> splits, ColorScheme scheme) {
    final automatic = e.sourcePaycheckId != null || e.sourceBillPaymentId != null;
    return ListTile(
      leading: Icon(
          e.sourcePaycheckId != null
              ? Icons.payments_outlined
              : e.sourceBillPaymentId != null
                  ? Icons.receipt_long_outlined
                  : e.type == EntryType.income
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
          color: e.type == EntryType.income ? scheme.primary : scheme.error),
      title: Text(e.description ?? e.category),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${splits.isEmpty ? e.category : 'Split'}'
              '${e.payee != null ? ' • ${e.payee}' : ''} • '
              '${_monthNames[e.date.month - 1].substring(0, 3)} ${e.date.day}'
              '${automatic ? ' • added automatically' : ''}'),
          if (splits.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  for (final s in splits)
                    Pill('${s.category} ${fmtCents(s.amountCents)}',
                        color: categoryColor(context, s.category),
                        fontSize: 11),
                ],
              ),
            ),
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${e.type == EntryType.income ? '+' : '-'}'
            '${fmtCents(e.amountCents)}',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: e.type == EntryType.income ? scheme.primary : null),
          ),
          IconButton(
            tooltip: automatic
                ? 'Added automatically — edit it on Paychecks or Bills'
                : 'Edit',
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: automatic ? null : () => _editEntry(context, existing: e),
          ),
          IconButton(
            tooltip: automatic
                ? 'Added automatically — remove it on Paychecks or Bills'
                : 'Delete',
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: automatic
                ? null
                : () => ref.read(repositoryProvider).deleteBudgetEntry(
                    profileId: ref.read(activeProfileProvider)!.id, id: e.id),
          ),
        ],
      ),
    );
  }

  Widget _planRow(BuildContext context, String label, String value,
      {bool bold = false, Color? color}) {
    final style = TextStyle(
        fontWeight: bold ? FontWeight.bold : null, color: color);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }

  int? _targetFor(List<BudgetTarget> targets, String category) {
    for (final t in targets) {
      if (t.category == category) return t.monthlyTargetCents;
    }
    return null;
  }

  Widget _categoryTile(BuildContext context, String category, int spentCents,
      int? targetCents, ColorScheme scheme) {
    final over = targetCents != null && spentCents > targetCents;
    return ListTile(
      leading: SizedBox(
          width: 24, height: 24, child: Center(child: CategoryDot(category))),
      title: Text(category),
      subtitle: targetCents == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 6),
              child: LinearProgressIndicator(
                value: (spentCents / targetCents).clamp(0.0, 1.0),
                color: over ? scheme.error : scheme.primary,
              ),
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            targetCents == null
                ? fmtCents(spentCents)
                : '${fmtCents(spentCents)} of ${fmtCents(targetCents)}',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: over ? scheme.error : null),
          ),
          const SizedBox(width: 4),
          // The most useful place to set a limit is next to what you spent.
          targetCents == null
              ? TextButton(
                  onPressed: () => _setTarget(context, category, null),
                  child: const Text('Set target'),
                )
              : IconButton(
                  tooltip: 'Change target',
                  icon: const Icon(Icons.track_changes, size: 18),
                  onPressed: () => _setTarget(context, category, targetCents),
                ),
        ],
      ),
    );
  }

  /// Sets or clears the target for one category, without opening the full
  /// targets list.
  Future<void> _setTarget(
      BuildContext context, String category, int? currentCents) async {
    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;
    final amount = TextEditingController(
        text: currentCents == null ? '' : (currentCents / 100).toString());

    final action = await showDialog<String>(
      context: context,
      builder: (context) => SubmitOnEnter(
        onSubmit: () => Navigator.pop(context, 'save'),
        child: AlertDialog(
          title: Text('Monthly target for $category'),
          content: SizedBox(
            width: 320,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              DialogField(amount, 'Target (\$)',
                  autofocus: true,
                  helper: 'What you want to keep this category under'),
            ]),
          ),
          actions: [
            if (currentCents != null)
              TextButton(
                  onPressed: () => Navigator.pop(context, 'clear'),
                  child: const Text('Remove target')),
            TextButton(
                onPressed: () => Navigator.pop(context, 'cancel'),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(context, 'save'),
                child: const Text('Save')),
          ],
        ),
      ),
    );
    if (action == null || action == 'cancel') return;

    if (action == 'clear') {
      final targets = await repo.watchBudgetTargets(profileId: profileId).first;
      final existing =
          targets.where((t) => t.category == category).firstOrNull;
      if (existing != null) {
        await repo.deleteBudgetTarget(profileId: profileId, id: existing.id);
      }
      return;
    }

    final cents = parseDollarsToCents(amount.text);
    if (cents == null) return;
    await repo.upsertBudgetTarget(BudgetTargetsCompanion.insert(
        profileId: profileId,
        category: category,
        monthlyTargetCents: cents));
  }

  Future<void> _editEntry(BuildContext context, {BudgetEntry? existing}) async {
    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;
    final description = TextEditingController(text: existing?.description);
    final amount = TextEditingController(
        text: existing == null
            ? ''
            : (existing.amountCents / 100).toString());
    final category = TextEditingController(
        text: existing == null || existing.category == 'Split'
            ? existing?.category ?? ''
            : existing.category);
    final payee = TextEditingController(text: existing?.payee);
    var type = existing?.type ?? EntryType.expense;
    var autoCategorized = false;
    // Encoded as "account:3" or "card:2" so one dropdown can offer both.
    String? source = existing == null
        ? null
        : existing.accountId != null
            ? 'account:${existing.accountId}'
            : existing.cardId != null
                ? 'card:${existing.cardId}'
                : null;
    var splitMode = false;
    final splitRows = <({TextEditingController category, TextEditingController amount})>[];
    var existingTags = <String>[];
    if (existing != null) {
      final splits = await repo.splitsFor(entryId: existing.id);
      if (splits.isNotEmpty) {
        splitMode = true;
        splitRows.addAll([
          for (final s in splits)
            (
              category: TextEditingController(text: s.category),
              amount: TextEditingController(
                  text: (s.amountCents / 100).toString()),
            ),
        ]);
      }
      final tagsByEntry =
          await repo.watchEntryTagNames(profileId: profileId).first;
      existingTags = tagsByEntry[existing.id] ?? [];
    }
    final tags = TextEditingController(text: existingTags.join(', '));
    final accounts = (await repo.watchAccounts(profileId: profileId).first)
        .where((a) =>
            HomebaseRepository.cashAccountTypes.contains(a.type) ||
            a.id == existing?.accountId)
        .toList();
    final cards = await repo.watchCards(profileId: profileId).first;
    if (!context.mounted) return;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(existing == null ? 'Add entry' : 'Edit entry'),
          content: SizedBox(
            width: 360,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SegmentedButton<EntryType>(
                segments: const [
                  ButtonSegment(
                      value: EntryType.expense, label: Text('Expense')),
                  ButtonSegment(
                      value: EntryType.income, label: Text('Income')),
                ],
                selected: {type},
                onSelectionChanged: (s) => setState(() => type = s.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: description,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => Navigator.pop(context, true),
                decoration: const InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
                onChanged: (text) async {
                  final match = await repo.categorize(
                      profileId: profileId,
                      description: text,
                      amountCents: parseDollarsToCents(amount.text));
                  if (match != null &&
                      (category.text.isEmpty || autoCategorized)) {
                    setState(() {
                      category.text = match;
                      autoCategorized = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                  controller: amount,
                  onSubmitted: (_) => Navigator.pop(context, true),
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                      labelText: 'Amount (\$)',
                      border: OutlineInputBorder())),
              const SizedBox(height: 12),
              if (!splitMode)
                TextField(
                    controller: category,
                    onSubmitted: (_) => Navigator.pop(context, true),
                    onChanged: (_) => autoCategorized = false,
                    decoration: InputDecoration(
                        labelText: 'Category',
                        helperText: autoCategorized
                            ? 'Auto-categorized by rule'
                            : null,
                        border: const OutlineInputBorder())),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Split into categories'),
                subtitle: const Text(
                    'Break this amount across more than one category'),
                value: splitMode,
                onChanged: (v) => setState(() {
                  splitMode = v;
                  if (v && splitRows.isEmpty) {
                    splitRows.addAll([
                      (
                        category: TextEditingController(),
                        amount: TextEditingController()
                      ),
                      (
                        category: TextEditingController(),
                        amount: TextEditingController()
                      ),
                    ]);
                  }
                }),
              ),
              if (splitMode) ...[
                for (var i = 0; i < splitRows.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: splitRows[i].category,
                          decoration: const InputDecoration(
                              labelText: 'Category',
                              isDense: true,
                              border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: splitRows[i].amount,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                              labelText: '\$',
                              isDense: true,
                              border: OutlineInputBorder()),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 18),
                        onPressed: splitRows.length <= 1
                            ? null
                            : () => setState(() => splitRows.removeAt(i)),
                      ),
                    ]),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add split'),
                    onPressed: () => setState(() => splitRows.add((
                          category: TextEditingController(),
                          amount: TextEditingController(),
                        ))),
                  ),
                ),
                Builder(builder: (context) {
                  final total = parseDollarsToCents(amount.text) ?? 0;
                  final splitTotal = splitRows.fold<int>(
                      0, (s, r) => s + (parseDollarsToCents(r.amount.text) ?? 0));
                  final matches = splitTotal == total;
                  return Text(
                    '${fmtCents(splitTotal)} of ${fmtCents(total)} allocated',
                    style: TextStyle(
                        fontSize: 12,
                        color:
                            matches ? null : Theme.of(context).colorScheme.error),
                  );
                }),
                const SizedBox(height: 4),
              ],
              const SizedBox(height: 12),
              TextField(
                  controller: payee,
                  onSubmitted: (_) => Navigator.pop(context, true),
                  decoration: const InputDecoration(
                      labelText: 'Payee (optional)',
                      border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                  controller: tags,
                  onSubmitted: (_) => Navigator.pop(context, true),
                  decoration: const InputDecoration(
                      labelText: 'Tags (optional, comma separated)',
                      border: OutlineInputBorder())),
              if (accounts.isNotEmpty || cards.isNotEmpty) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: source,
                  decoration: const InputDecoration(
                      labelText: 'Account or card (optional)',
                      helperText: 'Linking one moves this amount off (or '
                          'onto) its balance',
                      border: OutlineInputBorder()),
                  items: [
                    const DropdownMenuItem(
                        value: null, child: Text('Not linked')),
                    for (final a in accounts)
                      DropdownMenuItem(
                        value: 'account:${a.id}',
                        child: Row(children: [
                          Icon(accountIcon(a.type), size: 16, color: accountTypeColor(context, a.type)),
                          const SizedBox(width: 8),
                          Text(a.name),
                        ]),
                      ),
                    for (final c in cards)
                      DropdownMenuItem(
                        value: 'card:${c.id}',
                        child: Row(children: [
                          const Icon(Icons.credit_card, size: 16),
                          const SizedBox(width: 8),
                          Text(c.name),
                        ]),
                      ),
                  ],
                  onChanged: (v) => setState(() => source = v),
                ),
              ],
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(existing == null ? 'Save' : 'Save changes')),
          ],
        ),
      ),
    );
    if (saved != true) return;
    final cents = parseDollarsToCents(amount.text);
    if (cents == null) {
      if (context.mounted) warnNotSaved(context, 'enter an amount');
      return;
    }
    // Splits are set unconditionally when editing (even to an empty list)
    // so turning split mode off on a previously-split entry actually
    // clears the old ones instead of leaving them behind.
    List<({String category, int amountCents})> splits = [];
    if (splitMode) {
      splits = [
        for (final row in splitRows)
          if (row.category.text.trim().isNotEmpty)
            (
              category: row.category.text.trim(),
              amountCents: parseDollarsToCents(row.amount.text) ?? 0,
            ),
      ];
      final splitTotal = splits.fold(0, (s, r) => s + r.amountCents);
      if (splits.isEmpty || splitTotal != cents) {
        if (context.mounted) {
          warnNotSaved(context, 'splits must add up to the total amount');
        }
        return;
      }
    }
    final sourceParts = source?.split(':');
    final isAccount = sourceParts == null || sourceParts[0] == 'account';
    final categoryValue = Value(splitMode
        ? 'Split'
        : category.text.trim().isEmpty
            ? 'Other'
            : category.text.trim());
    final descriptionValue = Value(
        description.text.trim().isEmpty ? null : description.text.trim());
    final payeeValue =
        Value(payee.text.trim().isEmpty ? null : payee.text.trim());
    final accountIdValue = Value(
        sourceParts == null || !isAccount ? null : int.parse(sourceParts[1]));
    final cardIdValue = Value(
        sourceParts == null || isAccount ? null : int.parse(sourceParts[1]));

    final int entryId;
    if (existing == null) {
      entryId = await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: DateTime.now(),
        amountCents: cents,
        type: type,
        category: categoryValue,
        description: descriptionValue,
        payee: payeeValue,
        accountId: accountIdValue,
        cardId: cardIdValue,
      ));
    } else {
      entryId = existing.id;
      await repo.updateBudgetEntry(
        profileId: profileId,
        id: existing.id,
        entry: BudgetEntriesCompanion(
          amountCents: Value(cents),
          type: Value(type),
          category: categoryValue,
          description: descriptionValue,
          payee: payeeValue,
          accountId: accountIdValue,
          cardId: cardIdValue,
        ),
      );
    }
    await repo.setEntrySplits(
        profileId: profileId, entryId: entryId, splits: splits);
    // Set unconditionally, same as splits above — clears old tags on an
    // edit that removes them, and is a harmless no-op for a fresh entry.
    await repo.setEntryTags(
        profileId: profileId,
        entryId: entryId,
        tagNames: tags.text.split(','));
  }

  Future<void> _manageTargets(BuildContext context) async {
    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;
    final category = TextEditingController();
    final target = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Budget targets'),
        content: SizedBox(
          width: 420,
          height: 400,
          child: Column(children: [
            StatefulBuilder(builder: (context, _) {
              Future<void> add() async {
                final cents = parseDollarsToCents(target.text);
                if (category.text.trim().isEmpty || cents == null) return;
                await repo.upsertBudgetTarget(BudgetTargetsCompanion.insert(
                    profileId: profileId,
                    category: category.text.trim(),
                    monthlyTargetCents: cents));
                category.clear();
                target.clear();
              }

              return Row(children: [
                Expanded(
                    child: TextField(
                        controller: category,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => add(),
                        decoration:
                            const InputDecoration(labelText: 'Category'))),
                const SizedBox(width: 8),
                SizedBox(
                    width: 110,
                    child: TextField(
                        controller: target,
                        onSubmitted: (_) => add(),
                        decoration: const InputDecoration(
                            labelText: 'Target \$'))),
                IconButton(
                    tooltip: 'Add target',
                    icon: const Icon(Icons.add),
                    onPressed: add),
              ]);
            }),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<BudgetTarget>>(
                stream: repo.watchBudgetTargets(profileId: profileId),
                builder: (context, snap) {
                  final targets = snap.data ?? [];
                  return ListView(children: [
                    for (final t in targets)
                      ListTile(
                        title: Text(t.category),
                        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(fmtCents(t.monthlyTargetCents)),
                          IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 18),
                              onPressed: () => repo.deleteBudgetTarget(
                                  profileId: profileId, id: t.id)),
                        ]),
                      ),
                  ]);
                },
              ),
            ),
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done')),
        ],
      ),
    );
  }

  Future<void> _manageRules(BuildContext context) async {
    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;
    final pattern = TextEditingController();
    final category = TextEditingController();
    var field = RuleField.description;
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          Future<void> addRule() async {
            if (pattern.text.trim().isEmpty || category.text.trim().isEmpty) {
              return;
            }
            await repo.upsertRule(CategoryRulesCompanion.insert(
                profileId: profileId,
                field: field,
                pattern: pattern.text.trim(),
                category: category.text.trim()));
            pattern.clear();
            category.clear();
          }

          return AlertDialog(
          title: const Text('Auto-categorization rules'),
          content: SizedBox(
            width: 480,
            height: 420,
            child: Column(children: [
              Row(children: [
                DropdownButton<RuleField>(
                  value: field,
                  items: const [
                    DropdownMenuItem(
                        value: RuleField.description,
                        child: Text('Description contains')),
                    DropdownMenuItem(
                        value: RuleField.amount,
                        child: Text('Amount equals')),
                  ],
                  onChanged: (v) => setState(() => field = v!),
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: TextField(
                        controller: pattern,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => addRule(),
                        decoration:
                            const InputDecoration(labelText: 'Pattern'))),
                const SizedBox(width: 8),
                SizedBox(
                    width: 110,
                    child: TextField(
                        controller: category,
                        onSubmitted: (_) => addRule(),
                        decoration:
                            const InputDecoration(labelText: 'Category'))),
                IconButton(
                  tooltip: 'Add rule',
                  icon: const Icon(Icons.add),
                  onPressed: addRule,
                ),
              ]),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<List<CategoryRule>>(
                  stream: repo.watchRules(profileId: profileId),
                  builder: (context, snap) {
                    final rules = snap.data ?? [];
                    return ListView(children: [
                      for (final r in rules)
                        ListTile(
                          title: Text(
                              '${r.field == RuleField.description ? 'description contains' : 'amount ='} "${r.pattern}"'),
                          subtitle: Text('→ ${r.category}'),
                          trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 18),
                              onPressed: () => repo.deleteRule(
                                  profileId: profileId, id: r.id)),
                        ),
                    ]);
                  },
                ),
              ),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done')),
          ],
        );
        },
      ),
    );
  }
}
