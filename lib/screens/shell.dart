import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/notifications.dart';
import '../data/repository.dart';
import '../main.dart';
import '../theme/catppuccin.dart';
import '../theme/flavor_provider.dart';
import 'accounts_hub.dart';
import 'bills.dart';
import 'budget.dart';
import 'dashboard.dart';
import 'goals.dart';
import 'paychecks.dart';
import 'profiles.dart';
import 'settings.dart';
import 'transactions.dart';

/// Desktop shell: NavigationRail sidebar + content. Only admins see the
/// profile switcher; non-admins have no indication other profiles exist.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;
  int? _caughtUpFor;

  /// Brings the books up to date for whoever is being viewed: generate
  /// upcoming paychecks, mark ones whose payday has passed as received, and
  /// record autopay bills that have come due. Runs on entry and on profile
  /// switch so it never depends on visiting a particular screen.
  void _catchUp(int profileId) {
    if (_caughtUpFor == profileId) return;
    _caughtUpFor = profileId;
    Future.microtask(() async {
      final repo = ref.read(repositoryProvider);
      final now = DateTime.now();
      await repo.generateDuePaychecks(
          profileId: profileId,
          until: now.add(HomebaseRepository.paycheckHorizon));
      await repo.materializeReceivedPaychecks(profileId: profileId);
      await repo.materializeAutopayPayments(
          profileId: profileId, month: now);
      await repo.materializeDueTransfers(profileId: profileId, now: now);
      // A point for today even on a day with no edits.
      await repo.recordNetWorthSnapshot(profileId: profileId);
      await repo.recordAccountSnapshotsForToday(profileId: profileId);

      // Nudge about anything due soon. The dashboard panel is the reliable
      // surface; this is the extra desktop/phone notification on top.
      final reminders = await repo.upcomingReminders(profileId: profileId);
      for (final reminder in reminders) {
        await NotificationService.instance.showReminder(reminder);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = ref.watch(loggedInProfileProvider)!;
    final active = ref.watch(activeProfileProvider) ?? loggedIn;
    _catchUp(active.id);
    final flavor = ref.watch(flavorProvider);

    final titles = [
      'Dashboard',
      'Accounts',
      'Bills',
      'Budget',
      'Transactions',
      'Paychecks',
      'Goals',
      'Settings',
      // Admin-only, appended last so indices stay stable for everyone else.
      if (loggedIn.isAdmin) 'Profiles',
    ];

    final pages = [
      const DashboardScreen(),
      const AccountsHubScreen(),
      const BillsScreen(),
      const BudgetScreen(),
      const TransactionsScreen(),
      const PaychecksScreen(),
      const GoalsScreen(),
      const SettingsScreen(),
      if (loggedIn.isAdmin) const ProfilesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: [
          if (loggedIn.isAdmin) _ProfileSwitcher(active: active),
          IconButton(
            tooltip: flavor.isDark
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            icon: Icon(flavor.isDark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined),
            onPressed: () =>
                ref.read(flavorProvider.notifier).toggleLightDark(),
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(loggedInProfileProvider.notifier).state = null;
              ref.invalidate(activeProfileProvider);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            labelType: NavigationRailLabelType.all,
            destinations: [
              const NavigationRailDestination(
                  icon: Icon(Icons.space_dashboard_outlined),
                  selectedIcon: Icon(Icons.space_dashboard),
                  label: Text('Dashboard')),
              const NavigationRailDestination(
                  icon: Icon(Icons.account_balance_outlined),
                  selectedIcon: Icon(Icons.account_balance),
                  label: Text('Accounts')),
              const NavigationRailDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: Text('Bills')),
              const NavigationRailDestination(
                  icon: Icon(Icons.pie_chart_outline),
                  selectedIcon: Icon(Icons.pie_chart),
                  label: Text('Budget')),
              const NavigationRailDestination(
                  icon: Icon(Icons.swap_horiz_outlined),
                  selectedIcon: Icon(Icons.swap_horiz),
                  label: Text('Transactions')),
              const NavigationRailDestination(
                  icon: Icon(Icons.payments_outlined),
                  selectedIcon: Icon(Icons.payments),
                  label: Text('Paychecks')),
              const NavigationRailDestination(
                  icon: Icon(Icons.flag_outlined),
                  selectedIcon: Icon(Icons.flag),
                  label: Text('Goals')),
              const NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings')),
              if (loggedIn.isAdmin)
                const NavigationRailDestination(
                    icon: Icon(Icons.group_outlined),
                    selectedIcon: Icon(Icons.group),
                    label: Text('Profiles')),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: pages[_index]),
        ],
      ),
    );
  }
}

class _ProfileSwitcher extends ConsumerWidget {
  const _ProfileSwitcher({required this.active});
  final Profile active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(repositoryProvider);
    return FutureBuilder<List<Profile>>(
      future: repo.allProfiles(),
      builder: (context, snapshot) {
        final profiles = snapshot.data ?? [active];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButton<int>(
            value: active.id,
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.swap_horiz),
            items: [
              for (final p in profiles)
                DropdownMenuItem(
                    value: p.id, child: Text('Viewing: ${p.name}')),
            ],
            onChanged: (id) {
              if (id == null) return;
              ref.read(activeProfileProvider.notifier).state =
                  profiles.firstWhere((p) => p.id == id);
            },
          ),
        );
      },
    );
  }
}
