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

  group('bill paid status is per month', () {
    test('marking paid in one month leaves the next month unpaid', () async {
      final billId = await repo.upsertBill(BillsCompanion.insert(
          profileId: profileId, name: 'Rent', amountCents: 145000, dueDay: 1));
      final august = DateTime(2026, 8);
      final september = DateTime(2026, 9);

      await repo.setBillPaid(
          profileId: profileId, billId: billId, month: august, paid: true);

      final aug = await repo
          .watchBillsForMonth(profileId: profileId, month: august)
          .first;
      final sep = await repo
          .watchBillsForMonth(profileId: profileId, month: september)
          .first;

      expect(aug.single.paid, isTrue, reason: 'paid for August');
      expect(sep.single.paid, isFalse,
          reason: 'September resets on its own — no manual reset');
    });

    test('unmarking removes the payment for that month only', () async {
      final billId = await repo.upsertBill(BillsCompanion.insert(
          profileId: profileId, name: 'Power', amountCents: 9000, dueDay: 12));
      final july = DateTime(2026, 7);
      final august = DateTime(2026, 8);
      await repo.setBillPaid(
          profileId: profileId, billId: billId, month: july, paid: true);
      await repo.setBillPaid(
          profileId: profileId, billId: billId, month: august, paid: true);

      await repo.setBillPaid(
          profileId: profileId, billId: billId, month: august, paid: false);

      expect(
          (await repo
                  .watchBillsForMonth(profileId: profileId, month: july)
                  .first)
              .single
              .paid,
          isTrue,
          reason: 'history for July is kept');
      expect(
          (await repo
                  .watchBillsForMonth(profileId: profileId, month: august)
                  .first)
              .single
              .paid,
          isFalse);
    });

    test('marking paid twice for the same month does not duplicate', () async {
      final billId = await repo.upsertBill(BillsCompanion.insert(
          profileId: profileId, name: 'Water', amountCents: 4000, dueDay: 5));
      final month = DateTime(2026, 8);
      await repo.setBillPaid(
          profileId: profileId, billId: billId, month: month, paid: true);
      await repo.setBillPaid(
          profileId: profileId, billId: billId, month: month, paid: true);

      final rows =
          await repo.watchBillsForMonth(profileId: profileId, month: month).first;
      expect(rows.length, 1);
      expect(rows.single.paid, isTrue);
    });
  });

  group('bill frequency', () {
    Future<int> addBill(String name, BillFrequency freq,
            {int? month, int? year, int cents = 8000}) =>
        repo.upsertBill(BillsCompanion.insert(
          profileId: profileId,
          name: name,
          amountCents: cents,
          dueDay: 3,
          frequency: Value(freq),
          dueMonth: Value(month),
          dueYear: Value(year),
        ));

    test('an annual bill appears only in its month', () async {
      await addBill('Yearly subscription', BillFrequency.annual, month: 3, cents: 12000);

      final march = await repo
          .watchBillsForMonth(profileId: profileId, month: DateTime(2026, 3))
          .first;
      final april = await repo
          .watchBillsForMonth(profileId: profileId, month: DateTime(2026, 4))
          .first;

      expect(march.single.bill.name, 'Yearly subscription');
      expect(april, isEmpty);
    });

    test('a quarterly bill appears every three months from its anchor',
        () async {
      await addBill('Water', BillFrequency.quarterly, month: 2);

      for (final m in [2, 5, 8, 11]) {
        expect(
            (await repo
                    .watchBillsForMonth(
                        profileId: profileId, month: DateTime(2026, m))
                    .first)
                .length,
            1,
            reason: 'due in month $m');
      }
      for (final m in [3, 4, 6]) {
        expect(
            await repo
                .watchBillsForMonth(
                    profileId: profileId, month: DateTime(2026, m))
                .first,
            isEmpty,
            reason: 'not due in month $m');
      }
    });

    test('a one-time bill appears once, in its month and year', () async {
      await addBill('Deposit', BillFrequency.oneTime, month: 9, year: 2026);

      expect(
          (await repo
                  .watchBillsForMonth(
                      profileId: profileId, month: DateTime(2026, 9))
                  .first)
              .length,
          1);
      expect(
          await repo
              .watchBillsForMonth(profileId: profileId, month: DateTime(2027, 9))
              .first,
          isEmpty,
          reason: 'does not repeat the following year');
    });

    test('monthly cost spreads longer periods and skips one-time', () async {
      await addBill('Sub', BillFrequency.annual, month: 3, cents: 12000);
      await addBill('Water', BillFrequency.quarterly, month: 1, cents: 9000);
      await addBill('Rent', BillFrequency.monthly, cents: 145000);
      await addBill('Deposit', BillFrequency.oneTime,
          month: 9, year: 2026, cents: 50000);

      final monthly = await repo.watchMonthlyBillsCents(profileId: profileId).first;
      // 12000/12 = 1000, 9000/3 = 3000, 145000, one-time excluded.
      expect(monthly, 1000 + 3000 + 145000);
    });

    test('monthly card fee counts as due this month; annual fee does not',
        () async {
      await repo.upsertCard(CreditCardsCompanion.insert(
          profileId: profileId,
          name: 'Gold',
          creditLimitCents: 900000,
          annualFeeCents: const Value(32500),
          monthlyFeeCents: const Value(500)));

      final dueThisMonth =
          await repo.watchCardFeesDueThisMonthCents(profileId: profileId).first;
      expect(dueThisMonth, 500,
          reason: 'annual fee is not tied to a known month, so it never '
              'appears as a current-month charge');
    });

    test('annual card fee reserve is a twelfth, separate from real charges',
        () async {
      await repo.upsertCard(CreditCardsCompanion.insert(
          profileId: profileId,
          name: 'Gold',
          creditLimitCents: 900000,
          annualFeeCents: const Value(32500),
          monthlyFeeCents: const Value(500)));

      final reserve =
          await repo.watchReserveForCardFeesCents(profileId: profileId).first;
      // 325.00/12 = 27.08. Monthly fee is excluded — it's already a real
      // monthly charge, not something to additionally reserve for.
      expect(reserve, 2708);
    });

    test('quarterly and annual bill reserve excludes monthly and one-time',
        () async {
      final annual = repo.upsertBill(BillsCompanion.insert(
          profileId: profileId,
          name: 'Yearly subscription',
          amountCents: 12000,
          dueDay: 1,
          frequency: const Value(BillFrequency.annual),
          dueMonth: const Value(3)));
      final quarterly = repo.upsertBill(BillsCompanion.insert(
          profileId: profileId,
          name: 'Water',
          amountCents: 9000,
          dueDay: 1,
          frequency: const Value(BillFrequency.quarterly),
          dueMonth: const Value(1)));
      await repo.upsertBill(BillsCompanion.insert(
          profileId: profileId,
          name: 'Rent',
          amountCents: 145000,
          dueDay: 1,
          frequency: const Value(BillFrequency.monthly)));
      await repo.upsertBill(BillsCompanion.insert(
          profileId: profileId,
          name: 'Deposit',
          amountCents: 50000,
          dueDay: 1,
          frequency: const Value(BillFrequency.oneTime),
          dueMonth: const Value(9),
          dueYear: const Value(2026)));
      await annual;
      await quarterly;

      final reserve = await repo
          .watchReserveForIrregularBillsCents(profileId: profileId)
          .first;
      // 12000/12 = 1000, 9000/3 = 3000. Monthly and one-time excluded.
      expect(reserve, 1000 + 3000);
    });

    test('bills due this month only counts bills that actually fall in it',
        () async {
      await repo.upsertBill(BillsCompanion.insert(
          profileId: profileId,
          name: 'Yearly subscription',
          amountCents: 12000,
          dueDay: 1,
          frequency: const Value(BillFrequency.annual),
          dueMonth: const Value(3)));
      await repo.upsertBill(BillsCompanion.insert(
          profileId: profileId,
          name: 'Rent',
          amountCents: 145000,
          dueDay: 1,
          frequency: const Value(BillFrequency.monthly)));

      final march = await repo
          .watchBillsDueThisMonthCents(
              profileId: profileId, month: DateTime(2026, 3))
          .first;
      final april = await repo
          .watchBillsDueThisMonthCents(
              profileId: profileId, month: DateTime(2026, 4))
          .first;

      expect(march, 12000 + 145000,
          reason: 'the annual bill actually charges in March');
      expect(april, 145000,
          reason: 'the annual bill does not charge again in April');
    });
  });

  group('autopay', () {
    test('an autopay bill auto-marks paid once its due date passes',
        () async {
      final billId = await repo.upsertBill(BillsCompanion.insert(
          profileId: profileId,
          name: 'Phone',
          amountCents: 8000,
          dueDay: 18,
          autopay: const Value(true)));

      final beforeDue = await repo
          .watchBillsForMonth(profileId: profileId, month: DateTime(2026, 8))
          .first;
      // _isPaid compares against DateTime.now(), so use a bill whose due day
      // is guaranteed in the future/past relative to "today" via dueDay.
      expect(beforeDue.single.bill.name, 'Phone');
      // Directly exercise the date logic instead of relying on real "now".
      expect(
          HomebaseRepository.isBillPaid(
              beforeDue.single.bill, false, DateTime(2026, 8), DateTime(2026, 8, 17)),
          isFalse,
          reason: 'due date has not arrived yet');
      expect(
          HomebaseRepository.isBillPaid(
              beforeDue.single.bill, false, DateTime(2026, 8), DateTime(2026, 8, 18)),
          isTrue,
          reason: 'auto-paid the day it is due');
      expect(
          HomebaseRepository.isBillPaid(
              beforeDue.single.bill, false, DateTime(2026, 8), DateTime(2026, 8, 25)),
          isTrue,
          reason: 'stays auto-paid after the due date');
      expect(billId, isNotNull);
    });

    test('a non-autopay bill never auto-marks paid', () async {
      final bill = Bill(
          id: 1,
          profileId: profileId,
          name: 'Rent',
          amountCents: 145000,
          dueDay: 1,
          frequency: BillFrequency.monthly,
          autopay: false,
          category: 'Other');
      expect(
          HomebaseRepository.isBillPaid(
              bill, false, DateTime(2026, 8), DateTime(2026, 8, 20)),
          isFalse,
          reason: 'no autopay, no payment record — stays unpaid');
    });

    test('a manual payment record always counts, autopay or not', () async {
      final bill = Bill(
          id: 1,
          profileId: profileId,
          name: 'Rent',
          amountCents: 145000,
          dueDay: 1,
          frequency: BillFrequency.monthly,
          autopay: false,
          category: 'Other');
      expect(
          HomebaseRepository.isBillPaid(
              bill, true, DateTime(2026, 8), DateTime(2026, 8, 2)),
          isTrue);
    });
  });

  group('statement cycle dates', () {
    CreditCard card({int? statementDay, int? dueDay}) => CreditCard(
          id: 1,
          profileId: 1,
          name: 'Visa',
          balanceCents: 0,
          creditLimitCents: 100000,
          apr: 22.99,
          annualFeeCents: 0,
          monthlyFeeCents: 0,
          statementCloseDay: statementDay,
          paymentDueDay: dueDay,
        );

    test('next close is later this month when the day has not passed', () {
      final cycle = HomebaseRepository.cycleFor(card(statementDay: 20),
          now: DateTime(2026, 8, 14));
      expect(cycle.statementCloses, DateTime(2026, 8, 20));
      expect(cycle.daysToClose, 6);
    });

    test('next close rolls into next month once the day has passed', () {
      final cycle = HomebaseRepository.cycleFor(card(statementDay: 5),
          now: DateTime(2026, 8, 14));
      expect(cycle.statementCloses, DateTime(2026, 9, 5));
    });

    test('a 31st cycle day clamps to the last day of a short month', () {
      final cycle = HomebaseRepository.cycleFor(card(statementDay: 31),
          now: DateTime(2026, 2, 10));
      expect(cycle.statementCloses, DateTime(2026, 2, 28));
    });

    test('cards without a configured cycle report nulls', () {
      final cycle = HomebaseRepository.cycleFor(card());
      expect(cycle.statementCloses, isNull);
      expect(cycle.paymentDue, isNull);
    });
  });
}
