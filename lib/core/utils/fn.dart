import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/theme/theme.dart';

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

Future<dynamic> confirmCascadeDeletion(
  BuildContext context, {
  required String title,
  required String msg,
  required void Function() onConfirmed,
  String cancelTxt = 'No, cancelar',
  String confirmTxt = 'Sí, eliminar',
}) {
  final proceed = Signal(false);

  return showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      title: Text(title, style: AppTheme.dialogTitleStyle),
      content: Column(
        spacing: 16,
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Text(msg),
          SignalBuilder(
            builder: (context, child) {
              return Checkbox(
                checked: proceed.value,
                onChanged: (value) => proceed.value = value ?? false,
                content: const Text(
                  'Lo entiendo, y deseo continuar',
                  style: AppTheme.fixedTextHeightStyle,
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        Button(
          onPressed: () => Navigator.pop(context, 'No'),
          style: ButtonStyle(padding: .all(.all(8))),
          child: Text(cancelTxt),
        ),

        SignalBuilder(
          builder: (context, child) => Button(
            style: BtnStyles.dangerButtonStyle.copyWith(padding: .all(.all(8))),
            onPressed: !proceed.value
                ? null
                : () {
                    onConfirmed();
                    Navigator.pop(context, 'Si');
                  },
            child: Text(confirmTxt),
          ),
        ),
      ],
    ),
  );
}

extension PluralExtension on int {
  String plural(
    String singularWord, {
    String suffix = "s",
    bool included = true,
  }) {
    final prefix = included ? "$this " : "";

    return this > 1 ? "$prefix$singularWord$suffix" : "$prefix$singularWord";
  }

  String multiPlural(
    String sentenceWithSingulars,
    Map<int, String>? pluralSuffixes,
  ) {
    final numPlaceholder = '\$';

    final isPlural = this != 1;

    final newSentence = sentenceWithSingulars
        .split(' ')
        .asMap()
        .map((i, w) {
          return MapEntry(
            i,
            w == numPlaceholder
                ? w
                : '$w${isPlural ? (pluralSuffixes?[i] ?? 's') : ''}',
          );
        })
        .values
        .join(' ');

    return newSentence.replaceFirst(numPlaceholder, toString());
  }
}
