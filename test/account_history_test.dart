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

  test('an account\'s history includes entries linked to it, signed by '
      'direction', () async {
    final accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId, name: 'Checking', type: AccountType.checking));
    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 10),
      amountCents: 5000,
      type: EntryType.expense,
      description: const Value('Groceries'),
      accountId: Value(accountId),
    ));
    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 15),
      amountCents: 200000,
      type: EntryType.income,
      description: const Value('Paycheck'),
      accountId: Value(accountId),
    ));

    final activity = await repo
        .watchAccountHistory(profileId: profileId, accountId: accountId)
        .first;

    expect(activity, hasLength(2));
    expect(activity.first.label, 'Paycheck', reason: 'newest first');
    expect(activity.first.amountCents, 200000);
    expect(activity.last.amountCents, -5000);
  });

  test('an account\'s history includes transfers naming it as either side',
      () async {
    final checking = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId, name: 'Checking', type: AccountType.checking));
    final savings = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId, name: 'Savings', type: AccountType.savings));
    await repo.upsertRecurringTransfer(RecurringTransfersCompanion.insert(
        profileId: profileId,
        name: 'To savings',
        fromAccountId: checking,
        toAccountId: savings,
        amountCents: 20000,
        frequency: PayFrequency.monthly,
        anchorDate: DateTime(2026, 8, 1)));
    await repo.materializeDueTransfers(
        profileId: profileId, now: DateTime(2026, 8, 1));

    final checkingActivity = await repo
        .watchAccountHistory(profileId: profileId, accountId: checking)
        .first;
    final savingsActivity = await repo
        .watchAccountHistory(profileId: profileId, accountId: savings)
        .first;

    expect(checkingActivity.single.amountCents, -20000);
    expect(checkingActivity.single.kind, AccountActivityKind.transferOut);
    expect(savingsActivity.single.amountCents, 20000);
    expect(savingsActivity.single.kind, AccountActivityKind.transferIn);
  });

  test('a card\'s history shows a charge as positive and a refund as '
      'negative', () async {
    final cardId = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId, name: 'Visa', creditLimitCents: 500000));
    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 10),
      amountCents: 4500,
      type: EntryType.expense,
      description: const Value('Groceries'),
      cardId: Value(cardId),
    ));
    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 12),
      amountCents: 1000,
      type: EntryType.income,
      description: const Value('Refund'),
      cardId: Value(cardId),
    ));

    final activity = await repo
        .watchCardHistory(profileId: profileId, cardId: cardId)
        .first;

    expect(activity, hasLength(2));
    final charge = activity.firstWhere((a) => a.label == 'Groceries');
    final refund = activity.firstWhere((a) => a.label == 'Refund');
    expect(charge.amountCents, 4500);
    expect(refund.amountCents, -1000);
  });

  test('an entry with no account or card link never appears in any history',
      () async {
    final accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId, name: 'Checking', type: AccountType.checking));
    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
      profileId: profileId,
      date: DateTime(2026, 8, 10),
      amountCents: 5000,
      type: EntryType.expense,
    ));

    final activity = await repo
        .watchAccountHistory(profileId: profileId, accountId: accountId)
        .first;

    expect(activity, isEmpty);
  });
}
