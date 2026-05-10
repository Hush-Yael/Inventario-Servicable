import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/navigation/navigation_pages.dart';
import 'package:trina_grid/trina_grid.dart';

class UnitsLink extends StatelessWidget {
  final String text;
  final String productName;
  final double rowHeight;

  const UnitsLink({
    super.key,
    required this.rowHeight,
    required this.text,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    final padding = TrinaGridSettings.cellPadding;

    return SizedBox(
      height: rowHeight,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: HyperlinkButton(
          style: .new(
            shape: .all(
              const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            padding: .all(
              .symmetric(
                horizontal: padding.horizontal / 2,
                vertical: padding.vertical,
              ),
            ),
            foregroundColor: .all(context.theme.resources.textFillColorPrimary),
          ),
          onPressed: () {
            context.goNamed(
              MainNavigationPages.units.name,
              queryParameters: {'productName': productName},
            );
          },
          child: Row(
            children: [
              Text(text),

              const Spacer(),

              WindowsIcon(
                FluentIcons.chevron_right,
                size: 14,
                color: context.theme.resources.textFillColorSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
