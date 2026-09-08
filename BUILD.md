# Building Granary

Requires Flutter 3.47+ with the Linux desktop toolchain (clang, cmake,
ninja-build, pkg-config, libgtk-3-dev) or the Android SDK for APKs.

## Linux desktop (primary target)

    flutter build linux --release --no-tree-shake-icons

`--no-tree-shake-icons` is required: icon tree-shaking drops glyphs that are
referenced from conditional widget lists, which renders those icons blank.

The runnable app is at `build/linux/x64/release/bundle/granary`.

## Android APK (secondary target)

    flutter build apk --release --no-tree-shake-icons

## Development

    flutter run -d linux      # hot reload
    flutter test              # unit + widget tests
    dart run build_runner build --delete-conflicting-outputs   # after schema edits
