import 'package:fluent_ui/fluent_ui.dart';

const Map<ThemeMode, IconData> themeIcons = {
  ThemeMode.light: FluentIcons.sunny,
  ThemeMode.dark: FluentIcons.clear_night,
  ThemeMode.system: FluentIcons.auto_deploy_settings,
};

const Map<ThemeMode, String> themeLabels = {
  ThemeMode.light: 'Claro',
  ThemeMode.dark: 'Oscuro',
  ThemeMode.system: 'Sistema',
};
