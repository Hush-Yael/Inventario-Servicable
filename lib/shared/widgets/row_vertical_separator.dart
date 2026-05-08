import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme.dart';

class RowVerticalSeparator extends StatelessWidget {
  const RowVerticalSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 16,
      color: context.theme.brightness == Brightness.dark
          ? Colors.grey[140]
          : context.theme.resources.cardStrokeColorDefaultSolid,
    );
  }
}
