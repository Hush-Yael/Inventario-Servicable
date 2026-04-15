import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme.dart';

class PaneItemDropdown extends StatelessWidget {
  final IconData? icon;
  final String text;
  final FlyoutPlacementMode placement;
  final List<MenuFlyoutItemBase> items;
  final Widget? subtitle;

  const PaneItemDropdown({
    super.key,
    required this.text,
    required this.placement,
    required this.items,
    this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final controller = FlyoutController();

    return FlyoutTarget(
      controller: controller,
      child: ListTile.selectable(
        title: Text(
          text,
          style: context.theme.navigationPaneTheme.unselectedTextStyle?.resolve(
            {},
          ),
        ),
        subtitle: subtitle,
        leading: WindowsIcon(
          icon,
          size: context.theme.navigationPaneTheme.unselectedTextStyle
              ?.resolve({})
              ?.fontSize,
        ),
        margin: .only(left: 6, right: 6, bottom: 5),
        tileColor: .resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.selected)) {
            return ButtonThemeData.uncheckedInputColor(context.theme, states);
          }

          return Colors.transparent;
        }),
        onPressed: () {
          controller.showFlyout<void>(
            autoModeConfiguration: FlyoutAutoConfiguration(
              preferredMode: placement,
            ),
            builder: (context) => MenuFlyout(items: items),
          );
        },
      ),
    );
  }
}
