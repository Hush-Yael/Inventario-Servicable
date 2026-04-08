import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/controllers/theme_controller.dart';
import 'package:servicable_stock/core/constants/theme_constants.dart';

class SignInUpThemeSelector extends StatelessWidget {
  const SignInUpThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = ThemeController.provider.of(
      context,
    );

    return Positioned(
      top: 0,
      right: 20,
      child: DropDownButton(
        style: ButtonStyle(
          padding: .all(.symmetric(vertical: 7, horizontal: 6)),
        ),
        title: WindowsIcon(themeIcons[themeController.mode.value]!),
        trailing: null,
        items: List.generate(
          ThemeMode.values.length,
          (index) => MenuFlyoutItem(
            text: Text(themeLabels[ThemeMode.values[index]]!),
            leading: WindowsIcon(themeIcons[ThemeMode.values[index]]),
            onPressed: () => themeController.setTheme(ThemeMode.values[index]),
          ),
        ),
      ),
    );
  }
}
