import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/controllers/shared_preferences_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  ThemeController({required SharedPreferences prefs}) : _prefs = prefs {
    mode.value = getTheme();
  }

  final SharedPreferences _prefs;
  Signal<ThemeMode?> mode = Signal(null);

  Future setTheme(ThemeMode newMode) async {
    mode.value = newMode;
    await _prefs.setString('theme', newMode.name);
  }

  ThemeMode getTheme() {
    final t = _prefs.getString('theme');
    final isSystem = t == null || t == 'system';

    return isSystem
        ? ThemeMode.system
        : t == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static final provider = Provider(
    (context) => ThemeController(prefs: sharedPreferencesProvider.of(context)),
  );
}
