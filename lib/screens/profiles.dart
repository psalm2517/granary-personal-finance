import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../main.dart';
import '../util/pin.dart';
import '../widgets/backup_actions.dart';
import '../widgets/common.dart';

/// Admin-only: add, rename, re-PIN, or remove profiles. Non-admins never
/// reach this screen — it isn't in their navigation at all.
class ProfilesScreen extends ConsumerStatefulWidget {
  const ProfilesScreen({super.key});

  @override
  ConsumerState<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends ConsumerState<ProfilesScreen> {
  late Future<List<Profile>> _profiles;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _profiles = ref.read(repositoryProvider).allProfiles();
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = ref.watch(loggedInProfileProvider)!;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(null),
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Add profile'),
      ),
      body: FutureBuilder<List<Profile>>(
        future: _profiles,
        builder: (context, snap) {
          final profiles = snap.data ?? [];
          return ListView(
            padding: kPagePadding,
            children: [
              const SectionHeader('Household profiles',
                  icon: Icons.group_outlined,
                  info: InfoButton(
                    title: 'Profiles and access',
                    body: [
                      'Every profile keeps its own accounts, cards, loans, '
                          'bills, budget and paychecks. Nothing is shared '
                          'between them.',
                      'An admin can switch into any profile using the '
                          'selector in the top bar. A non-admin only ever '
                          'sees their own data and has no switcher.',
                      'A PIN is optional. Without one, anyone who opens the '
                          'app can select that profile. A PIN can be any '
                          'length and use letters, numbers or symbols.',
                      'Deleting a profile permanently deletes all of its '
                          'financial data. The last remaining admin cannot '
                          'be deleted.',
                    ],
                  )),
              Text(
                  'Each profile has its own cards, loans, bills, budget and '
                  'paychecks. Admins can view any profile; everyone else sees '
                  'only their own.',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              for (final p in profiles)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                        child: Text(p.name.characters.first.toUpperCase())),
                    title: Text(p.name),
                    subtitle: Text([
                      p.isAdmin ? 'Admin' : 'Member',
                      if (p.pinHash != null) 'PIN set' else 'No PIN',
                      if (p.id == loggedIn.id) 'signed in',
                    ].join(' • ')),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                          tooltip: 'Edit',
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => _edit(p)),
                      IconButton(
                          tooltip: 'Delete',
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed:
                              p.id == loggedIn.id ? null : () => _delete(p)),
                    ]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _delete(Profile p) async {
    // Deleting a profile destroys every card, loan, bill, budget entry,
    // paycheck and goal it owns, so offer a way out before it happens
    // rather than only mentioning that it cannot be undone.
    var backedUp = false;
    while (true) {
      if (!mounted) return;
      final choice = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(Icons.warning_amber_outlined,
              color: Theme.of(context).colorScheme.error),
          title: Text('Delete ${p.name}?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'This permanently removes the profile and all of its '
                  'accounts, cards, loans, bills, budget entries, paychecks '
                  'and goals. This cannot be undone.'),
              const SizedBox(height: 12),
              if (backedUp)
                Row(children: [
                  Icon(Icons.check_circle,
                      size: 16, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text('Backed up — safe to delete.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.primary)),
                  ),
                ])
              else
                Text(
                    'Saving a backup first means this data can be restored '
                    'later if you change your mind.',
                    style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, 'cancel'),
                child: const Text('Cancel')),
            if (!backedUp)
              TextButton.icon(
                  onPressed: () => Navigator.pop(context, 'backup'),
                  icon: const Icon(Icons.download_outlined, size: 18),
                  label: const Text('Back up first')),
            DangerButton(
                label: 'Delete everything',
                onPressed: () => Navigator.pop(context, 'delete')),
          ],
        ),
      );

      if (choice == null || choice == 'cancel') return;

      if (choice == 'backup') {
        if (!mounted) return;
        // Back up just this profile — it is the data about to be lost.
        backedUp = await runBackupFlow(
          context,
          ref,
          profileIds: [p.id],
          suggestedName:
              'clearly-backup-${p.name.toLowerCase().replaceAll(' ', '-')}'
              '-${DateTime.now().toIso8601String().split('T').first}.json',
        );
        continue; // Re-ask, now showing that a backup exists.
      }

      break;
    }

    try {
      await ref.read(repositoryProvider).deleteProfile(id: p.id);
    } on StateError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
    if (!mounted) return;
    setState(_reload);
  }


  Future<void> _edit(Profile? existing) async {
    final name = TextEditingController(text: existing?.name);
    final pin = TextEditingController();
    var isAdmin = existing?.isAdmin ?? false;
    var clearPin = false;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => SubmitOnEnter(
          onSubmit: () => Navigator.pop(context, true),
          child: AlertDialog(
          title: Text(existing == null ? 'Add profile' : 'Edit profile'),
          content: SizedBox(
            width: 380,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              DialogField(name, 'Name', autofocus: true),
              TextField(
                controller: pin,
                obscureText: true,
                enabled: !clearPin,
                onSubmitted: (_) => Navigator.pop(context, true),
                decoration: InputDecoration(
                  labelText: existing == null
                      ? 'PIN (optional)'
                      : 'New PIN (leave blank to keep current)',
                  helperText: 'Any length, letters, numbers or symbols',
                  border: const OutlineInputBorder(),
                ),
              ),
              if (existing?.pinHash != null)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Remove PIN'),
                  value: clearPin,
                  onChanged: (v) => setLocal(() => clearPin = v ?? false),
                ),
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Admin'),
                subtitle: const Text('Can view and switch into any profile'),
                value: isAdmin,
                onChanged: (v) => setLocal(() => isAdmin = v),
              ),
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Save')),
          ],
        ),
        ),
      ),
    );
    if (saved != true) return;
    if (name.text.trim().isEmpty) {
      if (mounted) warnNotSaved(context, 'the profile needs a name');
      return;
    }
    final repo = ref.read(repositoryProvider);
    if (existing == null) {
      await repo.createProfile(ProfilesCompanion.insert(
        name: name.text.trim(),
        isAdmin: Value(isAdmin),
        pinHash: Value(pin.text.isEmpty ? null : hashPin(pin.text)),
      ));
    } else {
      await repo.updateProfile(existing.copyWith(
        name: name.text.trim(),
        isAdmin: isAdmin,
        pinHash: Value(clearPin
            ? null
            : pin.text.isEmpty
                ? existing.pinHash
                : hashPin(pin.text)),
      ));
    }
    if (!mounted) return;
    setState(_reload);
  }
}
