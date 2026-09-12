import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clearly/data/database.dart';
import 'package:clearly/data/repository.dart';

void main() {
  late AppDatabase db;
  late HomebaseRepository repo;
  late int profileId;
  late int checkingId;
  late int savingsId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = HomebaseRepository(db);
    profileId = await repo.createProfile(
        ProfilesCompanion.insert(name: 'Owner', isAdmin: const Value(true)));
    checkingId = await repo.upsertAccount(AccountsCompanion.insert(
      profileId: profileId,
      name: 'Checking',
      type: AccountType.checking,
      balanceCents: const Value(500000),
    ));
    savingsId = await repo.upsertAccount(AccountsCompanion.insert(
      profileId: profileId,
      name: 'Savings',
      type: AccountType.savings,
      balanceCents: const Value(100000),
    ));
  });

  tearDown(() => db.close());

  test('a manual transfer moves money between the two accounts immediately',
      () async {
    await repo.postManualTransfer(
      profileId: profileId,
      fromAccountId: checkingId,
      toAccountId: savingsId,
      amountCents: 20000,
      date: DateTime(2026, 8, 15),
      name: 'Rent deposit refund',
    );

    final checking = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == checkingId);
    final savings = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == savingsId);
    expect(checking.balanceCents, 480000);
    expect(savings.balanceCents, 120000);
  });

  test('a manual transfer never recurs on its own', () async {
    await repo.postManualTransfer(
      profileId: profileId,
      fromAccountId: checkingId,
      toAccountId: savingsId,
      amountCents: 20000,
      date: DateTime(2026, 8, 15),
      name: 'One-off',
    );

    // Materializing due transfers for a much later date must not move the
    // money again — the manual transfer was created already inactive.
    await repo.materializeDueTransfers(
        profileId: profileId, now: DateTime(2026, 10, 1));

    final checking = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == checkingId);
    expect(checking.balanceCents, 480000,
        reason: 'a manual transfer runs once, never again');
  });

  test('a manual transfer appears in each account\'s history', () async {
    await repo.postManualTransfer(
      profileId: profileId,
      fromAccountId: checkingId,
      toAccountId: savingsId,
      amountCents: 20000,
      date: DateTime(2026, 8, 15),
      name: 'One-off',
    );

    final checkingActivity = await repo
        .watchAccountHistory(profileId: profileId, accountId: checkingId)
        .first;
    final savingsActivity = await repo
        .watchAccountHistory(profileId: profileId, accountId: savingsId)
        .first;
    expect(checkingActivity.single.amountCents, -20000);
    expect(savingsActivity.single.amountCents, 20000);
  });

  test('a manual transfer appears in the shared transfer history', () async {
    await repo.postManualTransfer(
      profileId: profileId,
      fromAccountId: checkingId,
      toAccountId: savingsId,
      amountCents: 20000,
      date: DateTime(2026, 8, 15),
      name: 'One-off',
    );

    final history =
        await repo.watchTransferHistory(profileId: profileId).first;
    expect(history, hasLength(1));
    expect(history.single.amountCents, 20000);
  });
}
