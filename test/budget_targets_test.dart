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

  Future<void> setTarget(String category, int cents) =>
      repo.upsertBudgetTarget(BudgetTargetsCompanion.insert(
          profileId: profileId,
          category: category,
          monthlyTargetCents: cents));

  test('changing an existing target updates it in place', () async {
    await setTarget('Save', 50000);
    await setTarget('Save', 70000);

    final targets = await repo.watchBudgetTargets(profileId: profileId).first;
    expect(targets.length, 1, reason: 'updated, not duplicated');
    expect(targets.single.monthlyTargetCents, 70000);
  });

  test('targets for different categories coexist', () async {
    await setTarget('Save', 50000);
    await setTarget('Groceries', 40000);

    final targets = await repo.watchBudgetTargets(profileId: profileId).first;
    expect(targets.length, 2);
    expect(targets.map((t) => t.monthlyTargetCents).toList()..sort(),
        [40000, 50000]);
  });

  test('the same category in another profile is independent', () async {
    final other =
        await repo.createProfile(ProfilesCompanion.insert(name: 'Mom'));
    await setTarget('Save', 50000);
    await repo.upsertBudgetTarget(BudgetTargetsCompanion.insert(
        profileId: other, category: 'Save', monthlyTargetCents: 20000));

    expect(
        (await repo.watchBudgetTargets(profileId: profileId).first)
            .single
            .monthlyTargetCents,
        50000);
    expect(
        (await repo.watchBudgetTargets(profileId: other).first)
            .single
            .monthlyTargetCents,
        20000);
  });

  test('a target can be removed', () async {
    await setTarget('Save', 50000);
    final target =
        (await repo.watchBudgetTargets(profileId: profileId).first).single;

    await repo.deleteBudgetTarget(profileId: profileId, id: target.id);

    expect(await repo.watchBudgetTargets(profileId: profileId).first, isEmpty);
  });
}
