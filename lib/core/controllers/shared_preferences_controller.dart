import 'package:disco/disco.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider.withArgument(
  (context, SharedPreferences prefs) => prefs,
);
