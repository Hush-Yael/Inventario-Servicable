import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/shared/widgets/field.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:servicable_stock/stock/products/view_model/products_form_vm.dart';
import 'package:servicable_stock/stock/products/widgets/form/category_field.dart';
import 'package:servicable_stock/stock/products/widgets/form/uses_d_units_field.dart';

class ProductsForm extends HookWidget {
  const ProductsForm({super.key});

  @override
  Widget build(BuildContext context) {
    bool escapeHandler(KeyEvent event) => _escapeHandler(event, context);
    final formVm = ProductsFormVm.instance.of(context);

    final formKey = formVm.formKey;

    final enabled = formVm.enabled;
    final usesDetailedUnits = formVm.usesDetailedUnits;

    final nameController = formVm.useAsyncValidation(
      formVm.checkNameExists,
      ProductFormFields.name.name,
    );

    final codeController = formVm.useAsyncValidation(
      formVm.checkCodeExists,
      ProductFormFields.code.name,
    );

    useEffect(() {
      ServicesBinding.instance.keyboard.addHandler(escapeHandler);

      return () =>
          ServicesBinding.instance.keyboard.removeHandler(escapeHandler);
    }, []);

    return FormBuilder(
      key: formKey,
      child: Column(
        spacing: 15,
        mainAxisSize: .min,
        mainAxisAlignment: .start,
        crossAxisAlignment: .stretch,
        children: [
          Divider(style: .new(horizontalMargin: .all(0))),

          SizedBox(
            height: 200,
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 30,
              childAspectRatio: 3,
              children: [
                Field<String?>(
                  ProductFormFields.name.name,
                  label: 'Nombre',
                  valueTransformer: (value) => value?.trim(),
                  childBuilder: (field) => TextFormBox(
                    enabled: enabled,
                    controller: nameController,
                    autovalidateMode: .onUnfocus,
                    validator: (v) => formVm.validateWithAsync(
                      v,
                      validator: ProductValidators.name,
                      check: formVm.checkNameExists,
                      errorRef: formVm.nameExists,
                      asyncErrorMsg: 'El nombre ya existe',
                    ),
                    onChanged: field.didChange,

                    onFieldSubmitted: formVm.submit,
                  ),
                ),

                Field<String?>(
                  ProductFormFields.code.name,
                  label: 'Código',
                  valueTransformer: (value) => value?.trim(),
                  childBuilder: (field) => SignalBuilder(
                    builder: (context, child) => TextFormBox(
                      enabled: formVm.enabled,
                      controller: codeController,
                      autovalidateMode: .onUserInteraction,
                      validator: (v) => formVm.validateWithAsync(
                        v,
                        validator: ProductValidators.code,
                        check: formVm.checkCodeExists,
                        errorRef: formVm.codeExists,
                        asyncErrorMsg: 'El código debe ser único',
                      ),
                      onChanged: field.didChange,
                      onFieldSubmitted: formVm.submit,
                    ),
                  ),
                ),

                CategoryField(),

                Field(
                  ProductFormFields.units.name,
                  label: 'Unidades',
                  valueTransformer: (v) => int.tryParse(v as String),
                  initialValue: 0,
                  childBuilder: (field) {
                    return SignalBuilder(
                      builder: (context, child) => NumberFormBox(
                        min: 0,
                        mode: .inline,
                        value: field.value,
                        initialValue: field.value.toString(),
                        autovalidateMode: .onUserInteraction,
                        validator: (value) {
                          if (usesDetailedUnits.value) return null;

                          return ProductValidators.units(value);
                        },
                        onChanged: usesDetailedUnits.value || !enabled
                            ? null
                            : field.didChange,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          UsesDetailedUnitsField(),
        ],
      ),
    );
  }

  /// prevent closing the form when submitting and escape key is pressed
  bool _escapeHandler(KeyEvent event, BuildContext context) {
    final bool isEscape = event.logicalKey == LogicalKeyboardKey.escape;

    if (event is KeyDownEvent && isEscape) {
      final formVm = ProductsFormVm.instance.of(context);

      if (formVm.enabled) {
        Navigator.of(context).pop();
        return true; // Prevent further propagation
      }
    }

    return false; // Allow other listeners to handle the event
  }
}
