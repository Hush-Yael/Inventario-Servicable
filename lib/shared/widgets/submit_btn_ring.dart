import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme.dart';

class SubmitBtnRing extends StatelessWidget {
  const SubmitBtnRing({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      width: 16,
      child: ProgressRing(
        strokeWidth: 3.5,
        backgroundColor: context.theme.accentColor.withAlpha(90),
      ),
    );
  }
}
