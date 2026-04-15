import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/constants/theme_constants.dart';
import 'package:servicable_stock/core/controllers/theme_state.dart';
import 'package:servicable_stock/navigation/widgets/pane_item_dropdown.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModeState = ThemeModeState.instance.of(context);

    return PaneItemDropdown(
      text: 'Tema de la aplicación',
      placement: .rightTop,
      icon: themeModeState.state.value.icon,
      items: List.generate(
        ThemeMode.values.length,
        (index) => MenuFlyoutItem(
          text: Text(ThemeMode.values[index].label),
          leading: WindowsIcon(ThemeMode.values[index].icon),
          onPressed: () => themeModeState.setTheme(ThemeMode.values[index]),
        ),
      ),
    );
  }
}
