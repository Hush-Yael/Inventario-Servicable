import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:servicable_stock/stock/products/view_model/products_form_vm.dart';

class UsesDetailedUnitsField extends StatelessWidget {
  final BuildContext outerContext;
  const UsesDetailedUnitsField(this.outerContext, {super.key});

  @override
  Widget build(_) {
    final formVm = ProductsFormVm.instance.of(outerContext);
    final checked = formVm.usesDetailedUnits;

    return FormBuilderField(
      name: ProductFormFields.usesDetailedUnits.name,
      initialValue: checked.value,
      builder: (field) {
        return Transform.translate(
          offset: const Offset(0, -5),
          child: SignalBuilder(
            builder: (context, child) => Checkbox(
              checked: checked.value,
              onChanged: !formVm.enabled
                  ? null
                  : (c) {
                      checked.value = c ?? false;
                      field.didChange(c);
                    },
              content: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: .start,
                  children: [
                    const Text(
                      'Usa unidades detalladas',
                      style: AppTheme.fixedTextHeightStyle,
                    ),

                    SignalBuilder(
                      builder: (context, child) => Text(
                        !checked.value
                            ? 'la cantidad se ingresa directamente'
                            : 'cada una se ingresa individualmente',
                        style: .new(
                          fontSize: 13,
                          color: context.theme.resources.textFillColorTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
