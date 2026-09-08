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

  Future<int> addEntry({String category = 'Other', int amountCents = 15000}) =>
      repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: DateTime(2026, 8, 15),
        amountCents: amountCents,
        type: EntryType.expense,
        category: Value(category),
      ));

  test('splitting an entry records each slice', () async {
    final entryId = await addEntry(amountCents: 15000);

    await repo.setEntrySplits(profileId: profileId, entryId: entryId, splits: [
      (category: 'Groceries', amountCents: 10000),
      (category: 'Household', amountCents: 5000),
    ]);

    final splits = await repo.splitsFor(entryId: entryId);
    expect(splits, hasLength(2));
    expect(splits.map((s) => s.category), containsAll(['Groceries', 'Household']));
    expect(splits.fold(0, (s, r) => s + r.amountCents), 15000);
  });

  test('re-splitting replaces the previous splits rather than adding to them',
      () async {
    final entryId = await addEntry();
    await repo.setEntrySplits(profileId: profileId, entryId: entryId, splits: [
      (category: 'Old', amountCents: 15000),
    ]);

    await repo.setEntrySplits(profileId: profileId, entryId: entryId, splits: [
      (category: 'New', amountCents: 15000),
    ]);

    final splits = await repo.splitsFor(entryId: entryId);
    expect(splits.map((s) => s.category), ['New']);
  });

  test('a zero-amount split row is dropped rather than stored', () async {
    final entryId = await addEntry();
    await repo.setEntrySplits(profileId: profileId, entryId: entryId, splits: [
      (category: 'Real', amountCents: 15000),
      (category: 'Empty', amountCents: 0),
    ]);

    final splits = await repo.splitsFor(entryId: entryId);
    expect(splits.map((s) => s.category), ['Real']);
  });

  test('deleting the entry removes its splits', () async {
    final entryId = await addEntry();
    await repo.setEntrySplits(profileId: profileId, entryId: entryId, splits: [
      (category: 'Groceries', amountCents: 15000),
    ]);

    await repo.deleteBudgetEntry(profileId: profileId, id: entryId);

    expect(await repo.splitsFor(entryId: entryId), isEmpty);
  });

  test('splits are per profile', () async {
    final other =
        await repo.createProfile(ProfilesCompanion.insert(name: 'Mom'));
    final entryId = await addEntry();
    await repo.setEntrySplits(profileId: profileId, entryId: entryId, splits: [
      (category: 'Groceries', amountCents: 15000),
    ]);

    expect(await repo.watchSplitsByEntry(profileId: other).first, isEmpty);
  });

  test('deleting a profile removes its splits', () async {
    // A lone admin cannot be deleted, so a second one keeps this focused on
    // split cleanup rather than that unrelated rule.
    await repo.createProfile(
        ProfilesCompanion.insert(name: 'Co-admin', isAdmin: const Value(true)));
    final entryId = await addEntry();
    await repo.setEntrySplits(profileId: profileId, entryId: entryId, splits: [
      (category: 'Groceries', amountCents: 15000),
    ]);

    await repo.deleteProfile(id: profileId);

    expect(await repo.splitsFor(entryId: entryId), isEmpty);
  });

  group('expandForCategoryTotals', () {
    test('an unsplit entry contributes once under its own category', () {
      final entries = [
        BudgetEntry(
          id: 1,
          profileId: 1,
          date: DateTime(2026, 8, 15),
          category: 'Groceries',
          amountCents: 5000,
          type: EntryType.expense,
        ),
      ];
      final rows =
          HomebaseRepository.expandForCategoryTotals(entries, {});
      expect(rows, hasLength(1));
      expect(rows.single.category, 'Groceries');
      expect(rows.single.amountCents, 5000);
    });

    test('a split entry contributes one row per slice instead of one row '
        'under its parent category', () {
      final entries = [
        BudgetEntry(
          id: 1,
          profileId: 1,
          date: DateTime(2026, 8, 15),
          category: 'Split',
          amountCents: 15000,
          type: EntryType.expense,
        ),
      ];
      final splitsByEntry = {
        1: [
          TransactionSplit(
              id: 1, profileId: 1, entryId: 1, category: 'Groceries', amountCents: 10000),
          TransactionSplit(
              id: 2, profileId: 1, entryId: 1, category: 'Household', amountCents: 5000),
        ],
      };
      final rows = HomebaseRepository.expandForCategoryTotals(
          entries, splitsByEntry);
      expect(rows, hasLength(2));
      expect(rows.fold(0, (s, r) => s + r.amountCents), 15000);
      expect(rows.map((r) => r.category), ['Groceries', 'Household']);
    });
  });
}
