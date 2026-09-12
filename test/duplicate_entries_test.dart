import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clearly/data/database.dart';
import 'package:clearly/data/repository.dart';

void main() {
  late AppDatabase db;
  late HomebaseRepository repo;
  late int profileId;
  late int accountId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = HomebaseRepository(db);
    profileId = await repo.createProfile(
        ProfilesCompanion.insert(name: 'Owner', isAdmin: const Value(true)));
    accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(100000)));
  });

  tearDown(() => db.close());

  Future<int> addEntry({
    DateTime? date,
    int amountCents = 450,
    String description = 'Coffee Shop',
    int? accountIdOverride,
  }) =>
      repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: date ?? DateTime(2026, 8, 10),
        amountCents: amountCents,
        type: EntryType.expense,
        description: Value(description),
        accountId: Value(accountIdOverride ?? accountId),
      ));

  group('watchDuplicateGroups', () {
    test('groups entries matching in day, amount, description and account',
        () async {
      await addEntry();
      await addEntry();

      final groups = await repo.watchDuplicateGroups(profileId: profileId).first;

      expect(groups, hasLength(1));
      expect(groups.single, hasLength(2));
    });

    test('a single entry with no match forms no group', () async {
      await addEntry();

      final groups = await repo.watchDuplicateGroups(profileId: profileId).first;

      expect(groups, isEmpty);
    });

    test('a different amount is not grouped with it', () async {
      await addEntry();
      await addEntry(amountCents: 500);

      final groups = await repo.watchDuplicateGroups(profileId: profileId).first;

      expect(groups, isEmpty);
    });

    test('a different account is not grouped with it', () async {
      final other = await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId, name: 'Savings', type: AccountType.savings));
      await addEntry();
      await addEntry(accountIdOverride: other);

      final groups = await repo.watchDuplicateGroups(profileId: profileId).first;

      expect(groups, isEmpty);
    });

    test('description matching ignores case and surrounding whitespace',
        () async {
      await addEntry(description: 'Coffee Shop');
      await addEntry(description: '  COFFEE SHOP  ');

      final groups = await repo.watchDuplicateGroups(profileId: profileId).first;

      expect(groups, hasLength(1));
    });
  });

  group('deleteBudgetEntries', () {
    test('removes every listed entry', () async {
      final a = await addEntry();
      final b = await addEntry();

      await repo.deleteBudgetEntries(profileId: profileId, ids: [a, b]);

      final entries = await repo
          .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 8))
          .first;
      expect(entries, isEmpty);
    });

    test('puts each deleted expense back on its account balance', () async {
      final a = await addEntry(amountCents: 450);
      final b = await addEntry(amountCents: 200);

      await repo.deleteBudgetEntries(profileId: profileId, ids: [a, b]);

      final account = (await repo.watchAccounts(profileId: profileId).first)
          .firstWhere((acc) => acc.id == accountId);
      expect(account.balanceCents, 100000);
    });
  });
}
