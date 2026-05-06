import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:trina_grid/trina_grid.dart';

class UnitsLink extends StatelessWidget {
  const UnitsLink({super.key, required this.rowHeight, required this.text});

  final String text;
  final double rowHeight;

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
          onPressed: () {},
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
