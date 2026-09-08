import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';
import 'accounts.dart' show accountIcon, accountTypeColor;

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];

String freqLabel(BillFrequency f) => switch (f) {
      BillFrequency.monthly => 'Monthly',
      BillFrequency.quarterly => 'Quarterly',
      BillFrequency.annual => 'Annual',
      BillFrequency.oneTime => 'One-time',
    };

/// The name of the account or card a bill is paid from, or null if it
/// has no payment source set (or that source has since been deleted).
String? _sourceLabel(
    Bill b, List<Account> accounts, List<CreditCard> cards) {
  if (b.paymentSourceType == null || b.paymentSourceId == null) return null;
  return switch (b.paymentSourceType!) {
    PaymentSourceType.account => accounts
        .where((a) => a.id == b.paymentSourceId)
        .firstOrNull
        ?.name,
    PaymentSourceType.card =>
      cards.where((c) => c.id == b.paymentSourceId).firstOrNull?.name,
  };
}

IconData freqIcon(BillFrequency f) => switch (f) {
      BillFrequency.monthly => Icons.repeat,
      BillFrequency.quarterly => Icons.calendar_view_month,
      BillFrequency.annual => Icons.event_repeat,
      BillFrequency.oneTime => Icons.looks_one_outlined,
    };

class BillsScreen extends ConsumerStatefulWidget {
  const BillsScreen({super.key});

  @override
  ConsumerState<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends ConsumerState<BillsScreen> {
  /// Which month is on screen. Defaults to now, so the list is correct on
  /// launch and every bill shows unpaid again once a new month starts.
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _month.year == now.year && _month.month == now.month;
  }

  @override
  void initState() {
    super.initState();
    _materializeAutopay();
  }

  /// Write real payment rows for autopay bills already past due, so their
  /// spending reaches the budget instead of only being implied.
  void _materializeAutopay() {
    Future.microtask(() {
      if (!mounted) return;
      ref.read(repositoryProvider).materializeAutopayPayments(
            profileId: ref.read(activeProfileProvider)!.id,
            month: _month,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(null),
        icon: const Icon(Icons.add),
        label: const Text('Add bill'),
      ),
      body: StreamBuilder<List<Account>>(
        stream: repo.watchAccounts(profileId: profileId),
        builder: (context, accountsSnap) {
          final accounts = accountsSnap.data ?? [];
          return StreamBuilder<List<CreditCard>>(
            stream: repo.watchCards(profileId: profileId),
            builder: (context, cardsSnap) {
              final cards = cardsSnap.data ?? [];
              return _body(context, repo, profileId, scheme, accounts, cards);
            },
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, HomebaseRepository repo, int profileId,
      ColorScheme scheme, List<Account> accounts, List<CreditCard> cards) {
    return StreamBuilder<List<({Bill bill, bool paid})>>(
        stream:
            repo.watchBillsForMonth(profileId: profileId, month: _month),
        builder: (context, snap) {
          final rows = snap.data ?? [];
          if (rows.isEmpty) {
            return Column(
              children: [
                _monthBar(context, unpaidCount: 0),
                const Expanded(
                  child: EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No bills yet',
                    message:
                        'Add recurring bills to track due dates and what is '
                        'still unpaid this month.',
                  ),
                ),
              ],
            );
          }
          final unpaid = rows.where((r) => !r.paid).toList();
          final dueThisMonthCents =
              rows.fold(0, (s, r) => s + r.bill.amountCents);
          final unpaidCents = unpaid.fold(0, (s, r) => s + r.bill.amountCents);
          final today = DateTime.now();

          return Column(
            children: [
              _monthBar(context, unpaidCount: unpaid.length),
              Expanded(
                child: ListView(
                  padding: kPagePadding,
                  children: [
                    Wrap(spacing: 16, runSpacing: 16, children: [
                      StatCard(
                        label: 'Due this month',
                        value: fmtCents(dueThisMonthCents),
                        icon: Icons.summarize_outlined,
                        color: scheme.secondary,
                        note: '${rows.length} '
                            '${rows.length == 1 ? 'bill' : 'bills'}',
                      ),
                      StreamBuilder<int>(
                        stream: ref
                            .watch(repositoryProvider)
                            .watchMonthlyBillsCents(profileId: profileId),
                        builder: (context, monthlySnap) => StatCard(
                          label: 'True monthly cost',
                          value: '${fmtCents(monthlySnap.data ?? 0)} / mo',
                          icon: Icons.calculate_outlined,
                          color: scheme.secondary,
                          info: const InfoButton(
                            title: 'True monthly cost',
                            body: [
                              'What your recurring bills average out to per '
                                  'month, with longer billing periods spread '
                                  'across their term.',
                              'A quarterly bill counts as a third each month '
                                  'and an annual subscription as a twelfth, '
                                  'so an \$80/year subscription shows as '
                                  '\$6.67 a month.',
                              'This is the figure used on the Budget screen '
                                  'to work out what you have left, because it '
                                  'is what you need to set aside each month '
                                  'even in months nothing is charged.',
                              'One-time bills are excluded — they are not an '
                                  'ongoing cost.',
                            ],
                          ),
                        ),
                      ),
                      StatCard(
                        label: 'Still unpaid',
                        value: fmtCents(unpaidCents),
                        icon: Icons.pending_actions_outlined,
                        color: unpaid.isEmpty ? scheme.primary : scheme.error,
                        note: unpaid.isEmpty
                            ? 'all paid'
                            : '${unpaid.length} of ${rows.length} left',
                      ),
                    ]),
                    kSectionGap,
                    SectionHeader('Bills',
                        icon: Icons.receipt_long_outlined,
                        info: const InfoButton(
                          title: 'How paid status works',
                          body: [
                            'Paid status is recorded against the month it '
                                'covers, not as a single on/off flag.',
                            'That means nothing to reset: on the 1st every '
                                'bill shows unpaid again automatically, and '
                                'past months keep their real history — step '
                                'back with the arrows to see them.',
                            'A due day later than a short month (the 31st in '
                                'February) is treated as the last day of '
                                'that month.',
                            'Autopay bills are different: once their due '
                                'date passes they mark themselves paid, with '
                                'no checkbox to click and no overdue warning.',
                          ],
                        )),
                    for (final row in rows)
                      _billTile(context, row, today, scheme, accounts, cards),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _monthBar(BuildContext context, {required int unpaidCount}) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest
          .withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Previous month',
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(
                    () => _month = DateTime(_month.year, _month.month - 1));
                _materializeAutopay();
              },
            ),
            Text('${_monthNames[_month.month - 1]} ${_month.year}',
                style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              tooltip: 'Next month',
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(
                    () => _month = DateTime(_month.year, _month.month + 1));
                _materializeAutopay();
              },
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
            Text(
              unpaidCount == 0
                  ? 'Everything paid'
                  : '$unpaidCount unpaid',
              style: TextStyle(
                  color: unpaidCount == 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billTile(BuildContext context, ({Bill bill, bool paid}) row,
      DateTime today, ColorScheme scheme, List<Account> accounts,
      List<CreditCard> cards) {
    final b = row.bill;
    final lastDay = DateTime(_month.year, _month.month + 1, 0).day;
    final dueDate = DateTime(
        _month.year, _month.month, b.dueDay > lastDay ? lastDay : b.dueDay);
    final overdue = !row.paid &&
        !b.autopay &&
        _month.year == today.year &&
        _month.month == today.month &&
        dueDate.isBefore(DateTime(today.year, today.month, today.day));
    final profileId = ref.read(activeProfileProvider)!.id;
    final sourceLabel = _sourceLabel(b, accounts, cards);

    return Card(
      child: CheckboxListTile(
        value: row.paid,
        onChanged: b.autopay && row.paid
            ? null
            : (v) => ref.read(repositoryProvider).setBillPaid(
                  profileId: profileId,
                  billId: b.id,
                  month: _month,
                  paid: v ?? false,
                ),
        title: Row(children: [
          Flexible(child: Text(b.name)),
          if (b.autopay) ...[
            const SizedBox(width: 6),
            Icon(Icons.autorenew, size: 14, color: scheme.primary),
          ],
        ]),
        subtitle: Row(
          children: [
            Icon(
                overdue
                    ? Icons.warning_amber_outlined
                    : freqIcon(b.frequency),
                size: 14,
                color: overdue ? scheme.error : null),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                'Due the ${ordinalDay(dueDate.day)} of '
                '${_monthNames[dueDate.month - 1]}'
                '${overdue ? ' • overdue' : ''} • ${b.category}'
                ' • ${freqLabel(b.frequency)}'
                '${sourceLabel == null ? '' : ' • $sourceLabel'}',
                style: TextStyle(color: overdue ? scheme.error : null),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        secondary: SizedBox(
          width: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(fmtCents(b.amountCents),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () => _edit(b)),
              IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: () => _delete(b)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _delete(Bill b) async {
    final profileId = ref.read(activeProfileProvider)!.id;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${b.name}?'),
        content: const Text('Its payment history is deleted too.'),
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
          .deleteBill(profileId: profileId, id: b.id);
    }
  }

  Future<void> _edit(Bill? existing) async {
    final profileId = ref.read(activeProfileProvider)!.id;
    final name = TextEditingController(text: existing?.name);
    final amount = TextEditingController(
        text: existing == null ? '' : (existing.amountCents / 100).toString());
    final dueDay =
        TextEditingController(text: existing?.dueDay.toString() ?? '');
    final category = TextEditingController(text: existing?.category ?? '');
    var frequency = existing?.frequency ?? BillFrequency.monthly;
    var dueMonth = existing?.dueMonth ?? _month.month;
    var dueYear = existing?.dueYear ?? _month.year;
    var autopay = existing?.autopay ?? false;
    final repo = ref.read(repositoryProvider);
    // Retirement and investment accounts aren't something you'd pay a bill
    // from — left out of the picker, unless a bill already uses one, so
    // editing it doesn't strand the dropdown on a value with no matching
    // item.
    final accounts = (await repo.watchAccounts(profileId: profileId).first)
        .where((a) =>
            HomebaseRepository.cashAccountTypes.contains(a.type) ||
            (existing?.paymentSourceType == PaymentSourceType.account &&
                a.id == existing?.paymentSourceId))
        .toList();
    final cards = await repo.watchCards(profileId: profileId).first;
    // Encoded as "account:3" or "card:2" so one dropdown can offer both.
    String? source = existing?.paymentSourceType == null
        ? null
        : '${existing!.paymentSourceType!.name}:${existing.paymentSourceId}';
    if (!context.mounted) return;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) {
          final needsMonth = frequency != BillFrequency.monthly;
          return SubmitOnEnter(
            onSubmit: () => Navigator.pop(context, true),
            child: AlertDialog(
          title: Text(existing == null ? 'Add bill' : 'Edit bill'),
          content: SizedBox(
            width: 380,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                DialogField(name, 'Name', autofocus: true),
                DialogField(amount, 'Amount (\$)',
                    helper: 'The amount charged each time, not per month'),
                DropdownButtonFormField<BillFrequency>(
                  initialValue: frequency,
                  decoration: InputDecoration(
                      labelText: 'Frequency',
                      helperText: switch (frequency) {
                        BillFrequency.monthly => 'Charged every month',
                        BillFrequency.quarterly =>
                          'Charged every 3 months starting in the month below',
                        BillFrequency.annual =>
                          'Charged once a year in the month below',
                        BillFrequency.oneTime => 'Charged once, then done',
                      },
                      helperMaxLines: 2,
                      border: const OutlineInputBorder()),
                  items: [
                    for (final f in BillFrequency.values)
                      DropdownMenuItem(
                        value: f,
                        child: Row(children: [
                          Icon(freqIcon(f), size: 16),
                          const SizedBox(width: 8),
                          Text(freqLabel(f)),
                        ]),
                      ),
                  ],
                  onChanged: (v) => setLocal(() => frequency = v!),
                ),
                const SizedBox(height: 12),
                if (needsMonth)
                  Row(children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: dueMonth,
                        decoration: InputDecoration(
                            labelText: frequency == BillFrequency.quarterly
                                ? 'First month'
                                : 'Month',
                            border: const OutlineInputBorder()),
                        items: [
                          for (var m = 1; m <= 12; m++)
                            DropdownMenuItem(
                                value: m, child: Text(_monthNames[m - 1])),
                        ],
                        onChanged: (v) => setLocal(() => dueMonth = v!),
                      ),
                    ),
                    if (frequency == BillFrequency.oneTime) ...[
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 110,
                        child: DropdownButtonFormField<int>(
                          initialValue: dueYear,
                          decoration: const InputDecoration(
                              labelText: 'Year',
                              border: OutlineInputBorder()),
                          items: [
                            for (var y = DateTime.now().year - 1;
                                y <= DateTime.now().year + 5;
                                y++)
                              DropdownMenuItem(
                                  value: y, child: Text('$y')),
                          ],
                          onChanged: (v) => setLocal(() => dueYear = v!),
                        ),
                      ),
                    ],
                  ]),
                if (needsMonth) const SizedBox(height: 12),
                DialogField(dueDay, 'Day of the month it is due (1-31)',
                    helper: 'Days past the end of a short month move to its '
                        'last day'),
                DialogField(category, 'Category'),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: const Icon(Icons.autorenew),
                  title: const Text('Autopay'),
                  subtitle: const Text(
                      'Charged automatically — marks itself paid once the '
                      'due date passes, no overdue warning'),
                  value: autopay,
                  onChanged: (v) => setLocal(() => autopay = v),
                ),
                if (accounts.isNotEmpty || cards.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String?>(
                    initialValue: source,
                    decoration: const InputDecoration(
                        labelText: 'Paid from (optional)',
                        helperText: 'Marking this bill paid will move the '
                            'amount off an account\'s balance, or onto a '
                            'card\'s',
                        helperMaxLines: 2,
                        border: OutlineInputBorder()),
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text('Not linked')),
                      for (final a in accounts)
                        DropdownMenuItem(
                          value: 'account:${a.id}',
                          child: Row(children: [
                            Icon(accountIcon(a.type),
                                size: 16,
                                color: accountTypeColor(context, a.type)),
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
                    onChanged: (v) => setLocal(() => source = v),
                  ),
                ],
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
        );
        },
      ),
    );
    if (saved != true) return;
    if (name.text.trim().isEmpty) {
      if (mounted) warnNotSaved(context, 'the bill needs a name');
      return;
    }
    final sourceParts = source?.split(':');
    await ref.read(repositoryProvider).upsertBill(BillsCompanion(
          id: existing == null ? const Value.absent() : Value(existing.id),
          profileId: Value(profileId),
          name: Value(name.text.trim()),
          amountCents: Value(parseDollarsToCents(amount.text) ?? 0),
          dueDay: Value((int.tryParse(dueDay.text) ?? 1).clamp(1, 31)),
          category: Value(
              category.text.trim().isEmpty ? 'Other' : category.text.trim()),
          frequency: Value(frequency),
          dueMonth: Value(
              frequency == BillFrequency.monthly ? null : dueMonth),
          dueYear:
              Value(frequency == BillFrequency.oneTime ? dueYear : null),
          autopay: Value(autopay),
          paymentSourceType: Value(sourceParts == null
              ? null
              : PaymentSourceType.values.byName(sourceParts[0])),
          paymentSourceId: Value(
              sourceParts == null ? null : int.parse(sourceParts[1])),
        ));
  }
}
