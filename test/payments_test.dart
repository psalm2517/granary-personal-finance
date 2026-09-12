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

  Future<int> addCard({int balance = 120000, int limit = 500000}) =>
      repo.upsertCard(CreditCardsCompanion.insert(
          profileId: profileId,
          name: 'Visa',
          creditLimitCents: limit,
          balanceCents: Value(balance)));

  Future<int> addLoan({int balance = 800000}) =>
      repo.upsertLoan(LoansCompanion.insert(
          profileId: profileId,
          name: 'Car',
          balanceCents: balance,
          originalAmountCents: 1500000,
          monthlyPaymentCents: const Value(35000)));

  test('a card payment is logged and comes off the balance', () async {
    final id = await addCard();

    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: id,
        amountCents: 20000,
        note: 'Extra');

    final card = (await repo.watchCards(profileId: profileId).first).single;
    expect(card.balanceCents, 100000);

    final payments = await repo.watchPayments(profileId: profileId).first;
    expect(payments.single.amountCents, 20000);
    expect(payments.single.note, 'Extra');
    expect(payments.single.accountType, PaymentAccountType.card);
  });

  test('utilization follows the new balance automatically', () async {
    final id = await addCard(balance: 250000, limit: 500000); // 50%

    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: id,
        amountCents: 100000);

    final card = (await repo.watchCards(profileId: profileId).first).single;
    expect(card.balanceCents / card.creditLimitCents, 0.30,
        reason: 'utilization is derived from the balance, so it just moves');
  });

  test('a loan payment reduces the loan balance', () async {
    final id = await addLoan();

    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.loan,
        accountId: id,
        amountCents: 35000);

    final loan = (await repo.watchLoans(profileId: profileId).first).single;
    expect(loan.balanceCents, 765000);
  });

  test('overpaying floors the balance at zero rather than going negative',
      () async {
    final id = await addCard(balance: 5000);

    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: id,
        amountCents: 20000);

    final card = (await repo.watchCards(profileId: profileId).first).single;
    expect(card.balanceCents, 0);
  });

  test('a payment records a net worth snapshot', () async {
    final id = await addCard();

    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: id,
        amountCents: 20000);

    final history =
        await repo.watchNetWorthHistory(profileId: profileId).first;
    expect(history.single.totalDebtCents, 100000);
  });

  test('deleting a payment restores the balance', () async {
    final id = await addCard();
    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: id,
        amountCents: 20000);
    final payment =
        (await repo.watchPayments(profileId: profileId).first).single;

    await repo.deletePayment(profileId: profileId, id: payment.id);

    final card = (await repo.watchCards(profileId: profileId).first).single;
    expect(card.balanceCents, 120000, reason: 'a mistyped payment can be undone');
    expect(await repo.watchPayments(profileId: profileId).first, isEmpty);
  });

  test('a zero or negative payment is rejected', () async {
    final id = await addCard();
    await expectLater(
      repo.addPayment(
          profileId: profileId,
          accountType: PaymentAccountType.card,
          accountId: id,
          amountCents: 0),
      throwsArgumentError,
    );
  });

  test('payments are scoped per account and per profile', () async {
    final cardId = await addCard();
    final loanId = await addLoan();
    final other =
        await repo.createProfile(ProfilesCompanion.insert(name: 'Mom'));

    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: cardId,
        amountCents: 1000);
    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.loan,
        accountId: loanId,
        amountCents: 2000);

    final forCard = await repo
        .watchPaymentsFor(
            profileId: profileId,
            accountType: PaymentAccountType.card,
            accountId: cardId)
        .first;
    expect(forCard.single.amountCents, 1000);
    expect(await repo.watchPayments(profileId: other).first, isEmpty);
  });
}
