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

  Future<int> addBill({
    String name = 'Phone',
    int cents = 8000,
    int dueDay = 18,
    bool autopay = false,
    String category = 'Utilities',
  }) =>
      repo.upsertBill(BillsCompanion.insert(
        profileId: profileId,
        name: name,
        amountCents: cents,
        dueDay: dueDay,
        autopay: Value(autopay),
        category: Value(category),
      ));

  test('marking a bill paid creates a matching expense entry', () async {
    final billId = await addBill();
    final month = DateTime(2026, 8);

    await repo.setBillPaid(
        profileId: profileId, billId: billId, month: month, paid: true);

    final entries =
        await repo.watchBudgetForMonth(profileId: profileId, month: month).first;
    expect(entries.length, 1);
    expect(entries.single.type, EntryType.expense);
    expect(entries.single.amountCents, 8000);
    expect(entries.single.category, 'Utilities',
        reason: 'uses the bill\'s own category');
    expect(entries.single.sourceBillPaymentId, isNotNull);
  });

  test('un-marking paid removes the expense entry', () async {
    final billId = await addBill();
    final month = DateTime(2026, 8);
    await repo.setBillPaid(
        profileId: profileId, billId: billId, month: month, paid: true);

    await repo.setBillPaid(
        profileId: profileId, billId: billId, month: month, paid: false);

    final entries =
        await repo.watchBudgetForMonth(profileId: profileId, month: month).first;
    expect(entries, isEmpty, reason: 'cascade removes the mirrored entry');
  });

  test('marking paid twice does not duplicate the entry', () async {
    final billId = await addBill();
    final month = DateTime(2026, 8);

    await repo.setBillPaid(
        profileId: profileId, billId: billId, month: month, paid: true);
    await repo.setBillPaid(
        profileId: profileId, billId: billId, month: month, paid: true);

    final entries =
        await repo.watchBudgetForMonth(profileId: profileId, month: month).first;
    expect(entries.length, 1);
  });

  test('paying the same bill in two months creates one entry each', () async {
    final billId = await addBill();
    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 7),
        paid: true);
    await repo.setBillPaid(
        profileId: profileId,
        billId: billId,
        month: DateTime(2026, 8),
        paid: true);

    final july = await repo
        .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 7))
        .first;
    final august = await repo
        .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 8))
        .first;
    expect(july.length, 1);
    expect(august.length, 1);
  });

  test('deleting a bill removes its mirrored entries', () async {
    final billId = await addBill();
    final month = DateTime(2026, 8);
    await repo.setBillPaid(
        profileId: profileId, billId: billId, month: month, paid: true);

    await repo.deleteBill(profileId: profileId, id: billId);

    final entries =
        await repo.watchBudgetForMonth(profileId: profileId, month: month).first;
    expect(entries, isEmpty);
  });

  group('autopay materialization', () {
    test('writes a payment and entry once the due date has passed', () async {
      final now = DateTime.now();
      // Due on the 1st of the current month — already passed unless today
      // is the 1st, in which case it is due today, which also counts.
      await addBill(name: 'Internet', dueDay: 1, autopay: true, cents: 6000);

      await repo.materializeAutopayPayments(
          profileId: profileId, month: now);

      final entries = await repo
          .watchBudgetForMonth(
              profileId: profileId, month: DateTime(now.year, now.month))
          .first;
      expect(entries.length, 1);
      expect(entries.single.amountCents, 6000);
      expect(entries.single.type, EntryType.expense);
    });

    test('does not write anything before the due date', () async {
      final now = DateTime.now();
      final lastDay = DateTime(now.year, now.month + 1, 0).day;
      if (now.day >= lastDay) return; // no future day left this month
      await addBill(
          name: 'Streaming', dueDay: lastDay, autopay: true, cents: 1500);

      await repo.materializeAutopayPayments(profileId: profileId, month: now);

      final entries = await repo
          .watchBudgetForMonth(
              profileId: profileId, month: DateTime(now.year, now.month))
          .first;
      expect(entries, isEmpty);
    });

    test('is idempotent across repeated calls', () async {
      final now = DateTime.now();
      await addBill(name: 'Internet', dueDay: 1, autopay: true, cents: 6000);

      await repo.materializeAutopayPayments(profileId: profileId, month: now);
      await repo.materializeAutopayPayments(profileId: profileId, month: now);
      await repo.materializeAutopayPayments(profileId: profileId, month: now);

      final entries = await repo
          .watchBudgetForMonth(
              profileId: profileId, month: DateTime(now.year, now.month))
          .first;
      expect(entries.length, 1, reason: 'screen loads must not stack up rows');
    });

    test('leaves non-autopay bills alone', () async {
      final now = DateTime.now();
      await addBill(name: 'Rent', dueDay: 1, autopay: false, cents: 145000);

      await repo.materializeAutopayPayments(profileId: profileId, month: now);

      final entries = await repo
          .watchBudgetForMonth(
              profileId: profileId, month: DateTime(now.year, now.month))
          .first;
      expect(entries, isEmpty,
          reason: 'manual bills still wait for you to check them off');
    });
  });
}
