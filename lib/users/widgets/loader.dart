import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.brightness == Brightness.dark
            ? Colors.black.withAlpha(90)
            : Colors.black.withAlpha(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 14,
          children: [
            const ProgressRing(),

            Text(
              'Cargando usuarios...',
              style: context.theme.typography.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}
