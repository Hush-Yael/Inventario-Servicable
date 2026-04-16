import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  SharedPrefsService();

  static final instance = Provider((context) => SharedPrefsService());

  static SharedPreferences? service;

  /// Ensures the service is initialized, must be called before using the instance
  static Future<void> setup() async {
    if (service == null) {
      final prefs = await SharedPreferences.getInstance();
      service = prefs;
    }
  }

  static const themeModeKey = 'theme';

  String getStoredThemeMode() {
    return service!.getString(themeModeKey) ?? ThemeMode.system.name;
  }

  Future<bool> saveThemeMode(ThemeMode newMode) async {
    return await service!.setString(themeModeKey, newMode.name);
  }
}
