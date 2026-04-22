import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/shared/widgets/submit_btn_ring.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_vm.dart';
import 'package:servicable_stock/stock/categories/categories_types.dart';

class CategoriesForm extends HookWidget {
  const CategoriesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    final vm = CategoriesVm.instance.of(context);

    final CategoriesAddMutation mutation = vm.createAddMutation(context);

    void cb([String? _]) => onSubmitted(context, controller, mutation);

    return Row(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          child: TextBox(
            placeholder: 'Nueva categoría',
            controller: controller,
            enabled: !mutation.isPending,
            onSubmitted: cb,
          ),
        ),

        FilledButton(
          onPressed: mutation.isPending ? null : cb,
          style: .new(padding: .all(.symmetric(vertical: 10, horizontal: 8))),
          child: mutation.isPending
              ? const SubmitBtnRing()
              : const WindowsIcon(FluentIcons.add),
        ),
      ],
    );
  }

  void onSubmitted(
    BuildContext context,
    TextEditingController controller,
    CategoriesAddMutation mutation,
  ) {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    final vm = CategoriesVm.instance.of(context);
    final errorMsg = vm.service.validateCategoryNameLength(text);

    if (errorMsg != null) {
      showMutationResultMsg(
        context: context,
        message: errorMsg,
        severity: .error,
      );

      return;
    }

    mutation.mutate(text);
  }
}
