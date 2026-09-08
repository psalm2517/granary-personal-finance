import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:granary/data/backup.dart';
import 'package:granary/data/database.dart';
import 'package:granary/data/repository.dart';

void main() {
  late AppDatabase db;
  late HomebaseRepository repo;
  late BackupService backup;
  late int owner;
  late int member;

  /// Builds a profile with a row in every table that belongs to a profile,
  /// so the round-trip test actually proves nothing is dropped.
  Future<void> populate(int profileId, String tag) async {
    final accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: '$tag checking',
        type: AccountType.checking,
        balanceCents: const Value(250000)));
    final cardId = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: '$tag visa',
        creditLimitCents: 500000,
        balanceCents: const Value(120000),
        annualFeeCents: const Value(9500),
        annualFeeDate: Value(DateTime(2027, 3, 1))));
    final loanId = await repo.upsertLoan(LoansCompanion.insert(
        profileId: profileId,
        name: '$tag car',
        balanceCents: 800000,
        originalAmountCents: 1500000,
        monthlyPaymentCents: const Value(35000)));
    final savingsId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: '$tag savings',
        type: AccountType.savings,
        balanceCents: const Value(500000)));
    final billId = await repo.upsertBill(BillsCompanion.insert(
        profileId: profileId,
        name: '$tag phone',
        amountCents: 9400,
        dueDay: 18));
    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 8),
        paid: true);
    await repo.upsertSchedule(PaycheckSchedulesCompanion.insert(
            profileId: profileId,
            name: '$tag job',
            frequency: PayFrequency.biweekly,
            anchorDate: DateTime(2026, 8, 7),
            amountCents: 185000));
    await repo.generateDuePaychecks(
        profileId: profileId, until: DateTime(2026, 9, 30));
    final paycheck =
        (await repo.watchPaychecks(profileId: profileId).first).first;
    await repo.upsertAllocation(PaycheckAllocationsCompanion.insert(
        profileId: profileId,
        paycheckId: paycheck.id,
        target: 'Savings',
        amountCents: 50000));
    final entryId = await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: DateTime(2026, 8, 10),
        amountCents: 4200,
        type: EntryType.expense,
        category: const Value('Groceries'),
        accountId: Value(accountId)));
    await repo.setEntryTags(
        profileId: profileId, entryId: entryId, tagNames: ['$tag-trip']);
    await repo.upsertRecurringTransfer(RecurringTransfersCompanion.insert(
        profileId: profileId,
        name: '$tag to savings',
        fromAccountId: accountId,
        toAccountId: savingsId,
        amountCents: 20000,
        frequency: PayFrequency.monthly,
        anchorDate: DateTime(2026, 8, 1)));
    await repo.materializeDueTransfers(
        profileId: profileId, now: DateTime(2026, 8, 15));
    await repo.upsertBudgetTarget(BudgetTargetsCompanion.insert(
        profileId: profileId,
        category: 'Groceries',
        monthlyTargetCents: 40000));
    await repo.upsertRule(CategoryRulesCompanion.insert(
        profileId: profileId,
        field: RuleField.description,
        pattern: 'coffee',
        category: 'Coffee'));
    await repo.addScoreSnapshot(CreditScoreSnapshotsCompanion.insert(
        profileId: profileId,
        date: DateTime(2026, 8, 1),
        score: 720,
        utilization: 0.28));
    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.card,
        accountId: cardId,
        amountCents: 10000,
        note: '$tag payment');
    await repo.addPayment(
        profileId: profileId,
        accountType: PaymentAccountType.loan,
        accountId: loanId,
        amountCents: 35000);
    await repo.upsertGoal(GoalsCompanion.insert(
        profileId: profileId,
        name: '$tag fund',
        type: GoalType.savings,
        targetAmountCents: 1000000,
        currentAmountCents: const Value(250000),
        targetDate: Value(DateTime(2027, 6, 1))));
  }

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = HomebaseRepository(db);
    backup = BackupService(db);
    owner = await repo.createProfile(
        ProfilesCompanion.insert(name: 'Owner', isAdmin: const Value(true)));
    member =
        await repo.createProfile(ProfilesCompanion.insert(name: 'Mom'));
  });

  tearDown(() => db.close());

  Future<Map<String, int>> counts() async => {
        'accounts': (await db.select(db.accounts).get()).length,
        'accountBalanceSnapshots':
            (await db.select(db.accountBalanceSnapshots).get()).length,
        'creditCards': (await db.select(db.creditCards).get()).length,
        'loans': (await db.select(db.loans).get()).length,
        'bills': (await db.select(db.bills).get()).length,
        'billPayments': (await db.select(db.billPayments).get()).length,
        'paychecks': (await db.select(db.paychecks).get()).length,
        'paycheckAllocations':
            (await db.select(db.paycheckAllocations).get()).length,
        'budgetEntries': (await db.select(db.budgetEntries).get()).length,
        'tags': (await db.select(db.tags).get()).length,
        'budgetEntryTags': (await db.select(db.budgetEntryTags).get()).length,
        'budgetTargets': (await db.select(db.budgetTargets).get()).length,
        'categoryRules': (await db.select(db.categoryRules).get()).length,
        'payments': (await db.select(db.payments).get()).length,
        'goals': (await db.select(db.goals).get()).length,
        'recurringTransfers':
            (await db.select(db.recurringTransfers).get()).length,
        'transferLogs': (await db.select(db.transferLogs).get()).length,
      };

  test('a full backup restores every table exactly', () async {
    await populate(owner, 'owner');
    final before = await counts();
    final json = await backup.exportJson(profileIds: [owner, member]);

    // Wipe everything the backup covers, then bring it back.
    await backup.restore(json);

    expect(await counts(), before, reason: 'no table may be dropped');
    final card = (await repo.watchCards(profileId: owner).first).single;
    expect(card.name, 'owner visa');
    expect(card.balanceCents, 110000,
        reason: 'the balance after the logged payment survives the round trip');
    expect(card.annualFeeDate, DateTime(2027, 3, 1),
        reason: 'dates survive the round trip');
    final goal = (await repo.watchGoals(profileId: owner).first).single;
    expect(goal.currentAmountCents, 250000);
    expect(goal.targetDate, DateTime(2027, 6, 1));

    final tags = await repo.watchTags(profileId: owner).first;
    expect(tags.map((t) => t.name), contains('owner-trip'),
        reason: 'tags survive the round trip');
    final tagsByEntry = await repo.watchEntryTagNames(profileId: owner).first;
    expect(tagsByEntry.values.single, ['owner-trip'],
        reason: 'the tag stays linked to its entry, not just present');
    final transfers =
        await repo.watchRecurringTransfers(profileId: owner).first;
    expect(transfers.single.name, 'owner to savings');
    final history = await repo.watchTransferHistory(profileId: owner).first;
    expect(history, isNotEmpty,
        reason: 'executed transfer history survives the round trip');
  });

  test('restore replaces rather than merges', () async {
    await populate(owner, 'owner');
    final json = await backup.exportJson(profileIds: [owner]);

    // Something added after the backup must not survive the restore.
    await repo.upsertGoal(GoalsCompanion.insert(
        profileId: owner,
        name: 'Added later',
        type: GoalType.savings,
        targetAmountCents: 500));

    await backup.restore(json);

    final goals = await repo.watchGoals(profileId: owner).first;
    expect(goals.map((g) => g.name), ['owner fund'],
        reason: 'replace means the later goal is gone');
  });

  test('a single-profile backup leaves other profiles untouched', () async {
    await populate(owner, 'owner');
    await populate(member, 'mom');
    final json = await backup.exportJson(profileIds: [member]);

    await backup.restore(json);

    expect((await repo.watchGoals(profileId: owner).first).single.name,
        'owner fund',
        reason: 'the admin profile was not in the backup, so it is intact');
    expect((await repo.watchGoals(profileId: member).first).single.name,
        'mom fund');
  });

  test('an export only contains the profiles asked for', () async {
    await populate(owner, 'owner');
    await populate(member, 'mom');

    final json = await backup.exportJson(profileIds: [member]);

    expect(json, contains('mom fund'));
    expect(json, isNot(contains('owner fund')),
        reason: 'a non-admin export must not leak another profile');
    final summary = backup.inspect(json);
    expect(summary.profileNames, ['Mom']);
  });

  test('restoring is blocked from touching profiles you cannot see',
      () async {
    await populate(owner, 'owner');
    await populate(member, 'mom');
    final fullBackup =
        await backup.exportJson(profileIds: [owner, member]);

    // A member restoring a household backup must only affect themselves.
    await repo.upsertGoal(GoalsCompanion.insert(
        profileId: owner,
        name: 'Admin only',
        type: GoalType.savings,
        targetAmountCents: 500));

    await backup.restore(fullBackup, allowedProfileIds: [member]);

    final ownerGoals = await repo.watchGoals(profileId: owner).first;
    expect(ownerGoals.map((g) => g.name), contains('Admin only'),
        reason: 'the admin profile must be untouched by a member restore');
  });

  test('inspect reports what a backup holds without applying it', () async {
    await populate(owner, 'owner');
    final json = await backup.exportJson(profileIds: [owner]);

    final summary = backup.inspect(json);

    expect(summary.profileNames, ['Owner']);
    expect(summary.schemaVersion, db.schemaVersion);
    expect(summary.rowCounts['goals'], 1);
    expect(summary.totalRows, greaterThan(10));
    // Nothing changed just from looking.
    expect((await repo.watchGoals(profileId: owner).first).length, 1);
  });

  test('garbage is rejected with a readable message', () {
    expect(() => backup.inspect('not json at all'),
        throwsA(isA<BackupException>()));
    expect(() => backup.inspect('{"something": "else"}'),
        throwsA(isA<BackupException>()));
  });

  test('a backup from a newer Homebase is refused', () async {
    await populate(owner, 'owner');
    final json = await backup.exportJson(profileIds: [owner]);
    final tampered = json.replaceFirst(
        '"formatVersion": 1', '"formatVersion": 99');

    expect(() => backup.inspect(tampered),
        throwsA(isA<BackupException>()));
  });

  test('a backup from a newer schema is refused before deleting anything',
      () async {
    await populate(owner, 'owner');
    final json = await backup.exportJson(profileIds: [owner]);
    final tampered = json.replaceFirst(
        '"schemaVersion": ${db.schemaVersion}', '"schemaVersion": 999');

    await expectLater(
        backup.restore(tampered), throwsA(isA<BackupException>()));
    expect((await repo.watchGoals(profileId: owner).first).length, 1,
        reason: 'a refused restore must not have destroyed anything');
  });
}
