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

  Future<int> logScore(int score, DateTime date, {double util = 0.28}) =>
      repo.addScoreSnapshot(CreditScoreSnapshotsCompanion.insert(
        profileId: profileId,
        date: date,
        score: score,
        utilization: util,
      ));

  test('a logged score appears in history', () async {
    await logScore(720, DateTime(2026, 8, 1));

    final history = await repo.watchScoreHistory(profileId: profileId).first;
    expect(history.single.score, 720);
    expect(history.single.utilization, 0.28);
  });

  test('history comes back oldest first, so the chart reads left to right',
      () async {
    await logScore(700, DateTime(2026, 6, 1));
    await logScore(740, DateTime(2026, 8, 1));
    await logScore(720, DateTime(2026, 7, 1));

    final history = await repo.watchScoreHistory(profileId: profileId).first;
    expect(history.map((s) => s.score).toList(), [700, 720, 740]);
  });

  test('a mistyped score can be deleted', () async {
    final id = await logScore(999, DateTime(2026, 8, 1));
    await logScore(720, DateTime(2026, 8, 2));

    await repo.deleteScoreSnapshot(profileId: profileId, id: id);

    final history = await repo.watchScoreHistory(profileId: profileId).first;
    expect(history.single.score, 720);
  });

  test('scores are per profile', () async {
    final other =
        await repo.createProfile(ProfilesCompanion.insert(name: 'Mom'));
    await logScore(720, DateTime(2026, 8, 1));

    expect((await repo.watchScoreHistory(profileId: profileId).first).length,
        1);
    expect(await repo.watchScoreHistory(profileId: other).first, isEmpty);
  });

  test('suggested utilization matches what the cards report', () async {
    await repo.upsertCard(CreditCardsCompanion.insert(
      profileId: profileId,
      name: 'Visa',
      creditLimitCents: 100000,
      balanceCents: const Value(40000),
    ));

    final suggested = await repo.currentUtilization(profileId: profileId);

    expect(suggested, 0.40,
        reason: 'prefill matches the dashboard\'s utilization figure');
  });

  test('suggested utilization is zero with no cards', () async {
    expect(await repo.currentUtilization(profileId: profileId), 0);
  });

  test('deleting a profile removes its score history', () async {
    final other = await repo.createProfile(
        ProfilesCompanion.insert(name: 'Mom', isAdmin: const Value(false)));
    await repo.addScoreSnapshot(CreditScoreSnapshotsCompanion.insert(
        profileId: other,
        date: DateTime(2026, 8, 1),
        score: 700,
        utilization: 0.1));

    await repo.deleteProfile(id: other);

    expect(await repo.watchScoreHistory(profileId: other).first, isEmpty);
  });
}
