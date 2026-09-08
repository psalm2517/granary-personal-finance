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

  test('adding an account records a snapshot automatically', () async {
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(250000)));

    final history =
        await repo.watchNetWorthHistory(profileId: profileId).first;
    expect(history.length, 1);
    expect(history.single.totalAssetsCents, 250000);
    expect(history.single.netWorthCents, 250000);
  });

  test('editing balances the same day updates the point, not adds one',
      () async {
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(250000)));
    await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: 'Visa',
        creditLimitCents: 500000,
        balanceCents: const Value(50000)));
    await repo.upsertLoan(LoansCompanion.insert(
        profileId: profileId,
        name: 'Car',
        balanceCents: 800000,
        originalAmountCents: 1500000));

    final history =
        await repo.watchNetWorthHistory(profileId: profileId).first;
    expect(history.length, 1, reason: 'one point per day');
    expect(history.single.totalAssetsCents, 250000);
    expect(history.single.totalDebtCents, 850000);
    expect(history.single.netWorthCents, -600000,
        reason: 'net worth can be negative and must be recorded as such');
  });

  test('snapshots are per profile', () async {
    final other =
        await repo.createProfile(ProfilesCompanion.insert(name: 'Mom'));
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Mine',
        type: AccountType.savings,
        balanceCents: const Value(100000)));

    expect(
        (await repo.watchNetWorthHistory(profileId: profileId).first).length,
        1);
    expect(await repo.watchNetWorthHistory(profileId: other).first, isEmpty);
  });

  test('deleting a card updates the snapshot and clears its payments',
      () async {
    final cardId = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: 'Visa',
        creditLimitCents: 500000,
        balanceCents: const Value(120000)));
    await db.into(db.payments).insert(PaymentsCompanion.insert(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: cardId,
        amountCents: 5000,
        date: DateTime.now()));

    await repo.deleteCard(profileId: profileId, id: cardId);

    final history =
        await repo.watchNetWorthHistory(profileId: profileId).first;
    expect(history.single.totalDebtCents, 0,
        reason: 'the snapshot reflects the card being gone');
    expect(await db.select(db.payments).get(), isEmpty,
        reason: 'payments must not be orphaned by a deleted card');
  });

  test('deleting a profile removes its snapshots, payments and goals',
      () async {
    final other = await repo.createProfile(
        ProfilesCompanion.insert(name: 'Mom', isAdmin: const Value(false)));
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: other,
        name: 'Hers',
        type: AccountType.savings,
        balanceCents: const Value(100000)));
    await db.into(db.goals).insert(GoalsCompanion.insert(
        profileId: other,
        name: 'Trip',
        type: GoalType.savings,
        targetAmountCents: 500000));

    await repo.deleteProfile(id: other);

    expect(await db.select(db.netWorthSnapshots).get(), isEmpty);
    expect(await db.select(db.goals).get(), isEmpty);
    expect(await db.select(db.payments).get(), isEmpty);
  });
}
