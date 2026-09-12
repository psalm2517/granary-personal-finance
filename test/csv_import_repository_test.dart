import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clearly/data/csv_import.dart';
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

  List<ParsedImportRow> sampleRows() => [
        (date: DateTime(2026, 8, 10), description: 'Coffee Shop', amountCents: -450),
        (date: DateTime(2026, 8, 11), description: 'Paycheck', amountCents: 185000),
      ];

  group('previewImport', () {
    test('flags a row matching an existing entry\'s date and amount as a '
        'likely duplicate', () async {
      await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: DateTime(2026, 8, 10),
        amountCents: 450,
        type: EntryType.expense,
        accountId: Value(accountId),
      ));

      final preview = await repo.previewImport(
          profileId: profileId, accountId: accountId, rows: sampleRows());

      expect(preview[0].isDuplicate, isTrue,
          reason: 'same date and amount as the existing coffee expense');
      expect(preview[1].isDuplicate, isFalse);
    });

    test('a row for a different account is not flagged', () async {
      final other = await repo.upsertAccount(AccountsCompanion.insert(
          profileId: profileId, name: 'Savings', type: AccountType.savings));
      await repo.addBudgetEntry(BudgetEntriesCompanion.insert(
        profileId: profileId,
        date: DateTime(2026, 8, 10),
        amountCents: 450,
        type: EntryType.expense,
        accountId: Value(other),
      ));

      final preview = await repo.previewImport(
          profileId: profileId, accountId: accountId, rows: sampleRows());

      expect(preview[0].isDuplicate, isFalse);
    });
  });

  group('commitImport', () {
    test('creates entries linked to the account, tagged with one batch',
        () async {
      final batchId = await repo.commitImport(
          profileId: profileId,
          accountId: accountId,
          sourceFilename: 'chase.csv',
          rows: sampleRows(),
          updateAccountBalance: false);

      final entries = await repo
          .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 8))
          .first;
      expect(entries, hasLength(2));
      expect(entries.every((e) => e.accountId == accountId), isTrue);
      expect(entries.every((e) => e.importBatchId == batchId), isTrue);
    });

    test('does not touch the account balance unless asked', () async {
      await repo.commitImport(
          profileId: profileId,
          accountId: accountId,
          sourceFilename: 'chase.csv',
          rows: sampleRows(),
          updateAccountBalance: false);

      final account = (await repo.watchAccounts(profileId: profileId).first)
          .firstWhere((a) => a.id == accountId);
      expect(account.balanceCents, 100000);
    });

    test('applies the net amount once when asked to update the balance',
        () async {
      await repo.commitImport(
          profileId: profileId,
          accountId: accountId,
          sourceFilename: 'chase.csv',
          rows: sampleRows(),
          updateAccountBalance: true);

      final account = (await repo.watchAccounts(profileId: profileId).first)
          .firstWhere((a) => a.id == accountId);
      // -450 + 185000 = 184550 net.
      expect(account.balanceCents, 100000 + 184550);
    });

    test('auto-categorizes rows using existing rules', () async {
      await repo.upsertRule(CategoryRulesCompanion.insert(
        profileId: profileId,
        field: RuleField.description,
        pattern: 'Coffee',
        category: 'Dining',
        priority: const Value(0),
      ));

      await repo.commitImport(
          profileId: profileId,
          accountId: accountId,
          sourceFilename: 'chase.csv',
          rows: sampleRows(),
          updateAccountBalance: false);

      final entries = await repo
          .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 8))
          .first;
      final coffee = entries.firstWhere((e) => e.description == 'Coffee Shop');
      expect(coffee.category, 'Dining');
    });
  });

  group('undoImportBatch', () {
    test('removes the batch\'s entries', () async {
      final batchId = await repo.commitImport(
          profileId: profileId,
          accountId: accountId,
          sourceFilename: 'chase.csv',
          rows: sampleRows(),
          updateAccountBalance: false);

      await repo.undoImportBatch(profileId: profileId, batchId: batchId);

      final entries = await repo
          .watchBudgetForMonth(profileId: profileId, month: DateTime(2026, 8))
          .first;
      expect(entries, isEmpty);
    });

    test('reverses the balance adjustment it made', () async {
      final batchId = await repo.commitImport(
          profileId: profileId,
          accountId: accountId,
          sourceFilename: 'chase.csv',
          rows: sampleRows(),
          updateAccountBalance: true);

      await repo.undoImportBatch(profileId: profileId, batchId: batchId);

      final account = (await repo.watchAccounts(profileId: profileId).first)
          .firstWhere((a) => a.id == accountId);
      expect(account.balanceCents, 100000);
    });

    test('an undone batch no longer appears in the import history', () async {
      final batchId = await repo.commitImport(
          profileId: profileId,
          accountId: accountId,
          sourceFilename: 'chase.csv',
          rows: sampleRows(),
          updateAccountBalance: false);

      await repo.undoImportBatch(profileId: profileId, batchId: batchId);

      final batches = await repo.watchImportBatches(profileId: profileId).first;
      expect(batches, isEmpty);
    });
  });

  group('deleteAccount', () {
    test('clears the import batch\'s account link but keeps its history',
        () async {
      final batchId = await repo.commitImport(
          profileId: profileId,
          accountId: accountId,
          sourceFilename: 'chase.csv',
          rows: sampleRows(),
          updateAccountBalance: false);

      await repo.deleteAccount(profileId: profileId, id: accountId);

      final batches = await repo.watchImportBatches(profileId: profileId).first;
      expect(batches, hasLength(1));
      expect(batches.single.id, batchId);
      expect(batches.single.accountId, isNull);
    });
  });

  group('exportEntriesAsCsv', () {
    test('includes a header row and one row per entry', () async {
      await repo.commitImport(
          profileId: profileId,
          accountId: accountId,
          sourceFilename: 'chase.csv',
          rows: sampleRows(),
          updateAccountBalance: false);

      final csv = await repo.exportEntriesAsCsv(profileId: profileId);
      final lines = csv.trim().split('\n');
      expect(lines, hasLength(3), reason: 'header + 2 entries');
      expect(lines[0], contains('Date'));
      expect(csv, contains('Coffee Shop'));
      expect(csv, contains('Checking'));
    });
  });
}
