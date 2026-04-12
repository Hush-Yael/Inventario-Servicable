import 'package:fluent_ui/fluent_ui.dart';

extension ThemeModeExt on ThemeMode {
  /// Returns the icon of the theme mode
  IconData get icon {
    switch (this) {
      case ThemeMode.light:
        return FluentIcons.sunny;
      case ThemeMode.dark:
        return FluentIcons.clear_night;
      case ThemeMode.system:
        return FluentIcons.auto_deploy_settings;
    }
  }

  /// Returns the label of the theme mode
  String get label {
    switch (this) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  }
}
