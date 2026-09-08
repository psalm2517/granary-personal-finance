import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:granary/data/database.dart';
import 'package:granary/data/repository.dart';

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

  test('changing a balance today does NOT add a second point', () async {
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: pid,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(100000)));
    await repo.upsertAccount(AccountsCompanion.insert(
        profileId: pid,
        name: 'Savings',
        type: AccountType.savings,
        balanceCents: const Value(500000)));
    await repo.recordNetWorthSnapshot(profileId: pid);

    final history = await repo.watchNetWorthHistory(profileId: pid).first;
    expect(history.length, 1,
        reason: 'one row per day, so today stays a single point no matter '
            'how many balances change');
    expect(history.single.netWorthCents, 600000,
        reason: 'but it does hold the latest figure');
  });

  test('a chart-worthy series builds across days', () async {
    // Simulate three days of history the way the app would accumulate it.
    final days = [
      (DateTime(2026, 8, 13), 500000, 100000),
      (DateTime(2026, 8, 14), 520000, 90000),
      (DateTime(2026, 8, 15), 540000, 80000),
    ];
    for (final (date, assets, debt) in days) {
      await db.into(db.netWorthSnapshots).insert(
          NetWorthSnapshotsCompanion.insert(
              profileId: pid,
              date: date,
              totalAssetsCents: assets,
              totalDebtCents: debt,
              netWorthCents: assets - debt));
    }

    final history = await repo.watchNetWorthHistory(profileId: pid).first;
    expect(history.length, 3);
    expect(history.map((s) => s.netWorthCents).toList(),
        [400000, 430000, 460000],
        reason: 'oldest first, so the chart reads left to right');
  });

  test('history older than the window is excluded', () async {
    await db.into(db.netWorthSnapshots).insert(
        NetWorthSnapshotsCompanion.insert(
            profileId: pid,
            date: DateTime.now().subtract(const Duration(days: 400)),
            totalAssetsCents: 1,
            totalDebtCents: 0,
            netWorthCents: 1));
    await repo.recordNetWorthSnapshot(profileId: pid);

    final history =
        await repo.watchNetWorthHistory(profileId: pid, days: 180).first;
    expect(history.length, 1, reason: 'the 400-day-old point is outside it');
  });

  test('negative net worth is recorded, not clamped', () async {
    await repo.upsertLoan(LoansCompanion.insert(
        profileId: pid,
        name: 'Car',
        balanceCents: 800000,
        originalAmountCents: 1500000));

    final history = await repo.watchNetWorthHistory(profileId: pid).first;
    expect(history.single.netWorthCents, -800000);
  });
}
