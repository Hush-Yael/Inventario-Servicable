import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/shared_prefs_service.dart';

class ThemeModeState {
  final SharedPrefsService prefsService;
  late final Signal<ThemeMode> state;

  ThemeModeState(this.prefsService) {
    state = Signal(_getStoredValue());
  }

  static final instance = Provider((context) {
    final sharedPrefs = SharedPrefsService.instance.of(context);

    return ThemeModeState(sharedPrefs);
  });

  Future setTheme(ThemeMode newMode) async {
    state.value = newMode;
    await prefsService.saveThemeMode(newMode);
  }

  ThemeMode _getStoredValue() {
    final t = prefsService.getStoredThemeMode();
    final isSystem = t == ThemeMode.system.name;

    return isSystem
        ? ThemeMode.system
        : t == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
