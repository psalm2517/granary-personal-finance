import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'data/notifications.dart';
import 'data/repository.dart';
import 'screens/profile_picker.dart';
import 'screens/shell.dart';
import 'theme/accent_provider.dart';
import 'theme/catppuccin.dart';
import 'theme/flavor_provider.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final repositoryProvider = Provider<HomebaseRepository>(
    (ref) => HomebaseRepository(ref.watch(databaseProvider)));

/// Who authenticated at the profile picker. Determines admin powers.
final loggedInProfileProvider = StateProvider<Profile?>((ref) => null);

/// Whose data is on screen. Same as logged-in for non-admins; admins can
/// switch it. Reset on login change.
final activeProfileProvider = StateProvider<Profile?>((ref) {
  return ref.watch(loggedInProfileProvider);
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const ProviderScope(child: ClearlyApp()));
}

class ClearlyApp extends ConsumerWidget {
  const ClearlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flavor = ref.watch(flavorProvider);
    final accent = ref.watch(accentProvider);
    return MaterialApp(
      title: 'Clearly',
      // One theme, built from the chosen flavor and accent — the platform's
      // own light/dark setting does not override an explicit choice.
      theme: themeFor(flavor, accent),
      home: const _Root(),
    );
  }
}

class _Root extends ConsumerWidget {
  const _Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(loggedInProfileProvider);
    if (profile == null) return const ProfilePickerScreen();
    return const AppShell();
  }
}
