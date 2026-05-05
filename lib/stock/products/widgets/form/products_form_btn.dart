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

    formVm.useAutoDispose();

    return FilledButton(
      onPressed: () => handler(context),
      child: const Text('Añadir'),
    );
  }

  /// [outerContext] is the context of the parent widget, it has to be used instead of builder one, because the latter can't access the providers
  Future<Object?> handler(BuildContext outerContext) {
    final formVm = ProductsFormVm.instance.of(outerContext);

    return showDialog(
      context: outerContext,
      dismissWithEsc: false,
      builder: (_) {
        return ContentDialog(
          title: const Text(
            'Añadir producto',
            style: AppTheme.dialogTitleStyle,
          ),
          content: ProductsForm(outerContext),
          constraints: kDefaultContentDialogConstraints.copyWith(
            maxWidth: 600,
            maxHeight: 450,
          ),
          actions: [
            SignalBuilder(
              builder: (context, child) => Button(
                style: BtnStyles.dialogButtonStyle,
                onPressed: formVm.isSubmitting.value
                    ? null
                    : () => Navigator.pop(outerContext),
                child: const Text('Descartar'),
              ),
            ),

            SignalBuilder(
              builder: (context, child) => FilledButton(
                onPressed: formVm.isSubmitting.value ? null : formVm.submit,
                style: BtnStyles.dialogButtonStyle,
                child: formVm.isSubmitting.value
                    ? const SubmitBtnRing()
                    : const Text('Guardar'),
              ),
            ),
          ],
        );
      },
    );
  }
}
