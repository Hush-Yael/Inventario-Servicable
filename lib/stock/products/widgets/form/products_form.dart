import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/shared/shared_constants.dart';
import 'package:servicable_stock/shared/widgets/form/base_modal_form.dart';
import 'package:servicable_stock/shared/widgets/form/field.dart';
import 'package:servicable_stock/shared/widgets/form/foreign_key_field.dart';
import 'package:servicable_stock/shared/widgets/form/modal_form_btn.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:servicable_stock/stock/products/view_model/products_form_vm.dart';
import 'package:servicable_stock/stock/products/view_model/products_vm.dart';
import 'package:servicable_stock/stock/products/widgets/form/uses_d_units_field.dart';

class ProductsFormBtn
    extends ModalFormBtn<ProductsAddMutation, ProductsFormVm> {
  const ProductsFormBtn({
    super.key,
    required super.title,
    required super.constraints,
    required super.formVmProvider,
    required super.child,
    required super.createAddMutation,
  });
}

class ProductsForm extends HookWidget {
  final Provider<ProductsFormVm> formVmProvider;

  const ProductsForm({super.key, required this.formVmProvider});

  @override
  Widget build(context) {
    final formVm = ProductsFormVm.instance.of(context);

    final usesDetailedUnits = formVm.usesDetailedUnits;

    final nameController = formVm.useAsyncValidationController(
      formVm.checkNameExists,
    );

    final codeController = formVm.useAsyncValidationController(
      formVm.checkCodeExists,
    );

    final enabled = Computed(() => formVm.enabled);

    return BaseModalForm(
      formVmProvider: formVmProvider,
      child: Column(
        spacing: 15,
        mainAxisSize: .min,
        mainAxisAlignment: .start,
        crossAxisAlignment: .stretch,
        children: [
          const Divider(style: .new(horizontalMargin: .all(0))),

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
                  childBuilder: (field) => SignalBuilder(
                    builder: (context, child) => TextFormBox(
                      enabled: formVm.enabled,
                      controller: nameController,
                      autovalidateMode: .onUserInteraction,
                      validator: (v) => formVm.fieldSyncAndAsyncValidation(
                        field,
                        validator: ProductValidators.name,
                      ),
                      onChanged: (v) =>
                          formVm.changeAndClearAsyncError(v, field),
                      onFieldSubmitted: (v) => formVm.submit(context),
                    ),
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
                      validator: (v) => formVm.fieldSyncAndAsyncValidation(
                        field,
                        validator: ProductValidators.code,
                      ),
                      onChanged: (v) =>
                          formVm.changeAndClearAsyncError(v, field),
                      onFieldSubmitted: (v) => formVm.submit(context),
                    ),
                  ),
                ),

                ForeignKeyField(
                  queryKey: kCategoryNamesQueryKey,
                  field: ProductFormFields.categoryId.name,
                  fetchOptions: ProductsVm.instance
                      .of(context)
                      .service
                      .fetchCategoryNames,
                  label: 'categoría',
                  pluralLabel: 'categorías',
                  pluralLabelVocal: 'a',
                  enabled: enabled,
                ),

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
                        onChanged: usesDetailedUnits.value || !formVm.enabled
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
}
