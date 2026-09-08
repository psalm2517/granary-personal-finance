import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:granary/data/database.dart';
import 'package:granary/data/repository.dart';

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

  Future<int> balanceOf(int id) async => (await repo
          .watchAccounts(profileId: profileId)
          .first)
      .firstWhere((a) => a.id == id)
      .balanceCents;

  test('an expense linked to an account withdraws from it', () async {
    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 15),
      amountCents: 4500,
      type: EntryType.expense,
      accountId: Value(accountId),
    ));

    expect(await balanceOf(accountId), 95500);
  });

  test('income linked to an account deposits into it', () async {
    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 15),
      amountCents: 20000,
      type: EntryType.income,
      accountId: Value(accountId),
    ));

    expect(await balanceOf(accountId), 120000);
  });

  test('an entry with no account link never touches any balance', () async {
    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 15),
      amountCents: 4500,
      type: EntryType.expense,
    ));

    expect(await balanceOf(accountId), 100000);
  });

  test('deleting an account-linked entry reverses its balance effect',
      () async {
    final id = await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 15),
      amountCents: 4500,
      type: EntryType.expense,
      accountId: Value(accountId),
    ));

    await repo.deleteBudgetEntry(profileId: profileId, id: id);

    expect(await balanceOf(accountId), 100000);
  });

  test('deleting an account-linked income entry reverses its deposit',
      () async {
    final id = await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 15),
      amountCents: 20000,
      type: EntryType.income,
      accountId: Value(accountId),
    ));

    await repo.deleteBudgetEntry(profileId: profileId, id: id);

    expect(await balanceOf(accountId), 100000);
  });

  group('card-linked entries', () {
    late int cardId;

    Future<int> cardBalanceOf(int id) async =>
        (await repo.watchCards(profileId: profileId).first)
            .firstWhere((c) => c.id == id)
            .balanceCents;

    setUp(() async {
      cardId = await repo.upsertCard(CreditCardsCompanion.insert(
          profileId: profileId,
          name: 'Visa',
          creditLimitCents: 500000,
          balanceCents: const Value(20000)));
    });

    test('an expense linked to a card charges it', () async {
      await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: DateTime(2026, 8, 15),
        amountCents: 4500,
        type: EntryType.expense,
        cardId: Value(cardId),
      ));

      expect(await cardBalanceOf(cardId), 24500);
    });

    test('income linked to a card credits it (e.g. a refund)', () async {
      await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: DateTime(2026, 8, 15),
        amountCents: 5000,
        type: EntryType.income,
        cardId: Value(cardId),
      ));

      expect(await cardBalanceOf(cardId), 15000);
    });

    test('deleting a card-linked entry reverses its charge', () async {
      final id = await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: DateTime(2026, 8, 15),
        amountCents: 4500,
        type: EntryType.expense,
        cardId: Value(cardId),
      ));

      await repo.deleteBudgetEntry(profileId: profileId, id: id);

      expect(await cardBalanceOf(cardId), 20000);
    });

    test('deleting the card clears the link but keeps the entry', () async {
      final id = await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: DateTime(2026, 8, 15),
        amountCents: 4500,
        type: EntryType.expense,
        cardId: Value(cardId),
      ));

      await repo.deleteCard(profileId: profileId, id: cardId);

      final entries = await repo
          .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 8))
          .first;
      final entry = entries.firstWhere((e) => e.id == id);
      expect(entry.cardId, isNull);
    });
  });
}
