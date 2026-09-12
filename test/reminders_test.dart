import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clearly/data/database.dart';
import 'package:clearly/data/reminder.dart';
import 'package:clearly/data/repository.dart';

void main() {
  late AppDatabase db;
  late HomebaseRepository repo;
  late int profileId;
  // A fixed "today" so the tests do not drift with the real calendar.
  final today = DateTime(2026, 8, 15);

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = HomebaseRepository(db);
    profileId = await repo.createProfile(
        ProfilesCompanion.insert(name: 'Owner', isAdmin: const Value(true)));
  });

  tearDown(() => db.close());

  Future<int> addBill(String name, int dueDay,
          {bool autopay = false, int cents = 9400}) =>
      repo.upsertBill(BillsCompanion.insert(
        profileId: profileId,
        name: name,
        amountCents: cents,
        dueDay: dueDay,
        autopay: Value(autopay),
      ));

  test('a bill due within three days is reminded', () async {
    await addBill('Phone plan', 18); // 3 days out

    final reminders =
        await repo.upcomingReminders(profileId: profileId, now: today);

    expect(reminders.length, 1);
    expect(reminders.single.title, 'Phone plan');
    expect(reminders.single.kind, ReminderKind.bill);
    expect(reminders.single.daysUntil(today), 3);
  });

  test('a bill further out is not reminded yet', () async {
    await addBill('Later', 25);

    expect(await repo.upcomingReminders(profileId: profileId, now: today),
        isEmpty);
  });

  test('autopay bills are skipped — nothing for you to do', () async {
    await addBill('Music streaming', 17, autopay: true);

    expect(await repo.upcomingReminders(profileId: profileId, now: today),
        isEmpty);
  });

  test('a bill already paid is not reminded', () async {
    final id = await addBill('Phone plan', 18);
    await repo.setBillPaid(
        profileId: profileId,
        billId: id,
        month: DateTime(2026, 8),
        paid: true);

    expect(await repo.upcomingReminders(profileId: profileId, now: today),
        isEmpty);
  });

  test('a card payment coming due is reminded, with its balance', () async {
    await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: 'Visa',
        creditLimitCents: 500000,
        balanceCents: const Value(120000),
        paymentDueDay: const Value(17)));

    final reminders =
        await repo.upcomingReminders(profileId: profileId, now: today);

    expect(reminders.single.kind, ReminderKind.cardPayment);
    expect(reminders.single.amountCents, 120000);
  });

  test('a card with no balance is not reminded', () async {
    await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: 'Unused',
        creditLimitCents: 500000,
        paymentDueDay: const Value(17)));

    expect(await repo.upcomingReminders(profileId: profileId, now: today),
        isEmpty);
  });

  test('reminders are sorted soonest first', () async {
    await addBill('Later', 18);
    await addBill('Sooner', 16);

    final reminders =
        await repo.upcomingReminders(profileId: profileId, now: today);

    expect(reminders.map((r) => r.title).toList(), ['Sooner', 'Later']);
  });

  test('reminders never cross profiles', () async {
    final other =
        await repo.createProfile(ProfilesCompanion.insert(name: 'Mom'));
    await addBill('Mine', 17);

    expect(await repo.upcomingReminders(profileId: other, now: today),
        isEmpty);
  });

  test('dedupe keys are stable per reminder per day', () {
    final a = Reminder(
        kind: ReminderKind.bill,
        title: 'X',
        amountCents: 100,
        date: DateTime(2026, 8, 18),
        sourceId: 1);
    final b = Reminder(
        kind: ReminderKind.bill,
        title: 'X',
        amountCents: 100,
        date: DateTime(2026, 8, 18),
        sourceId: 1);
    expect(a.dedupeKey, b.dedupeKey);
  });

  group('annual fee reminders', () {
    Future<int> addCardWithFee(DateTime feeDate,
            {int feeCents = 32500}) =>
        repo.upsertCard(CreditCardsCompanion.insert(
          profileId: profileId,
          name: 'Gold',
          creditLimitCents: 900000,
          annualFeeCents: Value(feeCents),
          annualFeeDate: Value(feeDate),
        ));

    test('appears 14 days ahead, not 3 like other reminders', () async {
      await addCardWithFee(DateTime(2026, 8, 25)); // 10 days out

      final reminders =
          await repo.upcomingReminders(profileId: profileId, now: today);

      expect(reminders.single.kind, ReminderKind.annualFee);
      expect(reminders.single.amountCents, 32500);
      expect(reminders.single.daysUntil(today), 10);
    });

    test('is not shown more than 14 days out', () async {
      await addCardWithFee(DateTime(2026, 9, 20));

      expect(await repo.upcomingReminders(profileId: profileId, now: today),
          isEmpty);
    });

    test('a past fee date rolls forward to next year', () {
      final card = CreditCard(
        id: 1,
        profileId: 1,
        name: 'Gold',
        balanceCents: 0,
        creditLimitCents: 900000,
        apr: 0,
        annualFeeCents: 32500,
        monthlyFeeCents: 0,
        annualFeeDate: DateTime(2024, 3, 10),
      );

      expect(HomebaseRepository.nextAnnualFeeDate(card, now: today),
          DateTime(2027, 3, 10),
          reason: 'March has already passed in 2026, so the fee is next year');
    });

    test('a fee date later this year stays this year', () {
      final card = CreditCard(
        id: 1,
        profileId: 1,
        name: 'Gold',
        balanceCents: 0,
        creditLimitCents: 900000,
        apr: 0,
        annualFeeCents: 32500,
        monthlyFeeCents: 0,
        annualFeeDate: DateTime(2020, 11, 4),
      );

      expect(HomebaseRepository.nextAnnualFeeDate(card, now: today),
          DateTime(2026, 11, 4));
    });

    test('a card with no fee amount is not reminded', () async {
      await addCardWithFee(DateTime(2026, 8, 20), feeCents: 0);

      expect(await repo.upcomingReminders(profileId: profileId, now: today),
          isEmpty);
    });

    test('a card with no fee date is not reminded', () async {
      await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: 'No fee date',
        creditLimitCents: 900000,
        annualFeeCents: const Value(32500),
      ));

      expect(await repo.upcomingReminders(profileId: profileId, now: today),
          isEmpty);
    });

    test('a fee and a payment on the same card both appear', () async {
      await repo.upsertCard(CreditCardsCompanion.insert(
        profileId: profileId,
        name: 'Gold',
        creditLimitCents: 900000,
        balanceCents: const Value(50000),
        paymentDueDay: const Value(17),
        annualFeeCents: const Value(32500),
        annualFeeDate: Value(DateTime(2026, 8, 22)),
      ));

      final reminders =
          await repo.upcomingReminders(profileId: profileId, now: today);

      expect(reminders.map((r) => r.kind).toSet(),
          {ReminderKind.cardPayment, ReminderKind.annualFee});
      expect(reminders.first.kind, ReminderKind.cardPayment,
          reason: 'sorted soonest first');
    });
  });
}
