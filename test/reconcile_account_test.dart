import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clearly/data/database.dart';
import 'package:clearly/data/repository.dart';

void main() {
  late AppDatabase db;
  late HomebaseRepository repo;
  late int profileId;
  late int accountId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = HomebaseRepository(db);
    profileId = await repo.createProfile(
        ProfilesCompanion.insert(name: 'Owner', isAdmin: const Value(true)));
    accountId = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId,
        name: 'Checking',
        type: AccountType.checking,
        balanceCents: const Value(100000)));
  });

  tearDown(() => db.close());

  test('a new account has never been reconciled', () async {
    final account = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == accountId);

    expect(account.reconciledBalanceCents, isNull);
    expect(account.reconciledAt, isNull);
  });

  test('reconciling records the statement balance and date', () async {
    await repo.reconcileAccount(
      profileId: profileId,
      accountId: accountId,
      statementBalanceCents: 100000,
      statementDate: DateTime(2026, 8, 31),
    );

    final account = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == accountId);
    expect(account.reconciledBalanceCents, 100000);
    expect(account.reconciledAt, DateTime(2026, 8, 31));
  });

  test('reconciling does not itself change the tracked balance', () async {
    await repo.reconcileAccount(
      profileId: profileId,
      accountId: accountId,
      statementBalanceCents: 55555,
      statementDate: DateTime(2026, 8, 31),
    );

    final account = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == accountId);
    expect(account.balanceCents, 100000,
        reason: 'reconciling records what the statement said, it does not '
            'overwrite the tracked balance');
  });

  test('a later reconciliation replaces the earlier one', () async {
    await repo.reconcileAccount(
      profileId: profileId,
      accountId: accountId,
      statementBalanceCents: 100000,
      statementDate: DateTime(2026, 7, 31),
    );
    await repo.reconcileAccount(
      profileId: profileId,
      accountId: accountId,
      statementBalanceCents: 120000,
      statementDate: DateTime(2026, 8, 31),
    );

    final account = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == accountId);
    expect(account.reconciledBalanceCents, 120000);
    expect(account.reconciledAt, DateTime(2026, 8, 31));
  });

  test('reconciling one account does not affect another', () async {
    final other = await repo.upsertAccount(AccountsCompanion.insert(
        profileId: profileId, name: 'Savings', type: AccountType.savings));

    await repo.reconcileAccount(
      profileId: profileId,
      accountId: accountId,
      statementBalanceCents: 100000,
      statementDate: DateTime(2026, 8, 31),
    );

    final savings = (await repo.watchAccounts(profileId: profileId).first)
        .firstWhere((a) => a.id == other);
    expect(savings.reconciledBalanceCents, isNull);
    expect(savings.reconciledAt, isNull);
  });
}
