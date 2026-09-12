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

  Future<int> balanceOf(int accountId) async => (await repo
          .watchAccounts(profileId: profileId)
          .first)
      .firstWhere((a) => a.id == accountId)
      .balanceCents;

  test('editing the category alone leaves the amount and balance untouched',
      () async {
    final id = await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 15),
      amountCents: 5000,
      type: EntryType.expense,
      category: const Value('Other'),
    ));

    await repo.updateBudgetEntry(
        profileId: profileId,
        id: id,
        entry: const BudgetEntriesCompanion(category: Value('Groceries')));

    final entry = await (db.select(db.budgetEntries)
          ..where((e) => e.id.equals(id)))
        .getSingle();
    expect(entry.category, 'Groceries');
    expect(entry.amountCents, 5000);
  });

  test('editing the amount of an account-linked entry corrects the balance',
      () async {
    final accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(100000)));
    final id = await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 15),
      amountCents: 5000,
      type: EntryType.expense,
      accountId: Value(accountId),
    ));
    expect(await balanceOf(accountId), 95000);

    await repo.updateBudgetEntry(
        profileId: profileId,
        id: id,
        entry: const BudgetEntriesCompanion(amountCents: Value(8000)));

    expect(await balanceOf(accountId), 92000,
        reason: 'old 5000 withdrawal undone, new 8000 withdrawal applied');
  });

  test('moving an entry from one account to another corrects both balances',
      () async {
    final checking = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(100000)));
    final savings = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Savings',
        type: AccountType.savings,
        balanceCents: const Value(50000)));
    final id = await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 15),
      amountCents: 5000,
      type: EntryType.expense,
      accountId: Value(checking),
    ));

    await repo.updateBudgetEntry(
        profileId: profileId,
        id: id,
        entry: BudgetEntriesCompanion(accountId: Value(savings)));

    expect(await balanceOf(checking), 100000,
        reason: 'checking gets its withdrawal back');
    expect(await balanceOf(savings), 45000,
        reason: 'savings now carries the withdrawal instead');
  });

  test('switching an entry from expense to income flips the balance effect',
      () async {
    final accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(100000)));
    final id = await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 15),
      amountCents: 5000,
      type: EntryType.expense,
      accountId: Value(accountId),
    ));
    expect(await balanceOf(accountId), 95000);

    await repo.updateBudgetEntry(
        profileId: profileId,
        id: id,
        entry: const BudgetEntriesCompanion(type: Value(EntryType.income)));

    expect(await balanceOf(accountId), 105000,
        reason: 'the 5000 withdrawal is undone and redone as a deposit');
  });

  test('clearing an entry\'s account link stops it moving that balance',
      () async {
    final accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(100000)));
    final id = await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 15),
      amountCents: 5000,
      type: EntryType.expense,
      accountId: Value(accountId),
    ));

    await repo.updateBudgetEntry(
        profileId: profileId,
        id: id,
        entry: const BudgetEntriesCompanion(accountId: Value(null)));

    expect(await balanceOf(accountId), 100000);
    final entry = await (db.select(db.budgetEntries)
          ..where((e) => e.id.equals(id)))
        .getSingle();
    expect(entry.accountId, isNull);
  });
}
