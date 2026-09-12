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

  Future<int> addBill({int? sourceId, PaymentSourceType? sourceType}) =>
      repo.upsertBill(BillsCompanion.insert(
        profileId: profileId,
        name: 'Phone',
        amountCents: 6000,
        dueDay: 15,
        paymentSourceType: Value(sourceType),
        paymentSourceId: Value(sourceId),
      ));

  test('paying a bill linked to an account mirrors the link onto the '
      'auto-created budget entry', () async {
    final accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking));
    final billId = await addBill(
        sourceId: accountId, sourceType: PaymentSourceType.account);

    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 9),
        paid: true);

    final entry = (await db.select(db.budgetEntries).get()).single;
    expect(entry.accountId, accountId);
  });

  test('paying a bill linked to a card leaves the mirrored budget entry '
      'unlinked, since it only points at accounts', () async {
    final cardId = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId, name: 'Visa', creditLimitCents: 500000));
    final billId =
        await addBill(sourceId: cardId, sourceType: PaymentSourceType.card);

    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 9),
        paid: true);

    final entry = (await db.select(db.budgetEntries).get()).single;
    expect(entry.accountId, isNull);
  });

  test('deleting the linked account clears the bill\'s payment source',
      () async {
    final accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking));
    final billId = await addBill(
        sourceId: accountId, sourceType: PaymentSourceType.account);

    await repo.deleteAccount(profileId: profileId, id: accountId);

    final b = await (db.select(db.bills)..where((b) => b.id.equals(billId)))
        .getSingle();
    expect(b.paymentSourceType, isNull);
    expect(b.paymentSourceId, isNull);
  });

  test('deleting the linked card clears the bill\'s payment source',
      () async {
    final cardId = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId, name: 'Visa', creditLimitCents: 500000));
    final billId =
        await addBill(sourceId: cardId, sourceType: PaymentSourceType.card);

    await repo.deleteCard(profileId: profileId, id: cardId);

    final b = await (db.select(db.bills)..where((b) => b.id.equals(billId)))
        .getSingle();
    expect(b.paymentSourceType, isNull);
    expect(b.paymentSourceId, isNull);
  });

  test('paying a bill linked to an account withdraws the amount from it',
      () async {
    final accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(100000)));
    final billId = await addBill(
        sourceId: accountId, sourceType: PaymentSourceType.account);

    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 9),
        paid: true);

    final account = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == accountId);
    expect(account.balanceCents, 94000);
  });

  test('paying a bill linked to a card charges the amount to it', () async {
    final cardId = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: 'Visa',
        creditLimitCents: 500000,
        balanceCents: const Value(20000)));
    final billId =
        await addBill(sourceId: cardId, sourceType: PaymentSourceType.card);

    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 9),
        paid: true);

    final card = (await repo.watchCards(profileId: profileId).first)
        .firstWhere((c) => c.id == cardId);
    expect(card.balanceCents, 26000);
  });

  test('un-paying a bill reverses the balance change it caused', () async {
    final cardId = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: 'Visa',
        creditLimitCents: 500000,
        balanceCents: const Value(20000)));
    final billId =
        await addBill(sourceId: cardId, sourceType: PaymentSourceType.card);
    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 9),
        paid: true);

    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 9),
        paid: false);

    final card = (await repo.watchCards(profileId: profileId).first)
        .firstWhere((c) => c.id == cardId);
    expect(card.balanceCents, 20000);
  });

  test('paying a bill twice for the same month only moves the balance once',
      () async {
    final cardId = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: 'Visa',
        creditLimitCents: 500000,
        balanceCents: const Value(20000)));
    final billId =
        await addBill(sourceId: cardId, sourceType: PaymentSourceType.card);

    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 9),
        paid: true);
    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 9),
        paid: true);

    final card = (await repo.watchCards(profileId: profileId).first)
        .firstWhere((c) => c.id == cardId);
    expect(card.balanceCents, 26000);
  });

  test('deleting a bill reverses the balance change of every period it was '
      'paid for', () async {
    final cardId = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: 'Visa',
        creditLimitCents: 500000,
        balanceCents: const Value(0)));
    final billId =
        await addBill(sourceId: cardId, sourceType: PaymentSourceType.card);
    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 8),
        paid: true);
    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 9),
        paid: true);

    await repo.deleteBill(profileId: profileId, id: billId);

    final card = (await repo.watchCards(profileId: profileId).first)
        .firstWhere((c) => c.id == cardId);
    expect(card.balanceCents, 0);
  });
}
