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

  test('generates one paycheck per payday from the schedule', () async {
    await repo.upsertSchedule(PaycheckSchedulesCompanion.insert(
      profileId: profileId,
      name: 'Job',
      frequency: PayFrequency.biweekly,
      anchorDate: DateTime(2026, 9, 1),
      amountCents: 75000,
    ));

    await repo.generateDuePaychecks(
        profileId: profileId, until: DateTime(2026, 10, 1));

    final paychecks = await repo.watchPaychecks(profileId: profileId).first;
    expect(paychecks, hasLength(3)); // Sep 1, Sep 15, Sep 29
  });

  test('calling it twice does not double the paychecks', () async {
    await repo.upsertSchedule(PaycheckSchedulesCompanion.insert(
      profileId: profileId,
      name: 'Job',
      frequency: PayFrequency.biweekly,
      anchorDate: DateTime(2026, 9, 1),
      amountCents: 75000,
    ));

    await repo.generateDuePaychecks(
        profileId: profileId, until: DateTime(2026, 10, 1));
    await repo.generateDuePaychecks(
        profileId: profileId, until: DateTime(2026, 10, 1));

    final paychecks = await repo.watchPaychecks(profileId: profileId).first;
    expect(paychecks, hasLength(3));
  });

  test(
      'a stored date carrying a stray time-of-day is still recognized as '
      'the same day — regression for a duplicate-paycheck bug', () async {
    final scheduleId = await repo.upsertSchedule(
        PaycheckSchedulesCompanion.insert(
      profileId: profileId,
      name: 'Job',
      frequency: PayFrequency.biweekly,
      anchorDate: DateTime(2026, 9, 1),
      amountCents: 75000,
    ));
    // Simulates the real bug: an already-generated paycheck whose date
    // drifted an hour off midnight (the DST-arithmetic bug, now fixed
    // elsewhere) — generateDuePaychecks must still recognize this as
    // "Sep 15 already exists" rather than creating a second Sep 15 (or
    // Sep 16) paycheck next to it.
    await repo.upsertPaycheck(PaychecksCompanion.insert(
      profileId: profileId,
      name: 'Job',
      date: DateTime(2026, 9, 15, 23),
      amountCents: 75000,
      scheduleId: Value(scheduleId),
    ));

    await repo.generateDuePaychecks(
        profileId: profileId, until: DateTime(2026, 10, 1));

    final paychecks = await repo.watchPaychecks(profileId: profileId).first;
    final onSep15 =
        paychecks.where((p) => p.date.day == 15 && p.date.month == 9);
    expect(onSep15, hasLength(1),
        reason: 'the drifted row should count as that day\'s occurrence, '
            'not get a duplicate generated alongside it');
  });
}
