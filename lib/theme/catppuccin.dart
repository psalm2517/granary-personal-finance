import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';

/// A fixed rotation of colors for identifying categories at a glance
/// (account types, budget categories) — pull a stable index into [colors]
/// rather than the theme's primary/secondary/error, which change meaning
/// with the user's accent choice.
@immutable
class CategoryColors extends ThemeExtension<CategoryColors> {
  const CategoryColors(this.colors);

  final List<Color> colors;

  Color forIndex(int i) => colors[i.abs() % colors.length];

  @override
  CategoryColors copyWith({List<Color>? colors}) =>
      CategoryColors(colors ?? this.colors);

  @override
  CategoryColors lerp(ThemeExtension<CategoryColors>? other, double t) {
    if (other is! CategoryColors || other.colors.length != colors.length) {
      return this;
    }
    return CategoryColors([
      for (var i = 0; i < colors.length; i++)
        Color.lerp(colors[i], other.colors[i], t) ?? colors[i],
    ]);
  }
}

/// A fifth, non-official flavor: Mocha's accent hues (so the accent picker
/// and category colors stay identical) over a genuinely near-black neutral
/// ramp instead of Mocha's dark slate-navy — a starker true-black look
/// without inventing a new set of accent colors that would clash with the
/// rest of the app's Catppuccin-driven palette.
final Flavor _obsidian = (
  rosewater: catppuccin.mocha.rosewater,
  flamingo: catppuccin.mocha.flamingo,
  pink: catppuccin.mocha.pink,
  mauve: catppuccin.mocha.mauve,
  red: catppuccin.mocha.red,
  maroon: catppuccin.mocha.maroon,
  peach: catppuccin.mocha.peach,
  yellow: catppuccin.mocha.yellow,
  green: catppuccin.mocha.green,
  teal: catppuccin.mocha.teal,
  sky: catppuccin.mocha.sky,
  sapphire: catppuccin.mocha.sapphire,
  blue: catppuccin.mocha.blue,
  lavender: catppuccin.mocha.lavender,
  text: const Color(0xFFEDEDED),
  subtext1: const Color(0xFFB8B8B8),
  subtext0: const Color(0xFF9E9E9E),
  overlay2: const Color(0xFF6B6B6B),
  overlay1: const Color(0xFF525252),
  overlay0: const Color(0xFF3D3D3D),
  surface2: const Color(0xFF2A2A2A),
  surface1: const Color(0xFF1F1F1F),
  surface0: const Color(0xFF161616),
  crust: const Color(0xFF000000),
  mantle: const Color(0xFF0A0A0A),
  base: const Color(0xFF0D0D0D),
);

/// The five flavors, in the order the project lists them: lightest to
/// darkest, with Obsidian (not an official Catppuccin flavor) last.
enum CatppuccinFlavor { latte, frappe, macchiato, mocha, obsidian }

extension CatppuccinFlavorInfo on CatppuccinFlavor {
  /// Palette from the official package, so a palette update is a version
  /// bump rather than a hunt for hex codes. Obsidian is the one exception —
  /// see [_obsidian].
  Flavor get palette => switch (this) {
    CatppuccinFlavor.latte => catppuccin.latte,
    CatppuccinFlavor.frappe => catppuccin.frappe,
    CatppuccinFlavor.macchiato => catppuccin.macchiato,
    CatppuccinFlavor.mocha => catppuccin.mocha,
    CatppuccinFlavor.obsidian => _obsidian,
  };

  String get label => switch (this) {
    CatppuccinFlavor.latte => 'Latte',
    CatppuccinFlavor.frappe => 'Frappé',
    CatppuccinFlavor.macchiato => 'Macchiato',
    CatppuccinFlavor.mocha => 'Mocha',
    CatppuccinFlavor.obsidian => 'Obsidian',
  };

  String get description => switch (this) {
    CatppuccinFlavor.latte => 'Light',
    CatppuccinFlavor.frappe => 'Dark, warm and muted',
    CatppuccinFlavor.macchiato => 'Dark, medium contrast',
    CatppuccinFlavor.mocha => 'Dark, highest contrast',
    CatppuccinFlavor.obsidian => 'Dark, true black',
  };

  /// Latte is the only light flavor; the rest are dark. This decides text
  /// and icon contrast throughout Material.
  bool get isDark => this != CatppuccinFlavor.latte;

  /// A few accent colours for the swatch preview in Settings.
  List<Color> get swatch => [
    palette.mauve,
    palette.blue,
    palette.green,
    palette.peach,
    palette.red,
  ];

  /// Stable key for persistence — the enum name, so reordering the enum
  /// cannot silently change what a saved preference means.
  String get storageKey => name;

  static CatppuccinFlavor fromStorage(String? key) =>
      CatppuccinFlavor.values.firstWhere(
        (f) => f.name == key,
        orElse: () => CatppuccinFlavor.mocha, // default for new installs
      );
}

/// The named accent colours every Catppuccin flavor ships, in the order the
/// palette itself lists them. Mauve is the app's long-standing default.
enum CatppuccinAccent {
  rosewater,
  flamingo,
  pink,
  mauve,
  red,
  maroon,
  peach,
  yellow,
  green,
  teal,
  sky,
  sapphire,
  blue,
  lavender,
}

extension CatppuccinAccentInfo on CatppuccinAccent {
  /// This accent's colour within a given flavor's palette.
  Color of(Flavor palette) => switch (this) {
    CatppuccinAccent.rosewater => palette.rosewater,
    CatppuccinAccent.flamingo => palette.flamingo,
    CatppuccinAccent.pink => palette.pink,
    CatppuccinAccent.mauve => palette.mauve,
    CatppuccinAccent.red => palette.red,
    CatppuccinAccent.maroon => palette.maroon,
    CatppuccinAccent.peach => palette.peach,
    CatppuccinAccent.yellow => palette.yellow,
    CatppuccinAccent.green => palette.green,
    CatppuccinAccent.teal => palette.teal,
    CatppuccinAccent.sky => palette.sky,
    CatppuccinAccent.sapphire => palette.sapphire,
    CatppuccinAccent.blue => palette.blue,
    CatppuccinAccent.lavender => palette.lavender,
  };

  String get label => switch (this) {
    CatppuccinAccent.rosewater => 'Rosewater',
    CatppuccinAccent.flamingo => 'Flamingo',
    CatppuccinAccent.pink => 'Pink',
    CatppuccinAccent.mauve => 'Mauve',
    CatppuccinAccent.red => 'Red',
    CatppuccinAccent.maroon => 'Maroon',
    CatppuccinAccent.peach => 'Peach',
    CatppuccinAccent.yellow => 'Yellow',
    CatppuccinAccent.green => 'Green',
    CatppuccinAccent.teal => 'Teal',
    CatppuccinAccent.sky => 'Sky',
    CatppuccinAccent.sapphire => 'Sapphire',
    CatppuccinAccent.blue => 'Blue',
    CatppuccinAccent.lavender => 'Lavender',
  };

  /// Stable key for persistence — the enum name, so reordering the enum
  /// cannot silently change what a saved preference means.
  String get storageKey => name;

  static CatppuccinAccent fromStorage(String? key) =>
      CatppuccinAccent.values.firstWhere(
        (a) => a.name == key,
        orElse: () => CatppuccinAccent.mauve, // the app's original accent
      );
}

/// Builds the app theme for a flavor and accent. Every colour comes from the
/// palette, so screens never need to know which flavor or accent is active.
ThemeData themeFor(
  CatppuccinFlavor flavor, [
  CatppuccinAccent accent = CatppuccinAccent.mauve,
]) {
  final c = flavor.palette;
  final dark = flavor.isDark;
  final accentColor = accent.of(c);

  // Cards must read as raised. In Catppuccin the ramp runs crust -> mantle
  // -> base -> surface0 -> surface1, so "raised" is a lighter step in a dark
  // flavor and the reverse in Latte. Using base as the page in dark flavors
  // and mantle in Latte keeps a real step between the page and what sits on
  // it, without going outside the palette.
  final pageColor = dark ? c.base : c.mantle;
  final cardColor = dark ? c.surface0 : c.base;
  final borderColor = dark ? c.surface1 : c.surface0;
  final onAccent = dark ? c.mantle : c.base;

  final scheme = ColorScheme(
    brightness: dark ? Brightness.dark : Brightness.light,
    primary: accentColor,
    onPrimary: onAccent,
    primaryContainer: dark ? c.surface1 : c.surface0,
    onPrimaryContainer: c.text,
    secondary: c.blue,
    onSecondary: onAccent,
    secondaryContainer: dark ? c.surface1 : c.surface0,
    onSecondaryContainer: c.text,
    tertiary: c.teal,
    onTertiary: onAccent,
    error: c.red,
    onError: onAccent,
    errorContainer: c.red.withValues(alpha: dark ? 0.22 : 0.16),
    onErrorContainer: c.red,
    surface: pageColor,
    onSurface: c.text,
    surfaceContainerLowest: c.crust,
    surfaceContainerLow: c.mantle,
    surfaceContainer: cardColor,
    surfaceContainerHigh: dark ? c.surface0 : c.base,
    surfaceContainerHighest: c.surface1,
    onSurfaceVariant: c.subtext0,
    outline: borderColor,
    outlineVariant: borderColor.withValues(alpha: 0.5),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: pageColor,
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      // Cards float on background contrast alone, rather than a drawn
      // stroke — a bigger radius and no border reads as softer and less
      // boxy than the old 12px bordered rectangle.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? c.mantle : c.base,
      foregroundColor: c.text,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: dark ? c.mantle : c.base,
      indicatorColor: accentColor.withValues(alpha: 0.22),
      indicatorShape: const StadiumBorder(),
      selectedIconTheme: IconThemeData(color: accentColor),
      unselectedIconTheme: IconThemeData(color: c.subtext0),
      selectedLabelTextStyle: TextStyle(
        color: accentColor,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: TextStyle(color: c.subtext0),
    ),
    dividerTheme: DividerThemeData(color: borderColor, thickness: 1),
    dividerColor: borderColor,
    listTileTheme: ListTileThemeData(
      iconColor: c.subtext0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // More generous row height than Material's tight default — rows read
      // as distinct items with room to breathe, not a packed list.
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      minVerticalPadding: 12,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? c.base : c.mantle,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: accentColor, width: 2),
      ),
      helperMaxLines: 3,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      linearTrackColor: dark ? c.mantle : c.surface0.withValues(alpha: 0.5),
      linearMinHeight: 6,
      borderRadius: BorderRadius.circular(8),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: dark ? c.surface1 : c.surface0,
      contentTextStyle: TextStyle(color: c.text),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: dark ? c.surface1 : c.surface0,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(color: c.text, fontSize: 12),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      iconColor: accentColor,
      collapsedIconColor: c.subtext0,
      textColor: c.text,
      collapsedTextColor: c.text,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    extensions: [
      // A fixed rotation of palette hues for category/type dots (account
      // types, budget categories) — separate from primary/secondary/error
      // so recoloring the accent never shifts what a category dot means.
      CategoryColors([
        c.peach,
        c.teal,
        c.lavender,
        c.pink,
        c.yellow,
        c.sapphire,
        c.maroon,
        c.sky,
      ]),
    ],
  );
}
