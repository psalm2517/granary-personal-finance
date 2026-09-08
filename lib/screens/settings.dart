import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/backup.dart';
import '../widgets/backup_actions.dart';
import '../data/database.dart';
import '../main.dart';
import '../theme/accent_provider.dart';
import '../theme/catppuccin.dart';
import '../theme/flavor_provider.dart';
import '../widgets/common.dart';

final backupServiceProvider = Provider<BackupService>(
    (ref) => BackupService(ref.watch(databaseProvider)));

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final loggedIn = ref.watch(loggedInProfileProvider)!;
    final flavor = ref.watch(flavorProvider);
    final accent = ref.watch(accentProvider);
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: kPagePadding,
      children: [
        SectionHeader('Appearance',
            icon: Icons.palette_outlined,
            info: const InfoButton(
              title: 'Catppuccin flavors',
              body: [
                'Granary uses the Catppuccin palette, which comes in four '
                    'flavors: Latte is the light one, and Frappé, Macchiato '
                    'and Mocha get progressively darker and higher contrast.',
                'Colours come from the official Catppuccin package rather '
                    'than being copied into this app, so they stay correct '
                    'if the palette is ever revised.',
                'Your choice is remembered on this computer. It is not part '
                    'of your financial data, so restoring a backup will not '
                    'change it.',
              ],
            )),
        Card(
          child: RadioGroup<CatppuccinFlavor>(
            groupValue: flavor,
            onChanged: (chosen) {
              if (chosen != null) {
                ref.read(flavorProvider.notifier).select(chosen);
              }
            },
            child: Column(
            children: [
              for (final f in CatppuccinFlavor.values)
                RadioListTile<CatppuccinFlavor>(
                  value: f,
                  title: Row(
                    children: [
                      Text(f.label),
                      const SizedBox(width: 10),
                      // Swatch preview: a few of this flavor's accents, so
                      // the difference is visible before committing to it.
                      for (final color in f.swatch)
                        Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: f.palette.surface1, width: 0.5),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Text(f.description),
                  secondary: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      // The flavor's own page and card colours, so the
                      // chip previews the actual background too.
                      color: f.isDark ? f.palette.base : f.palette.mantle,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: f.palette.surface1),
                    ),
                    child: Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: f.isDark
                              ? f.palette.surface0
                              : f.palette.base,
                          borderRadius: BorderRadius.circular(4),
                          border:
                              Border.all(color: f.palette.overlay0, width: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            title: const Text('Accent color'),
            subtitle: Text(
                'Applies to buttons, selection and highlights in every '
                'flavor.'),
            trailing: DropdownButton<CatppuccinAccent>(
              value: accent,
              underline: const SizedBox.shrink(),
              onChanged: (chosen) {
                if (chosen != null) {
                  ref.read(accentProvider.notifier).select(chosen);
                }
              },
              items: [
                for (final a in CatppuccinAccent.values)
                  DropdownMenuItem(
                    value: a,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: a.of(flavor.palette),
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: flavor.palette.surface1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(a.label),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        kSectionGap,
        SectionHeader('Backup',
            icon: Icons.save_outlined,
            info: InfoButton(
              title: 'How backups work',
              body: [
                'Granary keeps everything on this computer — there is no '
                    'cloud and nothing is uploaded. A backup writes a file '
                    'wherever you choose, and looking after that file is up '
                    'to you: another drive, or a folder you sync yourself.',
                'The file is JSON, so it is readable and can be checked or '
                    'repaired by hand if it ever comes to that. It records '
                    'the schema version it came from, so an older backup can '
                    'still be understood after Granary changes.',
                loggedIn.isAdmin
                    ? 'As an admin, your backup covers every profile in the '
                        'household.'
                    : 'Your backup covers your own data only.',
                'Restoring replaces what is there. Granary copies the '
                    'current database next to itself first, so a mistaken '
                    'restore can still be undone by hand.',
              ],
            )),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.download_outlined),
                title: const Text('Back up to a file'),
                subtitle: Text(loggedIn.isAdmin
                    ? 'Every profile, saved where you choose'
                    : 'Your data, saved where you choose'),
                trailing: FilledButton.tonal(
                  onPressed: _busy ? null : _backup,
                  child: const Text('Back up'),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Icons.restore, color: scheme.error),
                title: const Text('Restore from a file'),
                subtitle: const Text(
                    'Replaces current data with the contents of a backup'),
                trailing: OutlinedButton(
                  onPressed: _busy ? null : _restore,
                  child: const Text('Restore'),
                ),
              ),
            ],
          ),
        ),
        if (_busy)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }

  List<int> _visibleProfileIds(Profile loggedIn, List<Profile> all) =>
      loggedIn.isAdmin ? [for (final p in all) p.id] : [loggedIn.id];

  Future<void> _backup() async {
    final repo = ref.read(repositoryProvider);
    final loggedIn = ref.read(loggedInProfileProvider)!;
    final ids = _visibleProfileIds(loggedIn, await repo.allProfiles());
    if (!mounted) return;

    setState(() => _busy = true);
    try {
      await runBackupFlow(context, ref, profileIds: ids);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final service = ref.read(backupServiceProvider);
    final repo = ref.read(repositoryProvider);
    final loggedIn = ref.read(loggedInProfileProvider)!;

    final file = await openFile(acceptedTypeGroups: const [
      XTypeGroup(label: 'Granary backup', extensions: ['json']),
    ]);
    if (file == null) return;

    late final String json;
    late final BackupSummary summary;
    try {
      json = await file.readAsString();
      summary = service.inspect(json);
    } on BackupException catch (e) {
      if (!mounted) return;
      _say(e.message, error: true);
      return;
    } catch (e) {
      if (!mounted) return;
      _say('That file could not be read: $e', error: true);
      return;
    }

    final allowed = _visibleProfileIds(loggedIn, await repo.allProfiles());
    final restoring =
        summary.profileIds.where(allowed.contains).toList();
    final skipped = summary.profileNames.length - restoring.length;

    if (!mounted) return;
    if (restoring.isEmpty) {
      _say('That backup has nothing for your profile.', error: true);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.warning_amber_outlined,
            color: Theme.of(context).colorScheme.error),
        title: const Text('Restore and replace?'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Backup from '
                  '${summary.exportedAt.toLocal().toString().split('.').first}'),
              const SizedBox(height: 8),
              Text('Profiles: ${summary.profileNames.join(', ')}'),
              Text('${summary.totalRows} rows across '
                  '${summary.rowCounts.length} tables'),
              if (skipped > 0) ...[
                const SizedBox(height: 8),
                Text(
                    '$skipped profile${skipped == 1 ? '' : 's'} in this file '
                    'will be skipped — you can only restore your own data.',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 12),
              Text(
                'This replaces the current data for '
                '${restoring.length == 1 ? 'that profile' : 'those profiles'}. '
                'Anything added since the backup will be lost. The current '
                'database is copied next to itself first, so this can still '
                'be undone by hand.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Replace my data'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      final copy = await service.writeSafetyCopy();
      await service.restore(json, allowedProfileIds: allowed);
      if (!mounted) return;
      // The signed-in profile row was just replaced, so send the user back
      // to the picker rather than leaving a stale profile in memory.
      ref.read(loggedInProfileProvider.notifier).state = null;
      ref.invalidate(activeProfileProvider);
      _say(copy == null
          ? 'Restored. Sign in again to see your data.'
          : 'Restored. Previous database saved to $copy');
    } on BackupException catch (e) {
      if (mounted) _say(e.message, error: true);
    } catch (e) {
      if (mounted) _say('Restore failed: $e', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _say(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor:
          error ? Theme.of(context).colorScheme.error : null,
      duration: Duration(seconds: error ? 6 : 5),
    ));
  }
}
