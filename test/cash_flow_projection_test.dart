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

  DateTime daysFromNow(int d) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + d);
  }

  test('starts from the real cash balance across checking, savings and cash',
      () async {
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(100000)));
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Savings',
        type: AccountType.savings,
        balanceCents: const Value(50000)));
    // Investment is not "cash" and must not be counted.
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Brokerage',
        type: AccountType.investment,
        balanceCents: const Value(999999)));

    final points = await repo.projectCashFlow(profileId: profileId, days: 5);

    expect(points.first.balanceCents, 150000);
  });

  test('a scheduled paycheck adds on its date', () async {
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(0)));
    final scheduleId = await repo.upsertSchedule(
        PaycheckSchedulesCompanion.insert(
      profileId: profileId,
      name: 'Job',
      frequency: PayFrequency.weekly,
      anchorDate: daysFromNow(3),
      amountCents: 200000,
    ));
    await repo.upsertPaycheck(PaychecksCompanion.insert(
      profileId: profileId,
      name: 'Job',
      date: daysFromNow(3),
      amountCents: 200000,
      scheduleId: Value(scheduleId),
    ));

    final points = await repo.projectCashFlow(profileId: profileId, days: 10);

    expect(points[2].balanceCents, 0, reason: 'before the payday');
    expect(points[3].balanceCents, 200000, reason: 'on the payday');
    expect(points[4].balanceCents, 200000, reason: 'stays after');
  });

  test('a bonus on a paycheck is included', () async {
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(0)));
    await repo.upsertPaycheck(PaychecksCompanion.insert(
      profileId: profileId,
      name: 'Job',
      date: daysFromNow(2),
      amountCents: 200000,
      bonusCents: const Value(50000),
    ));

    final points = await repo.projectCashFlow(profileId: profileId, days: 5);

    expect(points[2].balanceCents, 250000);
  });

  test('a monthly bill subtracts on its due day, every month in range',
      () async {
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(500000)));
    final now = DateTime.now();
    await repo.upsertBill(BillsCompanion.insert(
      profileId: profileId,
      name: 'Rent',
      amountCents: 145000,
      dueDay: now.day, // due "today" so it lands inside a short test window
    ));

    final points = await repo.projectCashFlow(profileId: profileId, days: 1);

    expect(points.first.balanceCents, 355000,
        reason: 'the bill due today already counts against today\'s point');
  });

  test('a quarterly bill only lands in the months it actually falls in',
      () async {
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(500000)));
    final farOffMonth = DateTime.now().month + 6 > 12
        ? DateTime.now().month - 6
        : DateTime.now().month + 6;
    await repo.upsertBill(BillsCompanion.insert(
      profileId: profileId,
      name: 'Insurance',
      amountCents: 60000,
      dueDay: 1,
      frequency: const Value(BillFrequency.quarterly),
      dueMonth: Value(farOffMonth),
    ));

    // A short window that cannot contain a quarterly recurrence of a bill
    // anchored 6 months away.
    final points = await repo.projectCashFlow(profileId: profileId, days: 20);

    expect(points.last.balanceCents, 500000,
        reason: 'the quarterly bill should not fire in an unrelated month');
  });

  test('a dismissed paycheck is excluded', () async {
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(0)));
    await repo.upsertPaycheck(PaychecksCompanion.insert(
      profileId: profileId,
      name: 'Job',
      date: daysFromNow(2),
      amountCents: 200000,
      dismissed: const Value(true),
    ));

    final points = await repo.projectCashFlow(profileId: profileId, days: 5);

    expect(points.last.balanceCents, 0);
  });

  test('projection is per profile', () async {
    final other =
        await repo.createProfile(ProfilesCompanion.insert(name: 'Mom'));
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: other,
        name: 'Her checking',
        type: AccountType.checking,
        balanceCents: const Value(999999)));

    final points = await repo.projectCashFlow(profileId: profileId, days: 5);

    expect(points.first.balanceCents, 0);
  });

  group('DST safety', () {
    // Regression for a real bug: adding a fixed Duration to a local
    // midnight DateTime drifts off midnight across a DST transition
    // (US clocks "fall back" the first Sunday of November), which broke
    // the day-by-day lookup this projection depends on — a scheduled
    // paycheck landed in the deltas map at exact midnight, but the point
    // generated for that same day had drifted to 11pm the day before and
    // never found it, so the paycheck silently vanished from the total.

    test('every generated day lands on exact local midnight, spanning a '
        'DST change', () async {
      await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId,
          name: 'Checking',
          type: AccountType.checking,
          balanceCents: const Value(0)));

      // Anchored well before the US fall-back transition, running well
      // past it.
      final points = await repo.projectCashFlow(
          profileId: profileId, days: 90, now: DateTime(2026, 9, 1));

      for (final p in points) {
        expect(p.date.hour, 0,
            reason: '${p.date} drifted off midnight — a DST bug');
      }
      expect(points.last.date, DateTime(2026, 11, 30));
    });

    test('a paycheck scheduled after a DST transition still counts',
        () async {
      await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId,
          name: 'Checking',
          type: AccountType.checking,
          balanceCents: const Value(0)));
      // Lands after the November DST change relative to a September "now".
      await repo.upsertPaycheck(PaychecksCompanion.insert(
        profileId: profileId,
        name: 'Job',
        date: DateTime(2026, 11, 4),
        amountCents: 75000,
      ));

      final points = await repo.projectCashFlow(
          profileId: profileId, days: 90, now: DateTime(2026, 9, 1));

      expect(points.last.balanceCents, 75000,
          reason: 'the paycheck must not silently disappear across DST');
    });

    test('biweekly paycheck dates stay on exact midnight across a DST '
        'change', () async {
      final schedule = PaycheckSchedule(
        id: 1,
        profileId: profileId,
        name: 'Job',
        frequency: PayFrequency.biweekly,
        anchorDate: DateTime(2026, 9, 1),
        amountCents: 75000,
        active: true,
      );

      final dates =
          HomebaseRepository.paydatesFor(schedule, DateTime(2026, 12, 31));

      for (final d in dates) {
        expect(d.hour, 0, reason: '$d drifted off midnight — a DST bug');
      }
    });
  });
}
