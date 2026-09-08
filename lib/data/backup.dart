import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';

import 'database.dart';

/// What a backup file contains, read without applying it — so a restore can
/// be confirmed before anything is destroyed.
class BackupSummary {
  const BackupSummary({
    required this.exportedAt,
    required this.schemaVersion,
    required this.profileNames,
    required this.profileIds,
    required this.rowCounts,
  });

  final DateTime exportedAt;
  final int schemaVersion;
  final List<String> profileNames;
  final List<int> profileIds;

  /// Table name to row count, for showing what is about to come back.
  final Map<String, int> rowCounts;

  int get totalRows =>
      rowCounts.values.fold(0, (sum, count) => sum + count);
}

class BackupException implements Exception {
  BackupException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Exports and restores Granary data as JSON.
///
/// JSON rather than a copy of the SQLite file for three reasons: it can be
/// scoped to one profile (the file cannot, since tables are not partitioned
/// by profile), it stays readable if you ever need to check or fix a value
/// by hand, and it carries its schema version so an older backup can still
/// be understood after the schema moves on.
class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  /// Bumped only if the file layout itself changes, independently of the
  /// database schema version.
  static const formatVersion = 1;

  /// Tables in dependency order: parents before children. Restoring walks
  /// this forwards and deletes walk it backwards, so foreign keys hold at
  /// every step.
  ///
  /// [where] builds the SQL condition that scopes a table's rows to a set
  /// of profile ids, given the comma-joined id list — almost always
  /// `profile_id IN (ids)`, `id IN (ids)` for the profiles table itself,
  /// and a subquery through `budget_entries` for `budgetEntryTags` and
  /// `transactionSplits`, neither of which has a profile_id column of its
  /// own at all.
  List<({String name, TableInfo table, String Function(String ids) where})>
      get _tables {
    String byProfileId(String ids) => 'profile_id IN ($ids)';
    return [
      (name: 'profiles', table: _db.profiles, where: (ids) => 'id IN ($ids)'),
      (name: 'accounts', table: _db.accounts, where: byProfileId),
      (
        name: 'accountBalanceSnapshots',
        table: _db.accountBalanceSnapshots,
        where: byProfileId,
      ),
      (name: 'creditCards', table: _db.creditCards, where: byProfileId),
      (name: 'loans', table: _db.loans, where: byProfileId),
      (name: 'bills', table: _db.bills, where: byProfileId),
      (name: 'billPayments', table: _db.billPayments, where: byProfileId),
      (
        name: 'paycheckSchedules',
        table: _db.paycheckSchedules,
        where: byProfileId,
      ),
      (name: 'paychecks', table: _db.paychecks, where: byProfileId),
      (
        name: 'paycheckAllocations',
        table: _db.paycheckAllocations,
        where: byProfileId,
      ),
      (name: 'budgetEntries', table: _db.budgetEntries, where: byProfileId),
      (
        name: 'transactionSplits',
        table: _db.transactionSplits,
        where: (ids) => 'entry_id IN '
            '(SELECT id FROM budget_entries WHERE profile_id IN ($ids))',
      ),
      (name: 'tags', table: _db.tags, where: byProfileId),
      (
        name: 'budgetEntryTags',
        table: _db.budgetEntryTags,
        where: (ids) => 'entry_id IN '
            '(SELECT id FROM budget_entries WHERE profile_id IN ($ids))',
      ),
      (name: 'budgetTargets', table: _db.budgetTargets, where: byProfileId),
      (name: 'categoryRules', table: _db.categoryRules, where: byProfileId),
      (
        name: 'creditScoreSnapshots',
        table: _db.creditScoreSnapshots,
        where: byProfileId,
      ),
      (name: 'payments', table: _db.payments, where: byProfileId),
      (
        name: 'netWorthSnapshots',
        table: _db.netWorthSnapshots,
        where: byProfileId,
      ),
      (name: 'goals', table: _db.goals, where: byProfileId),
      (
        name: 'recurringTransfers',
        table: _db.recurringTransfers,
        where: byProfileId,
      ),
      (name: 'transferLogs', table: _db.transferLogs, where: byProfileId),
    ];
  }

  /// Serializes every row visible to [profileIds]. Passing a single id is
  /// what a non-admin export does; an admin backing up the household passes
  /// every profile.
  Future<String> exportJson({required List<int> profileIds}) async {
    final data = <String, dynamic>{};

    for (final entry in _tables) {
      final rows = await _db
          .customSelect(
            'SELECT * FROM ${entry.table.actualTableName} '
            'WHERE ${entry.where(profileIds.join(','))}',
            readsFrom: {entry.table},
          )
          .get();
      data[entry.name] = [for (final row in rows) row.data];
    }

    final profileRows = (data['profiles'] as List).cast<Map<String, Object?>>();

    return const JsonEncoder.withIndent('  ').convert({
      'granary': {
        'formatVersion': formatVersion,
        'schemaVersion': _db.schemaVersion,
        'exportedAt': DateTime.now().toIso8601String(),
        'profiles': [
          for (final p in profileRows)
            {'id': p['id'], 'name': p['name']},
        ],
      },
      'data': data,
    });
  }

  /// Reads a backup without applying it.
  BackupSummary inspect(String json) {
    late final Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      throw BackupException('That file is not valid JSON.');
    }

    // Older backups (written before the Granary rename) carry the header
    // under the old key — still readable, so renaming the app doesn't
    // strand anyone's existing backup file.
    final header = decoded['granary'] ?? decoded['homebase'];
    final data = decoded['data'];
    if (header is! Map || data is! Map) {
      throw BackupException(
          'That does not look like a Granary backup file.');
    }
    final format = header['formatVersion'];
    if (format is! int || format > formatVersion) {
      throw BackupException(
          'This backup was written by a newer version of Granary '
          '(format $format). Update Granary and try again.');
    }

    final profiles = (header['profiles'] as List? ?? [])
        .cast<Map<String, dynamic>>();
    if (profiles.isEmpty) {
      throw BackupException('That backup contains no profiles.');
    }

    return BackupSummary(
      exportedAt:
          DateTime.tryParse(header['exportedAt'] as String? ?? '') ??
              DateTime.now(),
      schemaVersion: header['schemaVersion'] as int? ?? 0,
      profileNames: [for (final p in profiles) p['name'] as String],
      profileIds: [for (final p in profiles) p['id'] as int],
      rowCounts: {
        for (final entry in data.entries)
          entry.key.toString(): (entry.value as List).length,
      },
    );
  }

  /// Replaces the data for every profile in the backup, then inserts the
  /// backup's rows. Anything belonging to those profiles that is not in the
  /// backup is gone — that is what replace means, and the caller is expected
  /// to have said so and taken a safety copy first.
  ///
  /// [allowedProfileIds] guards the visibility rule: a non-admin restoring a
  /// file that happens to contain other profiles must not resurrect them.
  Future<void> restore(
    String json, {
    List<int>? allowedProfileIds,
  }) async {
    final summary = inspect(json);
    if (summary.schemaVersion > _db.schemaVersion) {
      throw BackupException(
          'This backup came from a newer database (v${summary.schemaVersion}) '
          'than this copy of Granary understands (v${_db.schemaVersion}).');
    }

    final decoded = jsonDecode(json) as Map<String, dynamic>;
    final data = (decoded['data'] as Map).cast<String, dynamic>();

    final targetIds = allowedProfileIds == null
        ? summary.profileIds
        : summary.profileIds
            .where(allowedProfileIds.contains)
            .toList();
    if (targetIds.isEmpty) {
      throw BackupException(
          'That backup does not contain data for this profile.');
    }

    final ids = targetIds.join(',');

    await _db.transaction(() async {
      // Clear children before parents.
      for (final entry in _tables.reversed) {
        await _db.customStatement(
          'DELETE FROM ${entry.table.actualTableName} '
          'WHERE ${entry.where(ids)}',
        );
      }

      // budgetEntryTags and transactionSplits rows carry no profile id of
      // their own — a row only belongs to a target profile if the entry it
      // references does. Built once, right after budgetEntries rows are
      // inserted below (it comes first in table order), then consulted when
      // their turn comes.
      final allowedEntryIds = <Object?>{};

      // Then insert parents before children.
      for (final entry in _tables) {
        final rows =
            (data[entry.name] as List? ?? []).cast<Map<String, dynamic>>();
        // Only write columns this version of the table actually has. A
        // backup from an older schema can carry columns since renamed or
        // dropped (statement_day became statement_close_day), and inserting
        // those verbatim would fail — losing the whole restore over a
        // column that no longer matters.
        final known = {for (final c in entry.table.$columns) c.name};
        for (final row in rows) {
          final idColumn = entry.name == 'profiles' ? 'id' : 'profile_id';
          final belongs = entry.name == 'budgetEntryTags' ||
                  entry.name == 'transactionSplits'
              ? allowedEntryIds.contains(row['entry_id'])
              : targetIds.contains(row[idColumn]);
          if (!belongs) continue;
          if (entry.name == 'budgetEntries') allowedEntryIds.add(row['id']);
          final columns = row.keys.where(known.contains).toList();
          final placeholders = List.filled(columns.length, '?').join(', ');
          await _db.customInsert(
            'INSERT INTO ${entry.table.actualTableName} '
            '(${columns.join(', ')}) VALUES ($placeholders)',
            variables: [
              for (final c in columns) Variable(row[c]),
            ],
          );
        }
      }
    });
  }

  /// Copies the live database file next to itself before a restore, so a
  /// mistaken restore is recoverable. Returns the copy's path, or null if
  /// the database is in memory (tests).
  Future<String?> writeSafetyCopy() async {
    final path = await _db.databasePath;
    if (path == null) return null;
    final source = File(path);
    if (!source.existsSync()) return null;
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final target = '$path.before-restore-$stamp.bak';
    await source.copy(target);
    return target;
  }
}
