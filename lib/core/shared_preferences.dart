import 'package:disco/disco.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsInstance = Provider.withArgument(
  (context, SharedPreferences prefs) => prefs,
);
