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

  test('a transfer this month shows up under the destination account\'s name',
      () async {
    final checking = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId, name: 'Checking', type: AccountType.checking));
    final savings = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId, name: 'Savings', type: AccountType.savings));
    await repo.postManualTransfer(
      profileId: profileId,
      fromAccountId: checking,
      toAccountId: savings,
      amountCents: 20000,
      date: DateTime(2026, 8, 15),
      name: 'To savings',
    );

    final movements = await repo
        .watchRealMoneyMovementsForMonth(
            profileId: profileId, month: DateTime(2026, 8))
        .first;

    expect(movements['Transfer to Savings'], 20000);
  });

  test('a card payment paid from an account shows up under the card\'s name',
      () async {
    final checking = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId, name: 'Checking', type: AccountType.checking));
    final cardId = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId, name: 'Visa', creditLimitCents: 500000));
    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: cardId,
        amountCents: 15000,
        date: DateTime(2026, 8, 10),
        fromAccountId: checking);

    final movements = await repo
        .watchRealMoneyMovementsForMonth(
            profileId: profileId, month: DateTime(2026, 8))
        .first;

    expect(movements['Card payment — Visa'], 15000);
  });

  test('a card payment with no linked account is not counted', () async {
    final cardId = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId, name: 'Visa', creditLimitCents: 500000));
    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: cardId,
        amountCents: 15000,
        date: DateTime(2026, 8, 10));

    final movements = await repo
        .watchRealMoneyMovementsForMonth(
            profileId: profileId, month: DateTime(2026, 8))
        .first;

    expect(movements, isEmpty);
  });

  test('movements in a different month are excluded', () async {
    final checking = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId, name: 'Checking', type: AccountType.checking));
    final savings = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId, name: 'Savings', type: AccountType.savings));
    await repo.postManualTransfer(
      profileId: profileId,
      fromAccountId: checking,
      toAccountId: savings,
      amountCents: 20000,
      date: DateTime(2026, 7, 15),
      name: 'To savings',
    );

    final movements = await repo
        .watchRealMoneyMovementsForMonth(
            profileId: profileId, month: DateTime(2026, 8))
        .first;

    expect(movements, isEmpty);
  });

  group('watchBillsPaidThisMonthCents', () {
    test('only counts bills actually marked paid, not everything due',
        () async {
      final paid = await repo.upsertBill(BillsCompanion.insert(
          profileId: profileId, name: 'Rent', amountCents: 150000, dueDay: 1));
      await repo.upsertBill(BillsCompanion.insert(
          profileId: profileId,
          name: 'Electric',
          amountCents: 9000,
          dueDay: 15));
      await repo.setBillPaid(
          profileId: profileId,
          billId: paid,
          month: DateTime(2026, 8),
          paid: true);

      final paidCents = await repo
          .watchBillsPaidThisMonthCents(
              profileId: profileId, month: DateTime(2026, 8))
          .first;
      final dueCents = await repo
          .watchBillsDueThisMonthCents(
              profileId: profileId, month: DateTime(2026, 8))
          .first;

      expect(paidCents, 150000);
      expect(dueCents, 159000, reason: 'due counts both, paid or not');
    });
  });
}
