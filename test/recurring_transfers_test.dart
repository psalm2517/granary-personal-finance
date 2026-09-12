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

  Future<int> addTransfer({
    DateTime? anchor,
    PayFrequency frequency = PayFrequency.monthly,
  }) =>
      repo.upsertRecurringTransfer(RecurringTransfersCompanion.insert(
        profileId: profileId,
        name: 'To savings',
        fromAccountId: checkingId,
        toAccountId: savingsId,
        amountCents: 20000,
        frequency: frequency,
        anchorDate: anchor ?? DateTime(2026, 8, 1),
      ));

  test('a due transfer moves money between the two accounts', () async {
    await addTransfer(anchor: DateTime(2026, 8, 1));

    await repo.materializeDueTransfers(
        profileId: profileId, now: DateTime(2026, 8, 1));

    final checking = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == checkingId);
    final savings = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == savingsId);
    expect(checking.balanceCents, 480000);
    expect(savings.balanceCents, 120000);
  });

  test('a future-dated transfer does not run yet', () async {
    await addTransfer(anchor: DateTime(2026, 9, 1));

    await repo.materializeDueTransfers(
        profileId: profileId, now: DateTime(2026, 8, 1));

    final checking = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == checkingId);
    expect(checking.balanceCents, 500000,
        reason: 'the transfer is not due until September');
  });

  test('running materialize twice does not double-move money', () async {
    await addTransfer(anchor: DateTime(2026, 8, 1));

    await repo.materializeDueTransfers(
        profileId: profileId, now: DateTime(2026, 8, 1));
    await repo.materializeDueTransfers(
        profileId: profileId, now: DateTime(2026, 8, 1));

    final checking = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == checkingId);
    expect(checking.balanceCents, 480000,
        reason: 'the same date should only ever execute once');
  });

  test('multiple months of a monthly schedule all run when caught up late',
      () async {
    await addTransfer(anchor: DateTime(2026, 6, 1));

    // First check-in happens three months later — all three should run.
    await repo.materializeDueTransfers(
        profileId: profileId, now: DateTime(2026, 8, 15));

    final checking = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == checkingId);
    expect(checking.balanceCents, 500000 - 20000 * 3);
    final history = await repo.watchTransferHistory(profileId: profileId).first;
    expect(history, hasLength(3));
  });

  test('an inactive transfer never runs', () async {
    final id = await addTransfer(anchor: DateTime(2026, 8, 1));
    await repo.upsertRecurringTransfer(RecurringTransfersCompanion(
      id: Value(id),
      profileId: Value(profileId),
      name: const Value('To savings'),
      fromAccountId: Value(checkingId),
      toAccountId: Value(savingsId),
      amountCents: const Value(20000),
      frequency: const Value(PayFrequency.monthly),
      anchorDate: Value(DateTime(2026, 8, 1)),
      active: const Value(false),
    ));

    await repo.materializeDueTransfers(
        profileId: profileId, now: DateTime(2026, 8, 1));

    final checking = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == checkingId);
    expect(checking.balanceCents, 500000);
  });

  test('deleting the from-account removes the transfer entirely', () async {
    await addTransfer();
    await repo.deleteAccount(profileId: profileId, id: checkingId);

    expect(await repo.watchRecurringTransfers(profileId: profileId).first,
        isEmpty);
  });

  test('deleting the to-account removes the transfer entirely', () async {
    await addTransfer();
    await repo.deleteAccount(profileId: profileId, id: savingsId);

    expect(await repo.watchRecurringTransfers(profileId: profileId).first,
        isEmpty);
  });

  test('transfers are per profile', () async {
    final other =
        await repo.createProfile(ProfilesCompanion.insert(name: 'Mom'));
    await addTransfer();

    expect(await repo.watchRecurringTransfers(profileId: other).first,
        isEmpty);
  });
}
