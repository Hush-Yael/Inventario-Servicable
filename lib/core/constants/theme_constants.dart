import 'package:fluent_ui/fluent_ui.dart';

const Map<ThemeMode, IconData> themeIcons = {
  ThemeMode.light: FluentIcons.sunny,
  ThemeMode.dark: FluentIcons.clear_night,
  ThemeMode.system: FluentIcons.auto_deploy_settings,
};

extension ThemeModeExt on ThemeMode {
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
