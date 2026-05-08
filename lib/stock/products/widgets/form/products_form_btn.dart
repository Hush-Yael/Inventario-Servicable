import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/shared/widgets/submit_btn_ring.dart';
import 'package:servicable_stock/stock/products/view_model/products_form_vm.dart';
import 'package:servicable_stock/stock/products/view_model/products_vm.dart';
import 'package:servicable_stock/stock/products/widgets/form/products_form.dart';

class ProductsFormBtn extends HookWidget {
  const ProductsFormBtn({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = ProductsVm.instance.of(context);
    final formVm = ProductsFormVm.instance.of(context);
    formVm.mutation = vm.createAddMutation(context);

    // useAutoOpenModal(() => handler(context));

    formVm.useSignalsDispose();

    return FilledButton(
      onPressed: () => handler(context),
      child: const Text('Añadir'),
    );
  }

  Future<Object?> handler(BuildContext outerContext) {
    final formVm = ProductsFormVm.instance.of(outerContext);

    return showDialog(
      context: outerContext,
      dismissWithEsc: false,
      builder: (context) {
        return ProviderScopePortal(
          mainContext: outerContext,
          child: ContentDialog(
            title: const Text(
              'Añadir producto',
              style: AppTheme.dialogTitleStyle,
            ),
            content: ProductsForm(),
            constraints: kDefaultContentDialogConstraints.copyWith(
              maxWidth: 600,
              maxHeight: 450,
            ),
            actions: getActions(formVm),
          ),
        );
      },
    );
  }

  List<Widget> getActions(ProductsFormVm formVm) {
    return [
      SignalBuilder(
        builder: (context, child) => Button(
          style: BtnStyles.dialogButtonStyle,
          onPressed: formVm.isSubmitting.value
              ? null
              : () => Navigator.pop(context),
          child: const Text('Descartar'),
        ),
      ),

      SignalBuilder(
        builder: (context, child) => FilledButton(
          onPressed: formVm.isSubmitting.value
              ? null
              : () => formVm.submit(context),
          style: BtnStyles.dialogButtonStyle,
          child: formVm.isSubmitting.value
              ? const SubmitBtnRing()
              : const Text('Guardar'),
        ),
      ),
    ];
  }
}
