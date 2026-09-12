import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clearly/data/database.dart';
import 'package:clearly/data/repository.dart';

void main() {
  late AppDatabase db;
  late HomebaseRepository repo;
  late int profileId;
  late int cardId;
  late int accountId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = HomebaseRepository(db);
    profileId = await repo.createProfile(
        ProfilesCompanion.insert(name: 'Owner', isAdmin: const Value(true)));
    cardId = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: 'Visa',
        creditLimitCents: 500000,
        balanceCents: const Value(120000)));
    accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(300000)));
  });

  tearDown(() => db.close());

  Future<int> cardBalance() async =>
      (await repo.watchCards(profileId: profileId).first)
          .firstWhere((c) => c.id == cardId)
          .balanceCents;

  Future<int> accountBalance() async =>
      (await repo.watchAccounts(profileId: profileId).first)
          .firstWhere((a) => a.id == accountId)
          .balanceCents;

  test(
      'a payment with no linked account only moves the card balance, '
      'as before', () async {
    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: cardId,
        amountCents: 20000);

    expect(await cardBalance(), 100000);
    expect(await accountBalance(), 300000);
  });

  test('a payment linked to an account withdraws from it too', () async {
    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: cardId,
        amountCents: 20000,
        fromAccountId: accountId);

    expect(await cardBalance(), 100000);
    expect(await accountBalance(), 280000);
  });

  test('deleting a linked payment reverses both balances', () async {
    final payments = await repo
        .watchPaymentsFor(
            profileId: profileId,
            accountType: PaymentAccountType.card,
            accountId: cardId)
        .first;
    expect(payments, isEmpty);

    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: cardId,
        amountCents: 20000,
        fromAccountId: accountId);
    final logged = await repo
        .watchPaymentsFor(
            profileId: profileId,
            accountType: PaymentAccountType.card,
            accountId: cardId)
        .first;

    await repo.deletePayment(profileId: profileId, id: logged.single.id);

    expect(await cardBalance(), 120000);
    expect(await accountBalance(), 300000);
  });

  test('deleting the linked account clears the link but keeps the payment',
      () async {
    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: cardId,
        amountCents: 20000,
        fromAccountId: accountId);

    await repo.deleteAccount(profileId: profileId, id: accountId);

    final payments = await repo
        .watchPaymentsFor(
            profileId: profileId,
            accountType: PaymentAccountType.card,
            accountId: cardId)
        .first;
    expect(payments, hasLength(1));
    expect(payments.single.fromAccountId, isNull);
    expect(await cardBalance(), 100000,
        reason: 'the card side of the payment is untouched');
  });
}
