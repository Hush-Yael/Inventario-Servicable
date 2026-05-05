import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/shared/widgets/filter_field/index.dart';
import 'package:trina_grid/trina_grid.dart';

class FilterWidget extends StatelessWidget {
  final TrinaColumnType type;
  final TrinaFilterType filter;
  final String value;
  final BuildContext context;
  final int min;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(dynamic) handleOnChanged;

  FilterWidget(
    this.context, {
    super.key,
    required this.type,
    required this.filter,
    required this.value,
    required this.min,
    required this.controller,
    required this.focusNode,
    required this.handleOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = '${filter.title}...';

    if (type.isNumber) {
      return NumberBox(
        min: min,
        mode: .inline,
        focusNode: focusNode,
        placeholder: placeholder,
        onChanged: handleOnChanged,
        onTextChange: handleOnChanged,
        value: value.isEmpty ? null : int.tryParse(value),
        foregroundDecoration: foregroundDecoration,
        decoration: resolveDecoration,
      );
    }

    return TextBox(
      focusNode: focusNode,
      placeholder: placeholder,
      controller: controller,
      onChanged: handleOnChanged,
      foregroundDecoration: foregroundDecoration,
      decoration: resolveDecoration,
    );
  }

  final foregroundDecoration = WidgetStateProperty.all(
    BoxDecoration(border: Border.all(color: Colors.transparent)),
  );

  late final focusedDecoration = BoxDecoration(
    borderRadius: borderRadius,
    border: Border.all(color: context.theme.accentColor),
    color: context.theme.brightness == Brightness.light
        ? context.theme.resources.cardStrokeColorDefaultSolid
        : Colors.grey[140],
  );

  late final baseDecoration = BoxDecoration(
    borderRadius: borderRadius,
    border: Border.all(color: getBorderColor(context)),
    color: context.theme.brightness == Brightness.light
        ? Colors.grey[20]
        : Colors.grey[150],
  );

  late final WidgetStateProperty<BoxDecoration> resolveDecoration =
      .resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return focusedDecoration;
        }

        return baseDecoration;
      });
}
