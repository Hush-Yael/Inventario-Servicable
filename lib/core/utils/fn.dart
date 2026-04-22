import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/auth_state.dart';

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

bool isAdmin(BuildContext context) {
  final UserRole role =
      AuthState.instance.of(context).user?.role ?? UserRole.supervisor;

  return role == UserRole.admin;
}

bool hasPerm(BuildContext context, UserRole reqRole) {
  final int currentLevel =
      AuthState.instance.of(context).user?.role.level ??
      UserRole.supervisor.level;

  return currentLevel >= reqRole.level;
}

Future<dynamic> confirmDeletion(
  BuildContext context, {
  required String title,
  required String msg,
  required void Function() onConfirmed,
  String cancelTxt = 'No, cancelar',
  String confirmTxt = 'Sí, eliminar',
}) => showDialog<String>(
  context: context,
  builder: (context) => ContentDialog(
    title: Text(title, style: AppTheme.dialogTitleStyle),
    content: Text(msg),
    actions: [
      Button(
        onPressed: () => Navigator.pop(context, 'No'),
        style: ButtonStyle(padding: .all(.all(8))),
        child: Text(cancelTxt),
      ),

      Button(
        style: BtnStyles.dangerButtonStyle.copyWith(padding: .all(.all(8))),
        onPressed: () {
          onConfirmed();
          Navigator.pop(context, 'Si');
        },
        child: Text(confirmTxt),
      ),
    ],
  ),
);