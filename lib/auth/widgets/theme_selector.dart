import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme_mode_state.dart';
import 'package:servicable_stock/core/theme/theme_constants.dart';

class SignInUpThemeSelector extends StatelessWidget {
  const SignInUpThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeModeState themeModeState = ThemeModeState.instance.of(context);

    return Positioned(
      top: 0,
      right: 20,
      child: DropDownButton(
        style: ButtonStyle(
          padding: .all(.symmetric(vertical: 7, horizontal: 6)),
        ),
        title: WindowsIcon(themeModeState.state.value.icon),
        trailing: null,
        items: List.generate(
          ThemeMode.values.length,
          (index) => MenuFlyoutItem(
            text: Text(ThemeMode.values[index].label),
            leading: WindowsIcon(ThemeMode.values[index].icon),
            onPressed: () => themeModeState.setTheme(ThemeMode.values[index]),
          ),
        ),
      ),
    );
  }
}
