import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'catppuccin.dart';

/// Selected Catppuccin accent, persisted on the device.
///
/// Kept separate from the flavor (light/dark) choice: the accent is which
/// named colour drives buttons and highlights, and applies the same way
/// across all four flavors. Lives in shared_preferences alongside the
/// flavor choice for the same reason — it is a preference belonging to
/// this computer, not financial data.
class AccentController extends StateNotifier<CatppuccinAccent> {
  AccentController() : super(CatppuccinAccent.mauve) {
    _load();
  }

  static const _key = 'catppuccin_accent';

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = CatppuccinAccentInfo.fromStorage(prefs.getString(_key));
    } catch (_) {
      // Unreadable preferences should never stop the app starting; the
      // default accent already applies.
    }
  }

  Future<void> select(CatppuccinAccent accent) async {
    state = accent;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, accent.storageKey);
    } catch (_) {
      // The choice still applies for this session even if it cannot be
      // written; better than refusing to change accent.
    }
  }
}

final accentProvider =
    StateNotifierProvider<AccentController, CatppuccinAccent>(
        (ref) => AccentController());
