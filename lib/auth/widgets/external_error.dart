import 'package:fluent_ui/fluent_ui.dart';

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
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.red.lightest
                : Colors.errorPrimaryColor,
          ),
        ),
      ],
    );
  }
}
