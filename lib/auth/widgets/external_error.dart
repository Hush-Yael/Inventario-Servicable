import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme.dart';

/// A widget that shows an error message after async validation for any field.
class ExternalError extends StatelessWidget {
  final String text;
  const ExternalError({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const SizedBox(height: 3),

        Text(
          text,
          style: TextStyle(
            color: AppTheme.errorColor(context),
            fontWeight: .w500,
          ),
        ),
      ],
    );
  }
}
