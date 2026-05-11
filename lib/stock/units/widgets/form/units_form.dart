import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/shared/widgets/form/base_modal_form.dart';
import 'package:servicable_stock/shared/widgets/form/foreign_key_field.dart';
import 'package:servicable_stock/shared/widgets/form/modal_form_btn.dart';
import 'package:servicable_stock/stock/units/units_constants.dart';
import 'package:servicable_stock/stock/units/units_types.dart';
import 'package:servicable_stock/stock/units/view_model/units_form_vm.dart';
import 'package:servicable_stock/shared/widgets/form/field.dart';

class UnitsFormBtn extends ModalFormBtn<UnitsAddMutation, UnitsFormVm> {
  const UnitsFormBtn({
    super.key,
    required super.title,
    required super.constraints,
    required super.formVmProvider,
    required super.child,
    required super.createAddMutation,
  });
}

class UnitsForm extends HookWidget {
  final Provider<UnitsFormVm> formVmProvider;

  final Future<ProductForeignKeyOptions> Function([QueryFunctionContext? ctx])
  getProductOptions;

  const UnitsForm({
    super.key,
    required this.formVmProvider,
    required this.getProductOptions,
  });

  @override
  Widget build(context) {
    final formVm = UnitsFormVm.instance.of(context);

    final identifierController = formVm.useAsyncValidationController(
      formVm.checkIdentifierExists,
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

          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 30,
            childAspectRatio: 3,
            children: [
              Field<String>(
                UnitFormFields.identifier.name,
                label: 'Identificador',
                valueTransformer: (value) => value?.trim(),
                childBuilder: (field) => SignalBuilder(
                  builder: (context, child) => TextFormBox(
                    enabled: formVm.enabled,
                    controller: identifierController,
                    autovalidateMode: .onUserInteraction,
                    validator: (v) => formVm.fieldSyncAndAsyncValidation(
                      field,
                      validator: UnitValidators.identifier,
                    ),
                    onChanged: (v) => formVm.changeAndClearAsyncError(v, field),
                    onFieldSubmitted: (v) => formVm.submit(context),
                  ),
                ),
              ),

              ForeignKeyField(
                field: UnitFormFields.productId.name,
                queryKey: kUnitsProductOptionsQueryKey,
                fetchOptions: getProductOptions,
                label: 'producto',
                pluralLabel: 'productos',
                enabled: enabled,
              ),

              Field<String>(
                UnitFormFields.soldTo.name,
                label: 'Adquirido por',
                valueTransformer: (value) => value?.trim(),
                childBuilder: (field) => SignalBuilder(
                  builder: (context, child) => TextFormBox(
                    enabled: formVm.enabled,
                    autovalidateMode: .onUserInteraction,
                    validator: (v) => formVm.fieldSyncAndAsyncValidation(
                      field,
                      validator: UnitValidators.soldTo,
                    ),
                    onChanged: (v) => formVm.changeAndClearAsyncError(v, field),
                    onFieldSubmitted: (v) => formVm.submit(context),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Field<String>(
              UnitFormFields.details.name,
              label: 'Detalles',
              valueTransformer: (value) => value?.trim(),
              childBuilder: (field) => SignalBuilder(
                builder: (context, child) => SizedBox(
                  height: 100,
                  child: TextFormBox(
                    maxLines: null,
                    enabled: formVm.enabled,
                    autovalidateMode: .onUserInteraction,
                    validator: (v) => formVm.fieldSyncAndAsyncValidation(
                      field,
                      validator: UnitValidators.details,
                    ),
                    onChanged: (v) => formVm.changeAndClearAsyncError(v, field),
                    onFieldSubmitted: (v) => formVm.submit(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
