import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clearly/data/backup.dart';
import 'package:clearly/data/database.dart';
import 'package:clearly/data/repository.dart';

void main() {
  late AppDatabase db;
  late HomebaseRepository repo;
  late int pid;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = HomebaseRepository(db);
    pid = await repo.createProfile(
        ProfilesCompanion.insert(name: 'O', isAdmin: const Value(true)));
  });
  tearDown(() => db.close());

  test('deleting an account keeps its budget entries and clears the link',
      () async {
    final accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: pid, name: 'Checking', type: AccountType.checking));
    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: pid,
        date: DateTime.now(),
        amountCents: 5000,
        type: EntryType.expense,
        accountId: Value(accountId)));

    await repo.deleteAccount(profileId: pid, id: accountId);

    final entries = await repo
        .watchBudgetForMonth(profileId: pid, month: DateTime.now())
        .first;
    expect(entries.length, 1, reason: 'the UI promises the entry survives');
    expect(entries.single.accountId, isNull, reason: 'but loses its link');
  });

  test('a backup from an older schema restores despite renamed columns',
      () async {
    // Simulates a v10-era backup: has statement_day, lacks the newer columns.
    final oldBackup = jsonEncode({
      'homebase': {
        'formatVersion': 1,
        'schemaVersion': 10,
        'exportedAt': DateTime.now().toIso8601String(),
        'profiles': [
          {'id': pid, 'name': 'O'}
        ],
      },
      'data': {
        'profiles': [
          {'id': pid, 'name': 'O', 'pin_hash': null, 'is_admin': 1}
        ],
        'creditCards': [
          {
            'id': 1,
            'profile_id': pid,
            'name': 'Visa',
            'balance_cents': 120000,
            'credit_limit_cents': 500000,
            'apr': 0.0,
            'annual_fee_cents': 0,
            'monthly_fee_cents': 0,
            'statement_day': 20,
            'payment_due_day': 15,
          }
        ],
      },
    });

    await BackupService(db).restore(oldBackup);
    final cards = await repo.watchCards(profileId: pid).first;
    expect(cards.single.name, 'Visa');
  });

  test('deleting an autopay bill with a generated entry works', () async {
    final billId = await repo.upsertBill(BillsCompanion.insert(
        profileId: pid,
        name: 'Net',
        amountCents: 6000,
        dueDay: 1,
        autopay: const Value(true)));
    await repo.materializeAutopayPayments(
        profileId: pid, month: DateTime.now());

    await repo.deleteBill(profileId: pid, id: billId);
    expect(await repo.watchBills(profileId: pid).first, isEmpty);
  });

  test('deleting a schedule keeps the paychecks it already produced',
      () async {
    final sid = await repo.upsertSchedule(PaycheckSchedulesCompanion.insert(
        profileId: pid,
        name: 'Job',
        frequency: PayFrequency.biweekly,
        anchorDate: DateTime.now().subtract(const Duration(days: 14)),
        amountCents: 100000));
    await repo.generateDuePaychecks(
        profileId: pid, until: DateTime.now());
    await repo.materializeReceivedPaychecks(profileId: pid);

    await repo.deleteSchedule(profileId: pid, id: sid);
    expect(await repo.watchSchedules(profileId: pid).first, isEmpty);
    final kept = await repo.watchPaychecks(profileId: pid).first;
    expect(kept, isNotEmpty,
        reason: 'money already paid is history, not part of the schedule');
    expect(kept.every((p) => p.scheduleId == null), isTrue,
        reason: 'but they are cut loose from the deleted schedule');
  });

  test('a profile holding every kind of data can be deleted', () async {
    final other = await repo.createProfile(ProfilesCompanion.insert(name: 'M'));
    final acc = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: other, name: 'A', type: AccountType.checking));
    await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: other,
        date: DateTime.now(),
        amountCents: 100,
        type: EntryType.expense,
        accountId: Value(acc)));
    final card = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: other, name: 'C', creditLimitCents: 1000));
    await repo.addPayment(
        profileId: other,
        accountType: PaymentAccountType.card,
        accountId: card,
        amountCents: 100);
    final bill = await repo.upsertBill(BillsCompanion.insert(
        profileId: other, name: 'B', amountCents: 100, dueDay: 1));
    await repo.setBillPaid(
        profileId: other, billId: bill, month: DateTime.now(), paid: true);

    await repo.deleteProfile(id: other);
    expect(await repo.profileById(other), isNull);
  });

  test('undoing a payment restores the balance and clears the log', () async {
    final card = await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: pid,
        name: 'Visa',
        creditLimitCents: 500000,
        balanceCents: const Value(120000)));
    await repo.addPayment(
        profileId: pid,
        accountType: PaymentAccountType.card,
        accountId: card,
        amountCents: 20000);
    final logged = await repo
        .watchPaymentsFor(
            profileId: pid,
            accountType: PaymentAccountType.card,
            accountId: card)
        .first;
    expect(logged.single.amountCents, 20000);

    await repo.deletePayment(profileId: pid, id: logged.single.id);

    expect((await repo.watchCards(profileId: pid).first).single.balanceCents,
        120000,
        reason: 'a mistyped payment must be undoable from the UI');
    expect(
        await repo
            .watchPaymentsFor(
                profileId: pid,
                accountType: PaymentAccountType.card,
                accountId: card)
            .first,
        isEmpty);
  });
}
