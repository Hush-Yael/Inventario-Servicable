import 'package:fluent_ui/fluent_ui.dart';

/// Displays a info bar with [message] and [severity] after mutation result
Future<void> showMutationResultMsg({
  required BuildContext context,
  required String message,
  required InfoBarSeverity severity,
}) {
  return displayInfoBar(
    context,
    duration: const Duration(seconds: 5),
    builder: (context, close) {
      return InfoBar(title: Text(message), severity: severity);
    },
  );
}

// Prevents future from resolving too soon, useful to avoid flickering
Future<T> stall<T>(
  Future<T> resource, [
  Duration duration = const Duration(milliseconds: 500),
]) async {
  final [awaited, _] = await Future.wait([resource, Future.delayed(duration)]);
  return awaited;
}
