import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:granary/data/database.dart';
import 'package:granary/data/repository.dart';

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

  test('net worth is assets minus card and loan debt', () async {
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(250000)));
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Savings',
        type: AccountType.savings,
        balanceCents: const Value(1000000)));
    await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: 'Visa',
        creditLimitCents: 500000,
        balanceCents: const Value(120000)));
    await repo.upsertLoan(LoansCompanion.insert(
        profileId: profileId,
        name: 'Car',
        balanceCents: 800000,
        originalAmountCents: 1500000));

    final net = await repo.watchNetWorth(profileId: profileId).first;
    expect(net.assetsCents, 1250000);
    expect(net.debtsCents, 920000);
    expect(net.netCents, 330000);
  });

  test('net worth ignores other profiles', () async {
    final other = await repo.createProfile(ProfilesCompanion.insert(name: 'Mom'));
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: other,
        name: 'Her savings',
        type: AccountType.savings,
        balanceCents: const Value(9999999)));

    final net = await repo.watchNetWorth(profileId: profileId).first;
    expect(net.assetsCents, 0);
    expect(net.netCents, 0);
  });

  test('cashflow buckets income and expenses into the current month',
      () async {
    final now = DateTime.now();
    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: now,
        amountCents: 300000,
        type: EntryType.income));
    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: now,
        amountCents: 45000,
        type: EntryType.expense));

    final flow = await repo.watchCashflow(profileId: profileId).first;
    final current = flow.last;
    expect(current.month.month, now.month);
    expect(current.incomeCents, 300000);
    expect(current.expenseCents, 45000);
  });

  group('account balance history', () {
    test('editing an account records a snapshot for today', () async {
      final id = await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId,
          name: 'Checking',
          type: AccountType.checking,
          balanceCents: const Value(10000)));

      final history =
          await repo.watchAccountBalanceHistory(accountId: id).first;
      expect(history, hasLength(1));
      expect(history.single.balanceCents, 10000);
    });

    test('a second edit the same day updates the point instead of adding one',
        () async {
      final id = await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId,
          name: 'Checking',
          type: AccountType.checking,
          balanceCents: const Value(10000)));

      await repo.upsertAccount(AccountsCompanion(
        id: Value(id),
        profileId: Value(profileId),
        name: const Value('Checking'),
        type: const Value(AccountType.checking),
        balanceCents: const Value(15000),
      ));

      final history =
          await repo.watchAccountBalanceHistory(accountId: id).first;
      expect(history, hasLength(1),
          reason: 'same-day edits update the one point for today');
      expect(history.single.balanceCents, 15000);
    });

    test(
        'editing an account after something else was inserted still edits '
        'the right one — regression for a stale last_insert_rowid() bug',
        () async {
      final target = await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId,
          name: 'Checking',
          type: AccountType.checking,
          balanceCents: const Value(10000)));
      // Any insert after this — even on an unrelated row — used to make
      // the edit below silently touch the wrong account (or throw), since
      // insertOnConflictUpdate's update branch doesn't change
      // last_insert_rowid().
      await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId,
          name: 'Savings',
          type: AccountType.savings,
          balanceCents: const Value(50000)));

      await repo.upsertAccount(AccountsCompanion(
        id: Value(target),
        profileId: Value(profileId),
        name: const Value('Checking'),
        type: const Value(AccountType.checking),
        balanceCents: const Value(99999),
      ));

      final accounts = await repo.watchAccounts(profileId: profileId).first;
      expect(accounts.firstWhere((a) => a.id == target).balanceCents, 99999);
      expect(accounts.firstWhere((a) => a.name == 'Savings').balanceCents,
          50000,
          reason: 'the other account must be untouched');
    });

    test('recordAccountSnapshotsForToday covers every account without '
        'duplicating existing points', () async {
      final a = await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId,
          name: 'Checking',
          type: AccountType.checking,
          balanceCents: const Value(10000)));
      final b = await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId,
          name: 'Savings',
          type: AccountType.savings,
          balanceCents: const Value(50000)));

      await repo.recordAccountSnapshotsForToday(profileId: profileId);

      expect(await repo.watchAccountBalanceHistory(accountId: a).first,
          hasLength(1));
      expect(await repo.watchAccountBalanceHistory(accountId: b).first,
          hasLength(1));
    });

    test('deleting an account removes its balance history', () async {
      final id = await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId,
          name: 'Checking',
          type: AccountType.checking,
          balanceCents: const Value(10000)));

      await repo.deleteAccount(profileId: profileId, id: id);

      expect(await repo.watchAccountBalanceHistory(accountId: id).first,
          isEmpty);
    });

    test('history is per account, not shared across them', () async {
      final a = await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId,
          name: 'Checking',
          type: AccountType.checking,
          balanceCents: const Value(10000)));
      await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId,
          name: 'Savings',
          type: AccountType.savings,
          balanceCents: const Value(50000)));

      final history = await repo.watchAccountBalanceHistory(accountId: a).first;
      expect(history, hasLength(1));
      expect(history.single.balanceCents, 10000);
    });
  });
}
