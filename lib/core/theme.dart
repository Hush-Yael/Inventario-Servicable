import 'package:fluent_ui/fluent_ui.dart';

class AppTheme {
  const AppTheme._();

  // Base theme configuration (used by both light and dark themes)
  static FluentThemeData _extendBaseTheme(FluentThemeData t) {
    return t.copyWith(
      // fix fluent btn text alignment
      buttonTheme: ButtonThemeData(
        defaultButtonStyle: BtnStyles.fixedTextAlignmentStyle,
        filledButtonStyle: BtnStyles.fixedTextAlignmentStyle,
        outlinedButtonStyle: BtnStyles.fixedTextAlignmentStyle,
        hyperlinkButtonStyle: BtnStyles.fixedTextAlignmentStyle,
      ),

      navigationPaneTheme: NavigationPaneThemeData(
        // vertical is asymmetric to better align with leading icon
        labelPadding: .only(top: 8, bottom: 11, left: 3),
      ),
    );
  }

  static final FluentThemeData lightTheme = _extendBaseTheme(
    FluentThemeData(accentColor: Colors.orange, brightness: Brightness.light),
  );

  static final FluentThemeData darkTheme = _extendBaseTheme(
    FluentThemeData(accentColor: Colors.orange, brightness: Brightness.dark),
  );

  static const TextStyle fixedTextHeightStyle = TextStyle(height: 0);
  static const TextStyle dialogTitleStyle = TextStyle(fontSize: 20);

  static Color errorColor(BuildContext context) =>
      MediaQuery.of(context).platformBrightness == Brightness.dark
      ? Colors.red.lightest
      : Colors.red.darkest;
}

extension AppThemeBuildContext on BuildContext {
  FluentThemeData get theme => FluentTheme.of(this);
}

class BtnStyles {
  BtnStyles._();

  /// For some reason, Fluent text doesn't properly align with leading icon or padding in general. This is a workaround to fix that.
  static const ButtonStyle fixedTextAlignmentStyle = ButtonStyle(
    textStyle: WidgetStatePropertyAll(AppTheme.fixedTextHeightStyle),
  );

  static ButtonStyle dangerButtonStyle = ButtonStyle(
    backgroundColor: .resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return Colors.red.withAlpha(128);
      }

      if (states.contains(WidgetState.pressed)) {
        return Colors.red.dark;
      }

      if (states.contains(WidgetState.hovered)) {
        return Colors.red.light;
      }

      return Colors.red;
    }),

    foregroundColor: .resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return Colors.white.withAlpha(128);
      }

      return Colors.white;
    }),
  );
}
