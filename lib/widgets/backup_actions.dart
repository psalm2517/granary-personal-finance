import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/backup.dart';
import '../main.dart';

/// Writes a backup to a file the user picks. Shared by the Settings screen
/// and by the "back up first" option offered before a destructive delete.
/// Returns true only if a file was actually written.
Future<bool> runBackupFlow(
  BuildContext context,
  WidgetRef ref, {
  required List<int> profileIds,
  String? suggestedName,
}) async {
  final service = BackupService(ref.read(databaseProvider));
  final stamp = DateTime.now().toIso8601String().split('T').first;

  final location = await getSaveLocation(
    suggestedName: suggestedName ?? 'clearly-backup-$stamp.json',
    acceptedTypeGroups: const [
      XTypeGroup(label: 'Clearly backup', extensions: ['json']),
    ],
  );
  if (location == null) return false;

  try {
    final json = await service.exportJson(profileIds: profileIds);
    await File(location.path).writeAsString(json);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backed up to ${location.path}')));
    }
    return true;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Backup failed: $e'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
    return false;
  }
}
