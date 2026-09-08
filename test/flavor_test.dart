import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:granary/theme/catppuccin.dart';

void main() {
  test('all five flavors are available', () {
    expect(CatppuccinFlavor.values.map((f) => f.label).toList(),
        ['Latte', 'Frappé', 'Macchiato', 'Mocha', 'Obsidian']);
  });

  test('palettes come from the official package, not copied hex', () {
    expect(CatppuccinFlavor.mocha.palette, catppuccin.mocha);
    expect(CatppuccinFlavor.latte.palette, catppuccin.latte);
    expect(CatppuccinFlavor.frappe.palette, catppuccin.frappe);
    expect(CatppuccinFlavor.macchiato.palette, catppuccin.macchiato);
  });

  test('Obsidian keeps Mocha\'s accents but a true-black neutral ramp', () {
    final obsidian = CatppuccinFlavor.obsidian.palette;
    expect(obsidian.mauve, catppuccin.mocha.mauve,
        reason: 'accents match Mocha so the accent picker stays consistent');
    expect(obsidian.base, isNot(catppuccin.mocha.base),
        reason: 'the neutral ramp is the whole point of Obsidian');
  });

  test('only Latte is light', () {
    expect(CatppuccinFlavor.latte.isDark, isFalse);
    for (final f in [
      CatppuccinFlavor.frappe,
      CatppuccinFlavor.macchiato,
      CatppuccinFlavor.mocha,
      CatppuccinFlavor.obsidian,
    ]) {
      expect(f.isDark, isTrue, reason: '${f.label} is a dark flavor');
    }
  });

  test('every flavor builds a usable theme with matching brightness', () {
    for (final f in CatppuccinFlavor.values) {
      final theme = themeFor(f);
      expect(theme.colorScheme.brightness,
          f.isDark ? Brightness.dark : Brightness.light,
          reason: f.label);
      expect(theme.useMaterial3, isTrue);
      // Text must not be the same colour as the surface it sits on.
      expect(theme.colorScheme.onSurface,
          isNot(theme.colorScheme.surface),
          reason: '${f.label} would be unreadable');
    }
  });

  test('each flavor produces a distinct theme', () {
    final surfaces =
        CatppuccinFlavor.values.map((f) => themeFor(f).colorScheme.surface);
    expect(surfaces.toSet().length, 5,
        reason: 'picking a flavor should visibly change the app');
  });

  test('cards are a different colour from the page in every flavor', () {
    for (final f in CatppuccinFlavor.values) {
      final theme = themeFor(f);
      expect(theme.cardTheme.color, isNot(theme.scaffoldBackgroundColor),
          reason: '${f.label} cards must not sink into the page');
    }
  });

  test('swatches expose several distinct accents', () {
    for (final f in CatppuccinFlavor.values) {
      expect(f.swatch.length, greaterThanOrEqualTo(3));
      expect(f.swatch.toSet().length, f.swatch.length,
          reason: '${f.label} swatch should not repeat a colour');
    }
  });

  group('persistence keys', () {
    test('round-trip through storage', () {
      for (final f in CatppuccinFlavor.values) {
        expect(CatppuccinFlavorInfo.fromStorage(f.storageKey), f);
      }
    });

    test('unknown or missing values fall back to Mocha', () {
      expect(CatppuccinFlavorInfo.fromStorage(null), CatppuccinFlavor.mocha);
      expect(CatppuccinFlavorInfo.fromStorage('nonsense'),
          CatppuccinFlavor.mocha,
          reason: 'Mocha is the default for new installs');
    });
  });
}
