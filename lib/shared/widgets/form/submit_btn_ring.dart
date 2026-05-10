import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme.dart';

class SubmitBtnRing extends StatelessWidget {
  final double size;
  const SubmitBtnRing({super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: ProgressRing(
        strokeWidth: 3.5,
        backgroundColor: context.theme.accentColor.withAlpha(90),
      ),
    );
  }
}
