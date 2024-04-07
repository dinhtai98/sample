
flutter pub run build_runner build --delete-conflicting-outputs
# Build runner at folder or file
# Example:
flutter pub run build_runner build --delete-conflicting-outputs --build-filter 'lib/core/models/user/*.dart'
flutter run --release --flavor dev -t lib/main_dev.dart
# Gen localization
flutter gen-l10n


flutter pub outdated