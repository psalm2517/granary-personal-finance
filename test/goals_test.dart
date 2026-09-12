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

  Future<int> addGoal({
    String name = 'Emergency fund',
    GoalType type = GoalType.savings,
    int target = 1000000,
    int current = 0,
    DateTime? targetDate,
  }) =>
      repo.upsertGoal(GoalsCompanion.insert(
        profileId: profileId,
        name: name,
        type: type,
        targetAmountCents: target,
        currentAmountCents: Value(current),
        targetDate: Value(targetDate),
      ));

  test('adding progress moves the goal forward', () async {
    final id = await addGoal(current: 100000);

    await repo.addGoalProgress(
        profileId: profileId, id: id, amountCents: 50000);

    final goal = (await repo.watchGoals(profileId: profileId).first).single;
    expect(goal.currentAmountCents, 150000);
  });

  test('a negative amount corrects a mistake', () async {
    final id = await addGoal(current: 100000);

    await repo.addGoalProgress(
        profileId: profileId, id: id, amountCents: -30000);

    final goal = (await repo.watchGoals(profileId: profileId).first).single;
    expect(goal.currentAmountCents, 70000);
  });

  test('progress never falls below zero', () async {
    final id = await addGoal(current: 10000);

    await repo.addGoalProgress(
        profileId: profileId, id: id, amountCents: -99999);

    final goal = (await repo.watchGoals(profileId: profileId).first).single;
    expect(goal.currentAmountCents, 0);
  });

  test('progress can exceed the target — overshooting is allowed', () async {
    final id = await addGoal(target: 100000, current: 90000);

    await repo.addGoalProgress(
        profileId: profileId, id: id, amountCents: 50000);

    final goal = (await repo.watchGoals(profileId: profileId).first).single;
    expect(goal.currentAmountCents, 140000);
  });

  test('editing a goal updates it rather than creating a second', () async {
    final id = await addGoal(name: 'Trip');

    await repo.upsertGoal(GoalsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: const Value('Big trip'),
      type: const Value(GoalType.savings),
      targetAmountCents: const Value(2000000),
      currentAmountCents: const Value(0),
    ));

    final goals = await repo.watchGoals(profileId: profileId).first;
    expect(goals.length, 1);
    expect(goals.single.name, 'Big trip');
    expect(goals.single.targetAmountCents, 2000000);
  });

  test('goals are per profile', () async {
    final other =
        await repo.createProfile(ProfilesCompanion.insert(name: 'Mom'));
    await addGoal();

    expect((await repo.watchGoals(profileId: profileId).first).length, 1);
    expect(await repo.watchGoals(profileId: other).first, isEmpty);
  });

  test('deleting a goal removes it', () async {
    final id = await addGoal();
    await repo.deleteGoal(profileId: profileId, id: id);
    expect(await repo.watchGoals(profileId: profileId).first, isEmpty);
  });

  test('deleting the linked account clears the link but keeps its balance '
      'as the manual progress', () async {
    final accountId = await repo.upsertAccount(AccountsCompanion.insert(
      profileId: profileId,
      name: 'Savings',
      type: AccountType.savings,
      balanceCents: const Value(420000),
    ));
    final goalId = await addGoal(current: 0);
    await repo.upsertGoal(GoalsCompanion(
      id: Value(goalId),
      profileId: Value(profileId),
      name: const Value('Emergency fund'),
      type: const Value(GoalType.savings),
      targetAmountCents: const Value(1000000),
      accountId: Value(accountId),
    ));

    await repo.deleteAccount(profileId: profileId, id: accountId);

    final goal = (await repo.watchGoals(profileId: profileId).first).single;
    expect(goal.accountId, isNull,
        reason: 'the account is gone, so the link cannot point anywhere');
    expect(goal.currentAmountCents, 420000,
        reason: "the account's last balance survives as a manual number");
  });

  group('monthly needed to land on time', () {
    Goal goalWith(
            {required int target,
            required int current,
            DateTime? date}) =>
        Goal(
          id: 1,
          profileId: 1,
          name: 'Fund',
          type: GoalType.savings,
          targetAmountCents: target,
          currentAmountCents: current,
          targetDate: date,
        );

    test('spreads the shortfall over the months remaining', () {
      final goal = goalWith(
          target: 600000, current: 0, date: DateTime(2027, 2, 1));
      // Aug 2026 to Feb 2027 is 6 months; $6,000 / 6 = $1,000.
      expect(
          HomebaseRepository.monthlyNeededFor(goal,
              now: DateTime(2026, 8, 15)),
          100000);
    });

    test('accounts for what is already put aside', () {
      final goal = goalWith(
          target: 600000, current: 300000, date: DateTime(2027, 2, 1));
      expect(
          HomebaseRepository.monthlyNeededFor(goal,
              now: DateTime(2026, 8, 15)),
          50000);
    });

    test('is null with no target date', () {
      final goal = goalWith(target: 600000, current: 0);
      expect(HomebaseRepository.monthlyNeededFor(goal), isNull);
    });

    test('is null once the goal is met', () {
      final goal = goalWith(
          target: 600000, current: 600000, date: DateTime(2027, 2, 1));
      expect(
          HomebaseRepository.monthlyNeededFor(goal,
              now: DateTime(2026, 8, 15)),
          isNull);
    });

    test('is null when the date has passed', () {
      final goal = goalWith(
          target: 600000, current: 0, date: DateTime(2026, 5, 1));
      expect(
          HomebaseRepository.monthlyNeededFor(goal,
              now: DateTime(2026, 8, 15)),
          isNull,
          reason: 'there is no monthly figure that makes a past date work');
    });

    test('rounds up so the goal is actually reached', () {
      final goal = goalWith(
          target: 100001, current: 0, date: DateTime(2026, 11, 1));
      // 3 months, $1000.01 -> must round up, not down.
      final monthly = HomebaseRepository.monthlyNeededFor(goal,
          now: DateTime(2026, 8, 15))!;
      expect(monthly * 3, greaterThanOrEqualTo(100001));
    });

    test('currentCents overrides the stored column, for account-linked '
        'goals', () {
      // The stored column says 0, but the linked account actually has
      // 300000 — the override should be what the math uses.
      final goal = goalWith(
          target: 600000, current: 0, date: DateTime(2027, 2, 1));
      expect(
          HomebaseRepository.monthlyNeededFor(goal,
              now: DateTime(2026, 8, 15), currentCents: 300000),
          50000);
    });
  });
}
