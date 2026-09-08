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

  test('marking a paycheck received creates a matching income entry',
      () async {
    final id = await repo.upsertPaycheck(PaychecksCompanion.insert(
        profileId: profileId,
        name: 'Day job',
        date: DateTime(2026, 8, 15),
        amountCents: 185000));

    await repo.upsertPaycheck(PaychecksCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: const Value('Day job'),
      date: Value(DateTime(2026, 8, 15)),
      amountCents: const Value(185000),
      received: const Value(true),
    ));

    final entries = await repo
        .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 8))
        .first;
    expect(entries.length, 1);
    expect(entries.single.type, EntryType.income);
    expect(entries.single.amountCents, 185000);
    expect(entries.single.sourcePaycheckId, id);
  });

  test('a bonus is included in the linked entry amount', () async {
    final id = await repo.upsertPaycheck(PaychecksCompanion.insert(
        profileId: profileId,
        name: 'Day job',
        date: DateTime(2026, 8, 15),
        amountCents: 185000));

    await repo.upsertPaycheck(PaychecksCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: const Value('Day job'),
      date: Value(DateTime(2026, 8, 15)),
      amountCents: const Value(185000),
      bonusCents: const Value(50000),
      received: const Value(true),
    ));

    final entries = await repo
        .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 8))
        .first;
    expect(entries.single.amountCents, 235000);
  });

  test('un-marking received removes the linked entry', () async {
    final id = await repo.upsertPaycheck(PaychecksCompanion.insert(
        profileId: profileId,
        name: 'Day job',
        date: DateTime(2026, 8, 15),
        amountCents: 185000));
    await repo.upsertPaycheck(PaychecksCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: const Value('Day job'),
      date: Value(DateTime(2026, 8, 15)),
      amountCents: const Value(185000),
      received: const Value(true),
    ));

    await repo.upsertPaycheck(PaychecksCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: const Value('Day job'),
      date: Value(DateTime(2026, 8, 15)),
      amountCents: const Value(185000),
      received: const Value(false),
    ));

    final entries = await repo
        .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 8))
        .first;
    expect(entries, isEmpty);
  });

  test('re-saving a received paycheck updates the entry instead of '
      'duplicating it', () async {
    final id = await repo.upsertPaycheck(PaychecksCompanion.insert(
        profileId: profileId,
        name: 'Day job',
        date: DateTime(2026, 8, 15),
        amountCents: 185000));
    await repo.upsertPaycheck(PaychecksCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: const Value('Day job'),
      date: Value(DateTime(2026, 8, 15)),
      amountCents: const Value(185000),
      received: const Value(true),
    ));
    // Bonus added after the fact, still received.
    await repo.upsertPaycheck(PaychecksCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: const Value('Day job'),
      date: Value(DateTime(2026, 8, 15)),
      amountCents: const Value(185000),
      bonusCents: const Value(10000),
      received: const Value(true),
    ));

    final entries = await repo
        .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 8))
        .first;
    expect(entries.length, 1, reason: 'same entry updated, not duplicated');
    expect(entries.single.amountCents, 195000);
  });

  test('deleting a paycheck removes its linked entry', () async {
    final id = await repo.upsertPaycheck(PaychecksCompanion.insert(
        profileId: profileId,
        name: 'Day job',
        date: DateTime(2026, 8, 15),
        amountCents: 185000));
    await repo.upsertPaycheck(PaychecksCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: const Value('Day job'),
      date: Value(DateTime(2026, 8, 15)),
      amountCents: const Value(185000),
      received: const Value(true),
    ));

    await repo.deletePaycheck(profileId: profileId, id: id);

    final entries = await repo
        .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 8))
        .first;
    expect(entries, isEmpty);
  });

  test('schedule-generated paychecks start unreceived with no entry',
      () async {
    await repo.upsertSchedule(PaycheckSchedulesCompanion.insert(
        profileId: profileId,
        name: 'Day job',
        frequency: PayFrequency.biweekly,
        anchorDate: DateTime(2026, 8, 7),
        amountCents: 185000));
    await repo.generateDuePaychecks(
        profileId: profileId, until: DateTime(2026, 8, 31));

    final entries = await repo
        .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 8))
        .first;
    expect(entries, isEmpty,
        reason: 'generated checks are not received yet, so no entry exists');
  });

  group('automatic receiving', () {
    test('a paycheck whose payday has passed marks itself received',
        () async {
      await repo.upsertPaycheck(PaychecksCompanion.insert(
          profileId: profileId,
          name: 'Work',
          date: DateTime.now().subtract(const Duration(days: 3)),
          amountCents: 77500));

      await repo.materializeReceivedPaychecks(profileId: profileId);

      final checks = await repo.watchPaychecks(profileId: profileId).first;
      expect(checks.single.received, isTrue);

      final now = DateTime.now();
      final entries = await repo
          .watchBudgetForMonth(
              profileId: profileId, month: DateTime(now.year, now.month))
          .first;
      expect(entries.length, 1);
      expect(entries.single.amountCents, 77500);
      expect(entries.single.type, EntryType.income);
    });

    test('a future paycheck is left alone', () async {
      await repo.upsertPaycheck(PaychecksCompanion.insert(
          profileId: profileId,
          name: 'Work',
          date: DateTime.now().add(const Duration(days: 10)),
          amountCents: 77500));

      await repo.materializeReceivedPaychecks(profileId: profileId);

      final checks = await repo.watchPaychecks(profileId: profileId).first;
      expect(checks.single.received, isFalse,
          reason: 'payday has not arrived');
    });

    test('a manual override is not undone by automatic processing',
        () async {
      final id = await repo.upsertPaycheck(PaychecksCompanion.insert(
          profileId: profileId,
          name: 'Work',
          date: DateTime.now().subtract(const Duration(days: 3)),
          amountCents: 77500));
      await repo.materializeReceivedPaychecks(profileId: profileId);

      // The check never actually arrived — say so by hand.
      await repo.upsertPaycheck(PaychecksCompanion(
        id: Value(id),
        profileId: Value(profileId),
        name: const Value('Work'),
        date: Value(DateTime.now().subtract(const Duration(days: 3))),
        amountCents: const Value(77500),
        received: const Value(false),
        receivedIsManual: const Value(true),
      ));

      await repo.materializeReceivedPaychecks(profileId: profileId);

      final checks = await repo.watchPaychecks(profileId: profileId).first;
      expect(checks.single.received, isFalse,
          reason: 'the override must survive the next app launch');
      final now = DateTime.now();
      final entries = await repo
          .watchBudgetForMonth(
              profileId: profileId, month: DateTime(now.year, now.month))
          .first;
      expect(entries, isEmpty);
    });

    test('is idempotent across repeated launches', () async {
      await repo.upsertPaycheck(PaychecksCompanion.insert(
          profileId: profileId,
          name: 'Work',
          date: DateTime.now().subtract(const Duration(days: 3)),
          amountCents: 77500));

      await repo.materializeReceivedPaychecks(profileId: profileId);
      await repo.materializeReceivedPaychecks(profileId: profileId);
      await repo.materializeReceivedPaychecks(profileId: profileId);

      final now = DateTime.now();
      final entries = await repo
          .watchBudgetForMonth(
              profileId: profileId, month: DateTime(now.year, now.month))
          .first;
      expect(entries.length, 1, reason: 'no duplicate income rows');
    });
  });

  group('deleting a paycheck', () {
    test('a scheduled paycheck stays deleted after regeneration runs',
        () async {
      await repo.upsertSchedule(PaycheckSchedulesCompanion.insert(
          profileId: profileId,
          name: 'Work',
          frequency: PayFrequency.biweekly,
          anchorDate: DateTime(2026, 8, 7),
          amountCents: 77500));
      await repo.generateDuePaychecks(
          profileId: profileId, until: DateTime(2026, 9, 30));

      final before = await repo.watchPaychecks(profileId: profileId).first;
      expect(before.length, greaterThan(1));
      final victim = before.first;

      await repo.deletePaycheck(profileId: profileId, id: victim.id);

      // The catch-up that runs on every launch must not resurrect it.
      await repo.generateDuePaychecks(
          profileId: profileId, until: DateTime(2026, 9, 30));

      final after = await repo.watchPaychecks(profileId: profileId).first;
      expect(after.map((p) => p.id), isNot(contains(victim.id)),
          reason: 'deleted paychecks must not come back on the next launch');
      expect(after.length, before.length - 1);
    });

    test('deleting removes the income entry it created', () async {
      final id = await repo.upsertPaycheck(PaychecksCompanion.insert(
          profileId: profileId,
          name: 'Work',
          date: DateTime.now().subtract(const Duration(days: 2)),
          amountCents: 77500));
      await repo.materializeReceivedPaychecks(profileId: profileId);
      final now = DateTime.now();
      expect(
          (await repo
                  .watchBudgetForMonth(
                      profileId: profileId,
                      month: DateTime(now.year, now.month))
                  .first)
              .length,
          1);

      await repo.deletePaycheck(profileId: profileId, id: id);

      expect(
          await repo
              .watchBudgetForMonth(
                  profileId: profileId, month: DateTime(now.year, now.month))
              .first,
          isEmpty);
    });

    test('a dismissed paycheck is not auto-received later', () async {
      await repo.upsertSchedule(PaycheckSchedulesCompanion.insert(
          profileId: profileId,
          name: 'Work',
          frequency: PayFrequency.monthly,
          anchorDate: DateTime.now().subtract(const Duration(days: 5)),
          amountCents: 77500));
      await repo.generateDuePaychecks(
          profileId: profileId, until: DateTime.now());
      final generated = await repo.watchPaychecks(profileId: profileId).first;
      await repo.deletePaycheck(
          profileId: profileId, id: generated.first.id);

      await repo.materializeReceivedPaychecks(profileId: profileId);

      expect(await repo.watchPaychecks(profileId: profileId).first, isEmpty);
      final now = DateTime.now();
      expect(
          await repo
              .watchBudgetForMonth(
                  profileId: profileId, month: DateTime(now.year, now.month))
              .first,
          isEmpty,
          reason: 'a deleted paycheck must not create income');
    });
  });

  test('paychecks are generated 90 days ahead', () async {
    final anchor = DateTime.now();
    await repo.upsertSchedule(PaycheckSchedulesCompanion.insert(
        profileId: profileId,
        name: 'Work',
        frequency: PayFrequency.biweekly,
        anchorDate: DateTime(anchor.year, anchor.month, anchor.day),
        amountCents: 77500));

    await repo.generateDuePaychecks(
        profileId: profileId,
        until: DateTime.now().add(HomebaseRepository.paycheckHorizon));

    final checks = await repo.watchPaychecks(profileId: profileId).first;
    // 90 days of bi-weekly pay is 7 checks (day 0 through day 84).
    expect(checks.length, 7);
    final furthest =
        checks.map((c) => c.date).reduce((a, b) => a.isAfter(b) ? a : b);
    expect(furthest.difference(DateTime.now()).inDays, greaterThan(75),
        reason: 'the horizon should reach roughly a quarter out');
  });

  group('expected income for a month', () {
    test('counts paychecks that have not been received yet', () async {
      // Two future paychecks totalling $2000 for next month.
      final next = DateTime(DateTime.now().year, DateTime.now().month + 1);
      await repo.upsertPaycheck(PaychecksCompanion.insert(
          profileId: profileId,
          name: 'Work',
          date: DateTime(next.year, next.month, 7),
          amountCents: 100000));
      await repo.upsertPaycheck(PaychecksCompanion.insert(
          profileId: profileId,
          name: 'Work',
          date: DateTime(next.year, next.month, 21),
          amountCents: 100000));

      final expected = await repo
          .watchExpectedIncomeForMonth(profileId: profileId, month: next)
          .first;
      expect(expected, 200000,
          reason: 'you can budget the full month before payday arrives');
    });

    test('includes bonuses and ignores other months', () async {
      final august = DateTime(2026, 8);
      await repo.upsertPaycheck(PaychecksCompanion.insert(
          profileId: profileId,
          name: 'Work',
          date: DateTime(2026, 8, 14),
          amountCents: 77500,
          bonusCents: const Value(22500)));
      await repo.upsertPaycheck(PaychecksCompanion.insert(
          profileId: profileId,
          name: 'Work',
          date: DateTime(2026, 9, 11),
          amountCents: 77500));

      expect(
          await repo
              .watchExpectedIncomeForMonth(
                  profileId: profileId, month: august)
              .first,
          100000);
    });

    test('a three-payday month counts all three', () async {
      await repo.upsertSchedule(PaycheckSchedulesCompanion.insert(
          profileId: profileId,
          name: 'Work',
          frequency: PayFrequency.biweekly,
          anchorDate: DateTime(2026, 5, 1),
          amountCents: 100000));
      await repo.generateDuePaychecks(
          profileId: profileId, until: DateTime(2026, 6, 30));

      // May 1, 15 and 29 all fall in May.
      expect(
          await repo
              .watchExpectedIncomeForMonth(
                  profileId: profileId, month: DateTime(2026, 5))
              .first,
          300000,
          reason: 'an averaged figure would have understated this month');
    });

    test('a deleted paycheck stops counting', () async {
      final id = await repo.upsertPaycheck(PaychecksCompanion.insert(
          profileId: profileId,
          name: 'Work',
          date: DateTime(2026, 8, 14),
          amountCents: 77500));
      await repo.deletePaycheck(profileId: profileId, id: id);

      expect(
          await repo
              .watchExpectedIncomeForMonth(
                  profileId: profileId, month: DateTime(2026, 8))
              .first,
          0);
    });
  });
}
