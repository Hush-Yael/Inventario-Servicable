import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:servicable_stock/core/theme/theme.dart';

class Field<T> extends StatelessWidget {
  final String label;
  final T? initialValue;
  final String? fieldName;
  final Widget Function(FormFieldState<T> field)? childBuilder;
  final Widget? child;
  final ValueTransformer<T?>? valueTransformer;

  const Field(
    this.fieldName, {
    super.key,
    required this.label,
    required this.childBuilder,
    this.child,
    this.initialValue,
    this.valueTransformer,
  });

  const Field.withoutBuilder({
    super.key,
    required this.label,
    required this.child,
    this.fieldName,
    this.initialValue,
    this.childBuilder,
    this.valueTransformer,
  });

  @override
  Widget build(BuildContext context) {
    if (childBuilder == null) {
      return _Field(label: label, child: child!);
    }

    return FormBuilderField<T>(
      name: fieldName!,
      initialValue: initialValue,
      valueTransformer: valueTransformer,
      builder: (FormFieldState<T> field) {
        return _Field(label: label, child: childBuilder!(field));
      },
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(
          label,
          style: .new(color: context.theme.resources.textFillColorSecondary),
        ),

        const SizedBox(height: 8),

        child,
      ],
    );
  }
}
