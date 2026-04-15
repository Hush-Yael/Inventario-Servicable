import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/controllers/shared_preferences_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeState {
  final SharedPreferences _prefs;
  late final Signal<ThemeMode> state;

  ThemeModeState(SharedPreferences prefs) : _prefs = prefs {
    state = Signal(_getStoredValue());
  }

  static final instance = Provider((context) {
    final sharedPrefs = sharedPreferencesProvider.of(context);

    return ThemeModeState(sharedPrefs);
  });

  Future setTheme(ThemeMode newMode) async {
    state.value = newMode;
    await _prefs.setString('theme', newMode.name);
  }

  ThemeMode _getStoredValue() {
    final t = _prefs.getString('theme');
    final isSystem = t == null || t == 'system';

    return isSystem
        ? ThemeMode.system
        : t == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
