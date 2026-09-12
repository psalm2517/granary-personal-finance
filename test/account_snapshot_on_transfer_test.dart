import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clearly/data/database.dart';
import 'package:clearly/data/repository.dart';

void main() {
  late AppDatabase db;
  late HomebaseRepository repo;
  late int profileId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = HomebaseRepository(db);
    profileId = await repo.createProfile(
        ProfilesCompanion.insert(name: 'Owner', isAdmin: const Value(true)));
  });

  tearDown(() => db.close());

  test('a transfer updates today\'s balance snapshot, not just the live '
      'balance', () async {
    final checking = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(500000)));
    final savings = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Savings',
        type: AccountType.savings,
        balanceCents: const Value(100000)));

    await repo.postManualTransfer(
      profileId: profileId,
      fromAccountId: checking,
      toAccountId: savings,
      amountCents: 20000,
      date: DateTime.now(),
      name: 'To savings',
    );

    final today = DateTime.now();
    final checkingHistory = await repo
        .watchAccountBalanceHistory(accountId: checking)
        .first;
    final savingsHistory =
        await repo.watchAccountBalanceHistory(accountId: savings).first;

    final checkingToday = checkingHistory.firstWhere((s) =>
        s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day);
    final savingsToday = savingsHistory.firstWhere((s) =>
        s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day);

    expect(checkingToday.balanceCents, 480000);
    expect(savingsToday.balanceCents, 120000);
  });

  test('an account-linked entry updates today\'s snapshot', () async {
    final accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Retirement',
        type: AccountType.retirement,
        balanceCents: const Value(1000000)));

    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime.now(),
      amountCents: 51830,
      type: EntryType.expense,
      description: const Value('Unrealized loss'),
      accountId: Value(accountId),
    ));

    final today = DateTime.now();
    final history =
        await repo.watchAccountBalanceHistory(accountId: accountId).first;
    final todaySnapshot = history.firstWhere((s) =>
        s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day);

    expect(todaySnapshot.balanceCents, 948170);
  });
}
