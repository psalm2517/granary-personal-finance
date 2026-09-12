import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/reminder.dart';
import '../data/repository.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';
import 'accounts.dart' show accountIcon, accountTypeColor;

/// Two dashboard sections side by side on a wide window instead of always
/// stacking full-width — this is a desktop-first app with room to spare,
/// and a single narrow column of medium-sized sections just leaves the
/// rest of the window empty. Falls back to stacking below ~820px wide.
Widget _dashRow(Widget left, Widget right) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < 820) {
        return Column(children: [left, kSectionGap, right]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: 24),
          Expanded(child: right),
        ],
      );
    },
  );
}

/// Wraps a line-chart [CustomPainter] with mouse hover: tracks the nearest
/// data point under the cursor, redraws the painter with a crosshair there
/// via [painterBuilder], and floats a small value/date tooltip above it.
class _HoverLineChart extends StatefulWidget {
  const _HoverLineChart({
    required this.height,
    required this.dates,
    required this.values,
    required this.painterBuilder,
  });

  final double height;
  final List<DateTime> dates;
  final List<int> values;
  final CustomPainter Function(int? hoverIndex) painterBuilder;

  @override
  State<_HoverLineChart> createState() => _HoverLineChartState();
}

class _HoverLineChartState extends State<_HoverLineChart> {
  int? _hoverIndex;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  void _updateHover(double localX, double width) {
    if (widget.dates.length < 2) return;
    final ratio = (localX / width).clamp(0.0, 1.0);
    final index = (ratio * (widget.dates.length - 1)).round();
    if (index == _hoverIndex) return;
    setState(() => _hoverIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (widget.dates.length < 2) {
      return SizedBox(
        height: widget.height,
        width: double.infinity,
        child: CustomPaint(
          size: Size.infinite,
          painter: widget.painterBuilder(null),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final hover = _hoverIndex;
        // Tooltip x, clamped so it never runs off either edge of the chart.
        final tooltipWidth = 100.0;
        final rawX = hover == null
            ? 0.0
            : hover / (widget.dates.length - 1) * width;
        final tooltipLeft =
            (rawX - tooltipWidth / 2).clamp(0.0, width - tooltipWidth);
        return MouseRegion(
          onHover: (event) => _updateHover(event.localPosition.dx, width),
          onExit: (_) => setState(() => _hoverIndex = null),
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size.infinite,
                  painter: widget.painterBuilder(hover),
                ),
                if (hover != null)
                  Positioned(
                    left: tooltipLeft,
                    top: -8,
                    width: tooltipWidth,
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              fmtCents(widget.values[hover]),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                            Text(
                              '${_months[widget.dates[hover].month - 1]} '
                              '${widget.dates[hover].day}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: kPagePadding,
      children: [
        FutureBuilder<List<Reminder>>(
          future: repo.upcomingReminders(profileId: profileId),
          builder: (context, snap) {
            final reminders = snap.data ?? [];
            if (reminders.isEmpty) return const SizedBox.shrink();
            final now = DateTime.now();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  'Coming up',
                  icon: Icons.notifications_active_outlined,
                  info: const InfoButton(
                    title: 'Coming up',
                    body: [
                      'Anything needing attention in the next few days: '
                          'unpaid bills coming due, and card or loan '
                          'payments approaching.',
                      'Autopay bills are left out — there is nothing for '
                          'you to do about them, and they mark themselves '
                          'paid once their date passes.',
                      'Credit card annual fees appear 14 days ahead rather '
                          'than three. They are large, come once a year, '
                          'and are worth deciding about — keep the card or '
                          'cancel before it charges — while there is still '
                          'time to act.',
                      'A desktop notification is also shown when Clearly '
                          'opens and finds something due. Notifications '
                          'cannot fire while the app is closed, so treat '
                          'this panel as the reliable version.',
                    ],
                  ),
                ),
                Card(
                  color: scheme.errorContainer.withValues(alpha: 0.25),
                  child: Column(
                    children: [
                      for (final r in reminders)
                        ListTile(
                          leading: Icon(switch (r.kind) {
                            ReminderKind.bill => Icons.receipt_long_outlined,
                            ReminderKind.cardPayment => Icons.credit_card,
                            ReminderKind.loanPayment =>
                              Icons.request_quote_outlined,
                            ReminderKind.annualFee => Icons.event_repeat,
                          }, color: scheme.error),
                          title: Row(
                            children: [
                              Flexible(child: Text(r.title)),
                              if (r.kind == ReminderKind.annualFee) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: scheme.error.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Annual fee',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: scheme.error,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            switch (r.daysUntil(now)) {
                                  <= 0 => 'Due today',
                                  1 => 'Due tomorrow',
                                  final d =>
                                    'Due in $d days — the '
                                        '${ordinalDay(r.date.day)}',
                                } +
                                (r.kind == ReminderKind.annualFee
                                    ? ' • worth deciding whether to keep the '
                                          'card'
                                    : ''),
                          ),
                          trailing: Text(
                            fmtCents(r.amountCents),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                ),
                kSectionGap,
              ],
            );
          },
        ),
        StreamBuilder<({int assetsCents, int debtsCents, int netCents})>(
          stream: repo.watchNetWorth(profileId: profileId),
          builder: (context, snap) {
            final net = snap.data;
            return StreamBuilder<List<CreditCard>>(
              stream: repo.watchCards(profileId: profileId),
              builder: (context, cardSnap) {
                final cards = cardSnap.data ?? [];
                final overall = HomebaseRepository.overallUtilization(cards);
                // Filling the row instead of a Wrap of fixed-width cards —
                // four cards evenly using the full page width rather than
                // leaving the right side of a wide window empty.
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: StatCard(
                        label: 'Net worth',
                        value: net == null ? '—' : fmtCents(net.netCents),
                        icon: Icons.savings_outlined,
                        color: (net?.netCents ?? 0) >= 0
                            ? scheme.primary
                            : scheme.error,
                        note: net == null ? null : 'assets minus debts',
                        width: double.infinity,
                        info: const InfoButton(
                          title: 'Net worth',
                          body: [
                            'Everything you own minus everything you owe.',
                            'Assets are the balances of your accounts '
                                '(checking, savings, cash, investment, '
                                'retirement). Debts are your credit card '
                                'balances plus your loan balances.',
                            'A negative number is normal early on, '
                                'especially with student loans or a car '
                                'note. What matters is the direction it '
                                'moves over time.',
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        label: 'Assets',
                        value: net == null ? '—' : fmtCents(net.assetsCents),
                        icon: Icons.account_balance_outlined,
                        color: scheme.secondary,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        label: 'Total debt',
                        value: net == null ? '—' : fmtCents(net.debtsCents),
                        icon: Icons.credit_card,
                        color: scheme.error,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        label: 'Credit utilization',
                        value: cards.isEmpty
                            ? '—'
                            : '${(overall * 100).toStringAsFixed(1)}%',
                        icon: Icons.donut_large_outlined,
                        color: overall > 0.30 ? scheme.error : scheme.primary,
                        note: cards.isEmpty
                            ? null
                            : 'across ${cards.length} '
                                  '${cards.length == 1 ? 'card' : 'cards'}',
                        width: double.infinity,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        kSectionGap,
        StreamBuilder<List<NetWorthSnapshot>>(
          stream: repo.watchNetWorthHistory(profileId: profileId),
          builder: (context, snap) {
            final history = snap.data ?? [];
            final first = history.isEmpty ? null : history.first;
            final last = history.isEmpty ? null : history.last;
            final change = (first == null || last == null)
                ? 0
                : last.netWorthCents - first.netWorthCents;
            // Percent change is undefined starting from exactly zero — the
            // dollar figure still says everything useful in that case.
            final changePercent = (first == null || first.netWorthCents == 0)
                ? null
                : change / first.netWorthCents.abs() * 100;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  'Net worth trend',
                  icon: Icons.timeline,
                  info: const InfoButton(
                    title: 'Net worth trend',
                    body: [
                      'Your net worth recorded over time, so you can see '
                          'the direction rather than just today\'s number.',
                      'One point is kept per day. It is written when you '
                          'open Clearly on a new day, and updated '
                          'whenever a balance changes — so editing a '
                          'balance corrects today\'s figure rather than '
                          'adding a second point.',
                      'That means a line needs two separate days: the '
                          'trend builds as you use the app, not all at '
                          'once.',
                      'The dashed line is zero. Below it you owe more than '
                          'you own, which is common with a car loan or '
                          'student debt; what matters is the slope.',
                      'History starts from when you first ran this version, '
                          'so the line will look short until a few days '
                          'have passed.',
                    ],
                  ),
                ),
                // No card wrapper here, deliberately: the hero number and
                // chart sit directly on the page background, full-bleed,
                // rather than boxed — the one place a bordered container
                // would compete with the thing it's the whole page for.
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: history.isEmpty
                      ? const EmptyState(
                          icon: Icons.timeline,
                          title: 'No history yet',
                          message:
                              'Add an account, card or loan and '
                              'Clearly starts recording your net worth.',
                        )
                      : _dashRow(
                          _NetWorthHero(
                            last: last!,
                            history: history,
                            change: change,
                            changePercent: changePercent,
                            scheme: scheme,
                          ),
                          StreamBuilder<
                            ({int assetsCents, int debtsCents, int netCents})
                          >(
                            stream: repo.watchNetWorth(profileId: profileId),
                            builder: (context, netSnap) {
                              final net = netSnap.data;
                              if (net == null) return const SizedBox.shrink();
                              return StreamBuilder<List<Account>>(
                                stream:
                                    repo.watchAccounts(profileId: profileId),
                                builder: (context, accountsSnap) {
                                  final accounts = accountsSnap.data ?? [];
                                  return StreamBuilder<List<CreditCard>>(
                                    stream: repo.watchCards(
                                        profileId: profileId),
                                    builder: (context, cardsSnap) {
                                      final cards = cardsSnap.data ?? [];
                                      return StreamBuilder<List<Loan>>(
                                        stream: repo.watchLoans(
                                            profileId: profileId),
                                        builder: (context, loansSnap) {
                                          final loans = loansSnap.data ?? [];
                                          return _AssetsDebtBreakdown(
                                            net: net,
                                            scheme: scheme,
                                            accounts: accounts,
                                            cards: cards,
                                            loans: loans,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
        kSectionGap,
        FutureBuilder<List<({DateTime date, int balanceCents})>>(
          future: repo.projectCashFlow(profileId: profileId),
          builder: (context, snap) {
            final points = snap.data ?? [];
            if (points.isEmpty) return const SizedBox.shrink();
            final start = points.first.balanceCents;
            final end = points.last.balanceCents;
            final lowest = points
                .map((p) => p.balanceCents)
                .reduce((a, b) => a < b ? a : b);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  'Projected cash balance',
                  icon: Icons.trending_up,
                  info: const InfoButton(
                    title: 'Projected cash balance',
                    body: [
                      'A projection of your balance, not your flow — see '
                          '"Cashflow" below for money in versus out by '
                          'month. This is where checking, savings and cash '
                          'is headed over the next 60 days, not a '
                          'prediction of unplanned spending, just what '
                          'Clearly already knows is coming: scheduled '
                          'paychecks and bills.',
                      'Investment, retirement and other account types are '
                          'left out, the same way the Accounts screen splits '
                          'Cash from Assets — this is about money you can '
                          'actually spend.',
                      'Card and loan payments, and anything not entered as '
                          'a bill or a paycheck schedule, are not included. '
                          'This gets more accurate the more of your '
                          'recurring money is set up in Clearly.',
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MoneyText(
                        fmtCents(end),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                            ),
                      ),
                      const SizedBox(height: 4),
                      Pill(
                        '${end >= start ? '+' : ''}'
                        '${fmtCents(end - start)} projected over '
                        '${points.length - 1} days'
                        '${lowest < 0 ? ' • dips negative' : ''}',
                        color: lowest < 0
                            ? scheme.error
                            : end >= start
                            ? scheme.primary
                            : scheme.error,
                      ),
                      const SizedBox(height: 16),
                      _HoverLineChart(
                        height: 140,
                        dates: [for (final p in points) p.date],
                        values: [for (final p in points) p.balanceCents],
                        painterBuilder: (hover) => _ProjectionChartPainter(
                          points: points,
                          line: scheme.primary,
                          negative: scheme.error,
                          grid: scheme.outline,
                          hoverIndex: hover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        kSectionGap,
        _dashRow(
          StreamBuilder<List<CreditCard>>(
            stream: repo.watchCards(profileId: profileId),
            builder: (context, snap) {
              final cards = snap.data ?? [];
              final overall = HomebaseRepository.overallUtilization(cards);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    'Credit utilization',
                    icon: Icons.donut_large_outlined,
                    info: const InfoButton(
                      title: 'Credit utilization',
                      body: [
                        'The share of your available credit you are currently '
                            'using: balance divided by credit limit.',
                        'Keeping it under 30% is the common guidance, because '
                            'utilization is one of the largest factors in a '
                            'credit score. Under 10% is better still.',
                        'It is measured both per card and across all cards, so '
                            'one maxed-out card can hurt even if your overall '
                            'number looks fine. Clearly flags anything above '
                            '30% in red.',
                        'Note that what the bureaus actually score you on is '
                            'the balance on your last statement, which can lag '
                            'a day or two behind what you see here right '
                            'after a payment.',
                      ],
                    ),
                    action: cards.isEmpty
                        ? null
                        : Text(
                            'Overall ${(overall * 100).toStringAsFixed(1)}%'
                            '${overall > 0.30 ? ' — over 30%' : ''}',
                            style: TextStyle(
                              color: overall > 0.30
                                  ? scheme.error
                                  : scheme.primary,
                            ),
                          ),
                  ),
                  if (cards.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: EmptyState(
                          icon: Icons.credit_card_off_outlined,
                          title: 'No credit cards',
                          message:
                              'Add cards to track balances and utilization.',
                        ),
                      ),
                    )
                  else
                    Card(
                      child: Column(
                        children: [
                          for (final c in cards)
                            _utilizationTile(context, c, scheme),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          StreamBuilder<
            List<({DateTime month, int incomeCents, int expenseCents})>
          >(
            stream: repo.watchCashflow(profileId: profileId),
            builder: (context, snap) {
              final data = snap.data ?? [];
              final hasAny = data.any(
                (d) => d.incomeCents != 0 || d.expenseCents != 0,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    'Cashflow',
                    icon: Icons.bar_chart_outlined,
                    info: InfoButton(
                      title: 'Cashflow',
                      body: [
                        'Money in versus money out for each of the last six '
                            'months, built from your Budget entries.',
                        'Green bars are income, red bars are expenses. When '
                            'the red bar is taller than the green one, you '
                            'spent more than you earned that month.',
                        'This only counts entries you have logged in Budget — '
                            'it is not pulled from your bank.',
                      ],
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: hasAny
                          ? SizedBox(
                              height: 220,
                              child: _CashflowChart(
                                data: data,
                                income: scheme.primary,
                                expense: scheme.error,
                                label: scheme.onSurface,
                              ),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(16),
                              child: EmptyState(
                                icon: Icons.bar_chart_outlined,
                                title: 'No cashflow yet',
                                message:
                                    'Add income and expenses in Budget to see '
                                    'money in versus money out by month.',
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        kSectionGap,
        _dashRow(
          StreamBuilder<List<({Bill bill, bool paid})>>(
            stream: repo.watchBillsForMonth(
              profileId: profileId,
              month: DateTime.now(),
            ),
            builder: (context, snap) {
              final rows = snap.data ?? [];
              final today = DateTime.now();
              final lastDay = DateTime(today.year, today.month + 1, 0).day;
              final windowEnd = today.add(const Duration(days: 7));
              final upcoming = rows.where((r) {
                if (r.paid) return false;
                final day = r.bill.dueDay > lastDay ? lastDay : r.bill.dueDay;
                final due = DateTime(today.year, today.month, day);
                return !due.isBefore(
                      DateTime(today.year, today.month, today.day),
                    ) &&
                    !due.isAfter(windowEnd);
              }).toList();
              final overdue = rows.where((r) {
                final day = r.bill.dueDay > lastDay ? lastDay : r.bill.dueDay;
                final due = DateTime(today.year, today.month, day);
                return !r.paid &&
                    !r.bill.autopay &&
                    due.isBefore(DateTime(today.year, today.month, today.day));
              }).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    'Bills due this week',
                    icon: Icons.event_outlined,
                    info: InfoButton(
                      title: 'Bills due this week',
                      body: [
                        'Any bill whose due day falls in the next seven days, '
                            'plus anything already overdue and unpaid this '
                            'month.',
                        'Paid status is tracked per month, so this clears '
                            'itself when a new month begins — there is '
                            'nothing to reset.',
                        'A bill due on a day later than the current month has '
                            '(the 31st in February) is treated as due on the '
                            'last day of that month.',
                      ],
                    ),
                  ),
                  if (upcoming.isEmpty && overdue.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: EmptyState(
                          icon: Icons.event_available_outlined,
                          title: 'Nothing due this week',
                          message: 'Bills due in the next 7 days appear here.',
                        ),
                      ),
                    )
                  else
                    Card(
                      child: Column(
                        children: [
                          for (final r in [...overdue, ...upcoming])
                            ListTile(
                              leading: Icon(
                                overdue.contains(r)
                                    ? Icons.warning_amber_outlined
                                    : Icons.schedule,
                                color: overdue.contains(r)
                                    ? scheme.error
                                    : scheme.primary,
                              ),
                              title: Text(r.bill.name),
                              subtitle: Text(
                                'Due the ${ordinalDay(r.bill.dueDay)} • '
                                '${r.bill.category}'
                                '${overdue.contains(r) ? ' • overdue' : ''}',
                              ),
                              trailing: Text(
                                fmtCents(r.bill.amountCents),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
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
          StreamBuilder<List<CreditScoreSnapshot>>(
            stream: repo.watchScoreHistory(profileId: profileId),
            builder: (context, snap) {
              final scores = snap.data ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    'Credit score trend',
                    icon: Icons.show_chart,
                    info: const InfoButton(
                      title: 'Credit score trend',
                      body: [
                        'Your score over time, from snapshots you log '
                            'yourself. Clearly has no connection to a credit '
                            'bureau, so nothing appears here until you enter '
                            'it — check your card issuer or a free service '
                            'and log what it says.',
                        'The main drivers: payment history (never miss a due '
                            'date), utilization (keep it low), age of '
                            'accounts (older is better, so avoid closing old '
                            'cards), credit mix, and hard inquiries (each new '
                            'application dings you briefly).',
                        'Utilization is prefilled from what your cards are '
                            'currently reporting, so the snapshot matches the '
                            'number above.',
                        'One score makes a point; two make a line.',
                      ],
                    ),
                    action: FilledButton.tonalIcon(
                      onPressed: () => _logScore(context, ref),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Log score'),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: scores.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: EmptyState(
                                icon: Icons.show_chart,
                                title: 'No scores logged yet',
                                message:
                                    'Use "Log score" to record what your card '
                                    'issuer or credit app currently reports.',
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (scores.length < 2)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          size: 16,
                                          color: scheme.onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'One score so far — log another '
                                            'next month and a trend line '
                                            'appears.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color:
                                                      scheme.onSurfaceVariant,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  SizedBox(
                                    height: 200,
                                    child: CustomPaint(
                                      size: Size.infinite,
                                      painter: _ScoreChartPainter(
                                        scores: scores,
                                        lineColor: scheme.primary,
                                        labelColor: scheme.onSurface,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                const Divider(),
                                for (final s in scores.reversed.take(6))
                                  ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: scheme.primary
                                          .withValues(alpha: 0.18),
                                      child: Text(
                                        '${s.score}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: scheme.primary,
                                        ),
                                      ),
                                    ),
                                    title: Text(_fmtScoreDate(s.date)),
                                    subtitle: Text(
                                      '${(s.utilization * 100).toStringAsFixed(1)}% '
                                      'utilization'
                                      '${s.hardInquiries > 0 ? ' • ${s.hardInquiries} '
                                                'inquir${s.hardInquiries == 1 ? 'y' : 'ies'}' : ''}'
                                      '${s.derogatoryMarks > 0 ? ' • ${s.derogatoryMarks} '
                                                'derogatory' : ''}',
                                    ),
                                    trailing: IconButton(
                                      tooltip: 'Delete this entry',
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                      ),
                                      onPressed: () => ref
                                          .read(repositoryProvider)
                                          .deleteScoreSnapshot(
                                            profileId: profileId,
                                            id: s.id,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  static String _fmtScoreDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${ordinalDay(d.day)}, ${d.year}';
  }

  /// Records what a bureau or card issuer currently reports. Utilization is
  /// prefilled from the cards already in Clearly so the snapshot agrees
  /// with the utilization shown above, but stays editable — the figure a
  /// bureau used may differ from what the cards say today.
  Future<void> _logScore(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(repositoryProvider);
    final profileId = ref.read(activeProfileProvider)!.id;

    final suggested = await repo.currentUtilization(profileId: profileId);
    if (!context.mounted) return;

    final score = TextEditingController();
    final utilization = TextEditingController(
      text: (suggested * 100).toStringAsFixed(1),
    );
    final inquiries = TextEditingController();
    final derogatory = TextEditingController();
    final accountAge = TextEditingController();
    var date = DateTime.now();
    String? error;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => SubmitOnEnter(
          onSubmit: () => Navigator.pop(context, true),
          child: AlertDialog(
            icon: const Icon(Icons.show_chart),
            title: const Text('Log a credit score'),
            content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'From your card issuer, bank or a free credit app — '
                        'Clearly cannot fetch this for you.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: score,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Score',
                        helperText: 'Usually 300-850',
                        errorText: error,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        if (error != null) setLocal(() => error = null);
                      },
                    ),
                    const SizedBox(height: 12),
                    DialogField(
                      utilization,
                      'Utilization (%)',
                      helper: 'Prefilled from your cards\' balances',
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text('Recorded ${_fmtScoreDate(date)}'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(2015),
                            lastDate: DateTime.now(),
                            helpText: 'When was this score reported?',
                          );
                          if (picked != null) setLocal(() => date = picked);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Optional detail',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DialogField(inquiries, 'Hard inquiries'),
                    DialogField(derogatory, 'Derogatory marks'),
                    DialogField(accountAge, 'Average account age (months)'),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final value = int.tryParse(score.text.trim());
                  if (value == null || value < 300 || value > 850) {
                    setLocal(() => error = 'Enter a score between 300 and 850');
                    return;
                  }
                  Navigator.pop(context, true);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );

    if (saved != true) return;
    final value = int.tryParse(score.text.trim());
    if (value == null || value < 300 || value > 850) return;

    final percent =
        double.tryParse(utilization.text.replaceAll('%', '').trim()) ??
        (suggested * 100);

    await repo.addScoreSnapshot(
      CreditScoreSnapshotsCompanion.insert(
        profileId: profileId,
        date: DateTime(date.year, date.month, date.day),
        score: value,
        utilization: (percent / 100).clamp(0.0, 1.0),
        hardInquiries: Value(int.tryParse(inquiries.text.trim()) ?? 0),
        derogatoryMarks: Value(int.tryParse(derogatory.text.trim()) ?? 0),
        accountAgeMonths: Value(int.tryParse(accountAge.text.trim()) ?? 0),
      ),
    );
  }

  Widget _utilizationTile(
    BuildContext context,
    CreditCard c,
    ColorScheme scheme,
  ) {
    final ratio = HomebaseRepository.utilizationOf(c);
    final over = ratio > 0.30;
    return ListTile(
      leading: Icon(
        Icons.credit_card,
        color: over ? scheme.error : scheme.primary,
      ),
      title: Text(c.name),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: LinearProgressIndicator(
          value: ratio.clamp(0.0, 1.0),
          color: over ? scheme.error : scheme.primary,
        ),
      ),
      trailing: Text(
        c.creditLimitCents == 0 ? '—' : '${(ratio * 100).toStringAsFixed(1)}%',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: over ? scheme.error : null,
        ),
      ),
    );
  }
}

/// The net worth headline: big neutral number, the small colored delta
/// pill, and the trend line. Split out so it can sit in the left half of a
/// [_dashRow] next to the assets/debt breakdown.
class _NetWorthHero extends StatelessWidget {
  const _NetWorthHero({
    required this.last,
    required this.history,
    required this.change,
    required this.changePercent,
    required this.scheme,
  });

  final NetWorthSnapshot last;
  final List<NetWorthSnapshot> history;
  final int change;
  final double? changePercent;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The hero number: big and neutral — direction lives in the small
        // line underneath instead of tinting the whole number red or green.
        MoneyText(
          fmtCents(last.netWorthCents),
          style: Theme.of(context).textTheme.displaySmall
              ?.copyWith(fontWeight: FontWeight.w700, fontFamily: 'monospace'),
        ),
        const SizedBox(height: 4),
        if (history.length < 2)
          Text(
            'recorded ${DashboardScreen._fmtScoreDate(last.date)}',
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          )
        else
          Pill(
            '${change >= 0 ? '+' : ''}'
            '${fmtCents(change)}'
            '${changePercent == null ? '' : ' (${changePercent! >= 0 ? '+' : ''}'
                      '${changePercent!.toStringAsFixed(1)}%)'}'
            ' over ${history.length} days',
            color: change >= 0 ? scheme.primary : scheme.error,
          ),
        const SizedBox(height: 16),
        if (history.length < 2)
          Text(
            'One day recorded so far. A line appears once there is a '
            'second day — Clearly keeps one point per day, so editing a '
            'balance today updates this figure rather than adding a point.',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          )
        else
          _HoverLineChart(
            height: 140,
            dates: [for (final h in history) h.date],
            values: [for (final h in history) h.netWorthCents],
            painterBuilder: (hover) => _NetWorthChartPainter(
              history: history,
              line: scheme.primary,
              negative: scheme.error,
              label: scheme.onSurface,
              grid: scheme.outline,
              hoverIndex: hover,
            ),
          ),
      ],
    );
  }
}

/// Assets vs. debt as a proportion bar plus the two figures — fills the
/// space next to the net worth chart with something more useful than
/// empty page, and answers "what is that number actually made of" without
/// leaving the Dashboard for the Accounts tab.
class _AssetsDebtBreakdown extends StatelessWidget {
  const _AssetsDebtBreakdown({
    required this.net,
    required this.scheme,
    required this.accounts,
    required this.cards,
    required this.loans,
  });

  final ({int assetsCents, int debtsCents, int netCents}) net;
  final ColorScheme scheme;
  final List<Account> accounts;
  final List<CreditCard> cards;
  final List<Loan> loans;

  @override
  Widget build(BuildContext context) {
    final total = net.assetsCents + net.debtsCents;
    final assetsRatio = total == 0 ? 0.5 : net.assetsCents / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Made up of',
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 8,
            child: Row(
              children: [
                Expanded(
                  flex: (assetsRatio * 1000).round().clamp(1, 999),
                  child: Container(color: scheme.secondary),
                ),
                Expanded(
                  flex: ((1 - assetsRatio) * 1000).round().clamp(1, 999),
                  child: Container(color: scheme.error),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: scheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(child: Text('Assets')),
            MoneyText(
              fmtCents(net.assetsCents),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: scheme.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(child: Text('Debt')),
            MoneyText(
              fmtCents(net.debtsCents),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (accounts.isNotEmpty || cards.isNotEmpty || loans.isNotEmpty) ...[
          const SizedBox(height: 20),
          Divider(height: 1, color: scheme.outlineVariant),
          const SizedBox(height: 16),
          if (accounts.isNotEmpty)
            () {
              final largest =
                  accounts.reduce((a, b) => b.balanceCents > a.balanceCents ? b : a);
              final pct = net.assetsCents == 0
                  ? 0.0
                  : largest.balanceCents / net.assetsCents * 100;
              return _breakdownRow(
                icon: accountIcon(largest.type),
                iconColor: accountTypeColor(context, largest.type),
                name: largest.name,
                amountCents: largest.balanceCents,
                note: '${pct.toStringAsFixed(0)}% of assets',
              );
            }(),
          if (cards.isNotEmpty || loans.isNotEmpty)
            () {
              final debts = [
                for (final c in cards) (name: c.name, balanceCents: c.balanceCents),
                for (final l in loans) (name: l.name, balanceCents: l.balanceCents),
              ];
              final largest =
                  debts.reduce((a, b) => b.balanceCents > a.balanceCents ? b : a);
              final pct = net.debtsCents == 0
                  ? 0.0
                  : largest.balanceCents / net.debtsCents * 100;
              return _breakdownRow(
                icon: Icons.credit_card,
                iconColor: scheme.error,
                name: largest.name,
                amountCents: largest.balanceCents,
                negative: true,
                note: '${pct.toStringAsFixed(0)}% of debt',
              );
            }(),
        ],
      ],
    );
  }

  Widget _breakdownRow({
    required IconData icon,
    required Color iconColor,
    required String name,
    required int amountCents,
    required String note,
    bool negative = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, overflow: TextOverflow.ellipsis, maxLines: 1),
                Text(note,
                    style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          MoneyText(
            '${negative ? '-' : ''}${fmtCents(amountCents)}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
              color: negative ? scheme.error : scheme.onSurface,
            ),
            // The usual faded cents read as too small and low-contrast at
            // this row's compact size — full weight keeps them legible.
            centsColor: negative ? scheme.error : scheme.onSurface,
          ),
        ],
      ),
    );
  }
}

/// Grouped income/expense bars by month.
class _CashflowChart extends StatelessWidget {
  const _CashflowChart({
    required this.data,
    required this.income,
    required this.expense,
    required this.label,
  });

  final List<({DateTime month, int incomeCents, int expenseCents})> data;
  final Color income;
  final Color expense;
  final Color label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _legend(income, 'Income'),
            const SizedBox(width: 16),
            _legend(expense, 'Expenses'),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: _CashflowPainter(
              data: data,
              income: income,
              expense: expense,
              label: label,
            ),
          ),
        ),
      ],
    );
  }

  Widget _legend(Color color, String text) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 6),
      Text(text, style: TextStyle(fontSize: 12, color: color)),
    ],
  );
}

/// A smooth curve through [points] (Catmull-Rom converted to cubic Beziers),
/// instead of straight segments — a flowing line rather than an angular
/// polyline through the same data.
Path smoothPathThrough(List<Offset> points) {
  final path = Path();
  if (points.isEmpty) return path;
  path.moveTo(points[0].dx, points[0].dy);
  if (points.length == 1) return path;
  if (points.length == 2) {
    path.lineTo(points[1].dx, points[1].dy);
    return path;
  }
  for (var i = 0; i < points.length - 1; i++) {
    final p0 = i == 0 ? points[i] : points[i - 1];
    final p1 = points[i];
    final p2 = points[i + 1];
    final p3 = i + 2 < points.length ? points[i + 2] : p2;
    final cp1 = p1 + (p2 - p0) / 6;
    final cp2 = p2 - (p3 - p1) / 6;
    path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
  }
  return path;
}

class _CashflowPainter extends CustomPainter {
  _CashflowPainter({
    required this.data,
    required this.income,
    required this.expense,
    required this.label,
  });

  final List<({DateTime month, int incomeCents, int expenseCents})> data;
  final Color income;
  final Color expense;
  final Color label;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final maxValue = data
        .expand((d) => [d.incomeCents, d.expenseCents])
        .fold(0, (a, b) => a > b ? a : b);
    if (maxValue == 0) return;

    const labelHeight = 20.0;
    final chartHeight = size.height - labelHeight;
    final slot = size.width / data.length;
    final barWidth = (slot * 0.30).clamp(6.0, 28.0);

    final gridLine = Paint()
      ..color = label.withValues(alpha: 0.1)
      ..strokeWidth = 1;
    const gridLines = 4;
    for (var i = 1; i < gridLines; i++) {
      final y = chartHeight * i / gridLines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridLine);
    }

    for (var i = 0; i < data.length; i++) {
      final centre = slot * i + slot / 2;
      final d = data[i];

      void bar(int cents, Color color, double offset) {
        final h = cents / maxValue * (chartHeight - 8);
        final rect = RRect.fromRectAndCorners(
          Rect.fromLTWH(centre + offset, chartHeight - h, barWidth, h),
          topLeft: const Radius.circular(3),
          topRight: const Radius.circular(3),
        );
        canvas.drawRRect(rect, Paint()..color = color);
      }

      bar(d.incomeCents, income, -barWidth - 2);
      bar(d.expenseCents, expense, 2);

      final tp = TextPainter(
        text: TextSpan(
          text: _months[d.month.month - 1],
          style: TextStyle(color: label.withValues(alpha: 0.7), fontSize: 11),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(centre - tp.width / 2, size.height - labelHeight + 4),
      );
    }
  }

  @override
  bool shouldRepaint(_CashflowPainter old) =>
      old.data != data || old.income != income;
}

class _ScoreChartPainter extends CustomPainter {
  _ScoreChartPainter({
    required this.scores,
    required this.lineColor,
    required this.labelColor,
  });

  final List<CreditScoreSnapshot> scores;
  final Color lineColor;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    final minScore =
        scores.map((s) => s.score).reduce((a, b) => a < b ? a : b) - 20;
    final maxScore =
        scores.map((s) => s.score).reduce((a, b) => a > b ? a : b) + 20;
    final range = (maxScore - minScore).clamp(1, 850);

    final gridLine = Paint()
      ..color = labelColor.withValues(alpha: 0.1)
      ..strokeWidth = 1;
    const gridLines = 4;
    for (var i = 1; i < gridLines; i++) {
      final y = size.height * i / gridLines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridLine);
    }

    Offset point(int i) {
      final x = scores.length == 1
          ? size.width / 2
          : i * size.width / (scores.length - 1);
      final y =
          size.height - (scores[i].score - minScore) / range * size.height;
      return Offset(x.clamp(6.0, size.width - 6), y);
    }

    final points = [for (var i = 0; i < scores.length; i++) point(i)];
    final path = smoothPathThrough(points);

    if (scores.length >= 2) {
      final fill = Path.from(path)
        ..lineTo(points.last.dx, size.height)
        ..lineTo(points.first.dx, size.height)
        ..close();
      canvas.drawPath(fill, Paint()..color = lineColor.withValues(alpha: 0.12));
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );

    final dot = Paint()..color = lineColor;
    for (var i = 0; i < scores.length; i++) {
      canvas.drawCircle(point(i), 4, dot);
      final tp = TextPainter(
        text: TextSpan(
          text: '${scores[i].score}',
          style: TextStyle(color: labelColor, fontSize: 11),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, point(i) + Offset(-tp.width / 2, -20));
    }
  }

  @override
  bool shouldRepaint(_ScoreChartPainter old) =>
      old.scores != scores || old.lineColor != lineColor;
}

/// Net worth over time. Handles negative values by anchoring the scale to
/// include zero and drawing a dashed baseline there.
class _NetWorthChartPainter extends CustomPainter {
  _NetWorthChartPainter({
    required this.history,
    required this.line,
    required this.negative,
    required this.label,
    required this.grid,
    this.hoverIndex,
  });

  final List<NetWorthSnapshot> history;
  final Color line;
  final Color negative;
  final Color label;
  final Color grid;
  final int? hoverIndex;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (history.length < 2) return;
    const labelHeight = 20.0;
    final chartHeight = size.height - labelHeight;

    final values = history.map((s) => s.netWorthCents).toList();
    // Always include zero so the baseline is meaningful.
    var minValue = values.reduce((a, b) => a < b ? a : b);
    var maxValue = values.reduce((a, b) => a > b ? a : b);
    if (minValue > 0) minValue = 0;
    if (maxValue < 0) maxValue = 0;
    final range = (maxValue - minValue) == 0 ? 1 : (maxValue - minValue);

    double yFor(int cents) =>
        chartHeight - ((cents - minValue) / range) * (chartHeight - 8) - 4;
    double xFor(int i) => history.length == 1
        ? size.width / 2
        : i * size.width / (history.length - 1);

    // A real graph-paper grid — horizontal and vertical — fills what would
    // otherwise be dead space under the line with a sense of scale, the
    // way most technical charting tools look by default.
    final gridLine = Paint()
      ..color = grid.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    const rows = 4;
    for (var i = 1; i < rows; i++) {
      final y = chartHeight * i / rows;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridLine);
    }
    const columns = 8;
    for (var i = 1; i < columns; i++) {
      final x = size.width * i / columns;
      canvas.drawLine(Offset(x, 0), Offset(x, chartHeight), gridLine);
    }

    // Zero baseline, dashed.
    final zeroY = yFor(0);
    final dash = Paint()
      ..color = grid.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, zeroY), Offset(x + 4, zeroY), dash);
    }

    final points = [
      for (var i = 0; i < values.length; i++) Offset(xFor(i), yFor(values[i])),
    ];
    final path = smoothPathThrough(points);

    // Soft fill under the line, tinted by whether it ends up or down.
    final ending = values.last >= 0 ? line : negative;
    final fill = Path.from(path)
      ..lineTo(xFor(values.length - 1), zeroY)
      ..lineTo(xFor(0), zeroY)
      ..close();
    canvas.drawPath(fill, Paint()..color = ending.withValues(alpha: 0.12));

    canvas.drawPath(
      path,
      Paint()
        ..color = ending
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );

    // End point emphasised with its value.
    final lastX = xFor(values.length - 1);
    final lastY = yFor(values.last);
    canvas.drawCircle(Offset(lastX, lastY), 4, Paint()..color = ending);

    if (hoverIndex != null && hoverIndex! < values.length) {
      final hx = xFor(hoverIndex!);
      final hy = yFor(values[hoverIndex!]);
      canvas.drawLine(
        Offset(hx, 0),
        Offset(hx, chartHeight),
        Paint()
          ..color = label.withValues(alpha: 0.4)
          ..strokeWidth = 1,
      );
      canvas.drawCircle(Offset(hx, hy), 5, Paint()..color = label);
      canvas.drawCircle(Offset(hx, hy), 3, Paint()..color = ending);
    }

    void drawText(String text, Offset at, {Color? color, bool right = false}) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(color: color ?? label, fontSize: 11),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, at - (right ? Offset(tp.width, 0) : Offset.zero));
    }

    // The end value has its own big hero display above the chart now, so
    // the chart itself stays uncluttered — just the line and its dates.

    // First and last dates along the bottom.
    final firstDate = history.first.date;
    final lastDate = history.last.date;
    drawText(
      '${_months[firstDate.month - 1]} ${firstDate.day}',
      Offset(0, size.height - labelHeight + 4),
    );
    drawText(
      '${_months[lastDate.month - 1]} ${lastDate.day}',
      Offset(size.width, size.height - labelHeight + 4),
      right: true,
    );
  }

  @override
  bool shouldRepaint(_NetWorthChartPainter old) =>
      old.history != history ||
      old.line != line ||
      old.hoverIndex != hoverIndex;
}

/// A forward-looking cash balance line — same visual language as the net
/// worth chart (grid, dashed zero baseline, smooth curve, soft fill) so the
/// two read as one family rather than two unrelated widgets.
class _ProjectionChartPainter extends CustomPainter {
  _ProjectionChartPainter({
    required this.points,
    required this.line,
    required this.negative,
    required this.grid,
    this.hoverIndex,
  });

  final List<({DateTime date, int balanceCents})> points;
  final Color line;
  final Color negative;
  final Color grid;
  final int? hoverIndex;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    const labelHeight = 20.0;
    final chartHeight = size.height - labelHeight;

    final values = points.map((p) => p.balanceCents).toList();
    var minValue = values.reduce((a, b) => a < b ? a : b);
    var maxValue = values.reduce((a, b) => a > b ? a : b);
    if (minValue > 0) minValue = 0;
    if (maxValue < 0) maxValue = 0;
    final range = (maxValue - minValue) == 0 ? 1 : (maxValue - minValue);

    double yFor(int cents) =>
        chartHeight - ((cents - minValue) / range) * (chartHeight - 8) - 4;
    double xFor(int i) => i * size.width / (values.length - 1);

    final gridLine = Paint()
      ..color = grid.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    const rows = 4;
    for (var i = 1; i < rows; i++) {
      final y = chartHeight * i / rows;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridLine);
    }
    const columns = 8;
    for (var i = 1; i < columns; i++) {
      final x = size.width * i / columns;
      canvas.drawLine(Offset(x, 0), Offset(x, chartHeight), gridLine);
    }

    final zeroY = yFor(0);
    final dash = Paint()
      ..color = grid.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, zeroY), Offset(x + 4, zeroY), dash);
    }

    final offsets = [
      for (var i = 0; i < values.length; i++) Offset(xFor(i), yFor(values[i])),
    ];
    final path = smoothPathThrough(offsets);

    final ending = values.last >= values.first ? line : negative;
    final fill = Path.from(path)
      ..lineTo(xFor(values.length - 1), zeroY)
      ..lineTo(xFor(0), zeroY)
      ..close();
    canvas.drawPath(fill, Paint()..color = ending.withValues(alpha: 0.12));

    canvas.drawPath(
      path,
      Paint()
        ..color = ending
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );

    canvas.drawCircle(
      Offset(xFor(values.length - 1), yFor(values.last)),
      4,
      Paint()..color = ending,
    );

    if (hoverIndex != null && hoverIndex! < values.length) {
      final hx = xFor(hoverIndex!);
      final hy = yFor(values[hoverIndex!]);
      canvas.drawLine(
        Offset(hx, 0),
        Offset(hx, chartHeight),
        Paint()
          ..color = grid.withValues(alpha: 0.6)
          ..strokeWidth = 1,
      );
      canvas.drawCircle(Offset(hx, hy), 5, Paint()..color = grid);
      canvas.drawCircle(Offset(hx, hy), 3, Paint()..color = ending);
    }

    void drawText(String text, Offset at, {bool right = false}) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(color: grid, fontSize: 11),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, at - (right ? Offset(tp.width, 0) : Offset.zero));
    }

    final lastDate = points.last.date;
    drawText('Today', Offset(0, size.height - labelHeight + 4));
    drawText(
      '${_months[lastDate.month - 1]} ${lastDate.day}',
      Offset(size.width, size.height - labelHeight + 4),
      right: true,
    );
  }

  @override
  bool shouldRepaint(_ProjectionChartPainter old) =>
      old.points != points ||
      old.line != line ||
      old.hoverIndex != hoverIndex;
}
