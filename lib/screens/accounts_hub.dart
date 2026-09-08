import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../main.dart';
import '../util/money.dart';
import '../widgets/common.dart';
import 'accounts.dart';
import 'cards.dart';
import 'loans.dart';
import 'transfers.dart';

/// Accounts, Cards and Loans used to be three separate sidebar entries.
/// Grouping them under one "Accounts" destination with tabs cuts down the
/// nav rail, and a net-worth summary above the tabs gives the combined
/// picture that used to only exist on the Dashboard. None of the three
/// screens' own logic (editing, payoff calculators, statement cycles)
/// changed — this is purely a shared header sitting above them.
class AccountsHubScreen extends StatefulWidget {
  const AccountsHubScreen({super.key});

  @override
  State<AccountsHubScreen> createState() => _AccountsHubScreenState();
}

class _AccountsHubScreenState extends State<AccountsHubScreen>
    with SingleTickerProviderStateMixin {
  late final _controller = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        const _NetWorthSummary(),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            // A pill-shaped segmented control, not Material's default
            // underline TabBar, for switching between a handful of views.
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                controller: _controller,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                labelColor: scheme.onSurface,
                unselectedLabelColor: scheme.onSurfaceVariant,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Cash'),
                  Tab(text: 'Cards'),
                  Tab(text: 'Loans'),
                  Tab(text: 'Transfers'),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: const [
              AccountsScreen(),
              CardsScreen(),
              LoansScreen(),
              TransfersScreen(),
            ],
          ),
        ),
      ],
    );
  }
}

class _NetWorthSummary extends ConsumerWidget {
  const _NetWorthSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    final profileId = ref.watch(activeProfileProvider)!.id;
    final scheme = Theme.of(context).colorScheme;

    return StreamBuilder(
      stream: repo.watchNetWorth(profileId: profileId),
      builder: (context, netSnap) {
        final net = netSnap.data;
        return StreamBuilder<List<Account>>(
          stream: repo.watchAccounts(profileId: profileId),
          builder: (context, accSnap) {
            final accounts = accSnap.data ?? [];
            // "Cash" means money you can spend right now; investment,
            // retirement and other accounts are real assets but not liquid
            // the same way, so they get their own figure rather than being
            // silently folded into "Cash".
            const cashTypes = {
              AccountType.checking,
              AccountType.savings,
              AccountType.cash,
            };
            final cash = accounts
                .where((a) => cashTypes.contains(a.type))
                .fold(0, (s, a) => s + a.balanceCents);
            final otherAssets = accounts
                .where((a) => !cashTypes.contains(a.type))
                .fold(0, (s, a) => s + a.balanceCents);
            return StreamBuilder<List<CreditCard>>(
              stream: repo.watchCards(profileId: profileId),
              builder: (context, cardSnap) {
                final cards = (cardSnap.data ?? [])
                    .fold(0, (s, c) => s + c.balanceCents);
                return StreamBuilder<List<Loan>>(
                  stream: repo.watchLoans(profileId: profileId),
                  builder: (context, loanSnap) {
                    final loans = (loanSnap.data ?? [])
                        .fold(0, (s, l) => s + l.balanceCents);
                    return Padding(
                      padding: kPagePadding.copyWith(bottom: 0),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          StatCard(
                            label: 'Net worth',
                            value: net == null
                                ? '—'
                                : fmtCents(net.netCents),
                            icon: Icons.account_balance_wallet_outlined,
                            color: (net?.netCents ?? 0) >= 0
                                ? scheme.primary
                                : scheme.error,
                          ),
                          StatCard(
                            label: 'Cash',
                            value: fmtCents(cash),
                            icon: Icons.account_balance_outlined,
                            color: scheme.secondary,
                          ),
                          StatCard(
                            label: 'Assets',
                            value: fmtCents(otherAssets),
                            icon: Icons.trending_up,
                            color: scheme.secondary,
                          ),
                          StatCard(
                            label: 'Cards',
                            value: fmtCents(cards),
                            icon: Icons.credit_card_outlined,
                            color: scheme.error,
                          ),
                          StatCard(
                            label: 'Loans',
                            value: fmtCents(loans),
                            icon: Icons.request_quote_outlined,
                            color: scheme.error,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
