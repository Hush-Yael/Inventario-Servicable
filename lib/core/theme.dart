import 'package:fluent_ui/fluent_ui.dart';

const labelIconAlignPadding = EdgeInsets.only(top: 8, bottom: 11, left: 3);

class AppTheme {
  const AppTheme._();

  // Base theme configuration (used by both light and dark themes)
  static FluentThemeData _extendBaseTheme(FluentThemeData t) {
    return t.copyWith(
      navigationPaneTheme: NavigationPaneThemeData(
        // vertical is asymmetric to better align with leading icon
        labelPadding: labelIconAlignPadding,
      ),
    );
  }

  static final FluentThemeData lightTheme = _extendBaseTheme(
    FluentThemeData(accentColor: Colors.orange, brightness: Brightness.light),
  );

  static final FluentThemeData darkTheme = _extendBaseTheme(
    FluentThemeData(accentColor: Colors.orange, brightness: Brightness.dark),
  );
}

extension AppThemeBuildContext on BuildContext {
  FluentThemeData get theme => FluentTheme.of(this);
}
