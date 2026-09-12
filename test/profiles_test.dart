import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clearly/data/database.dart';
import 'package:clearly/data/repository.dart';

void main() {
  late AppDatabase db;
  late HomebaseRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = HomebaseRepository(db);
  });

  tearDown(() => db.close());

  Future<int> addProfile(String name, {bool admin = false}) =>
      repo.createProfile(
          ProfilesCompanion.insert(name: name, isAdmin: Value(admin)));

  test('supports any number of profiles', () async {
    await addProfile('Owner', admin: true);
    for (final name in ['Mom', 'Dad', 'Roommate']) {
      await addProfile(name);
    }
    expect((await repo.allProfiles()).length, 4);
  });

  test('queries only return the requested profile\'s rows', () async {
    final mine = await addProfile('Owner', admin: true);
    final theirs = await addProfile('Mom');
    await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: mine, name: 'My Visa', creditLimitCents: 500000));
    await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: theirs, name: 'Her Amex', creditLimitCents: 300000));

    expect((await repo.watchCards(profileId: theirs).first).map((c) => c.name),
        ['Her Amex']);
    expect((await repo.watchCards(profileId: mine).first).map((c) => c.name),
        ['My Visa']);
  });

  test('deleting a profile removes its data but leaves others intact',
      () async {
    final mine = await addProfile('Owner', admin: true);
    final theirs = await addProfile('Mom');
    await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: mine, name: 'My Visa', creditLimitCents: 500000));
    await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: theirs, name: 'Her Amex', creditLimitCents: 300000));

    await repo.deleteProfile(id: theirs);

    expect(await repo.profileById(theirs), isNull);
    expect((await repo.watchCards(profileId: theirs).first), isEmpty);
    expect((await repo.watchCards(profileId: mine).first).length, 1);
  });

  test('deleting a profile that has tagged an entry does not crash on a '
      'foreign key', () async {
    final mine = await addProfile('Owner', admin: true);
    final theirs = await addProfile('Mom');
    final entryId = await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: theirs,
        date: DateTime.now(),
        amountCents: 5000,
        type: EntryType.expense));
    await repo.setEntryTags(
        profileId: theirs, entryId: entryId, tagNames: ['groceries']);

    await repo.deleteProfile(id: theirs);

    expect(await repo.profileById(theirs), isNull);
    expect(await repo.profileById(mine), isNotNull);
  });

  test('deleting a profile removes its recurring transfers via its '
      'accounts cascading away', () async {
    final mine = await addProfile('Owner', admin: true);
    final theirs = await addProfile('Mom');
    final from = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: theirs,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(10000)));
    final to = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: theirs,
        name: 'Savings',
        type: AccountType.savings,
        balanceCents: const Value(0)));
    await repo.upsertRecurringTransfer(RecurringTransfersCompanion.insert(
        profileId: theirs,
        name: 'To savings',
        fromAccountId: from,
        toAccountId: to,
        amountCents: 5000,
        frequency: PayFrequency.monthly,
        anchorDate: DateTime.now()));

    await repo.deleteProfile(id: theirs);

    expect(await repo.profileById(theirs), isNull);
    expect(await repo.profileById(mine), isNotNull);
  });

  test('the only admin cannot be deleted', () async {
    final admin = await addProfile('Owner', admin: true);
    await addProfile('Mom');
    await expectLater(repo.deleteProfile(id: admin), throwsStateError);

    // With a second admin present, removal is allowed.
    await addProfile('Co-admin', admin: true);
    await repo.deleteProfile(id: admin);
    expect(await repo.profileById(admin), isNull);
  });
}
