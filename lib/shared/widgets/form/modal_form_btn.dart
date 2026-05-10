import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/shared/fn/mutations/index.dart';
import 'package:servicable_stock/shared/form_with_async_validation.dart';
import 'package:servicable_stock/shared/widgets/form/submit_btn_ring.dart';

class ModalFormBtn<
  Mutation extends SingleAddMutation,
  FormVm extends ModalFormWithAsyncValidation
>
    extends HookWidget {
  final String title;
  final BoxConstraints constraints;
  final Provider<FormVm> formVmProvider;
  final Mutation Function(BuildContext context) createAddMutation;
  final bool autoOpen;
  final Widget child;

  const ModalFormBtn({
    super.key,
    required this.title,
    required this.constraints,
    required this.formVmProvider,
    required this.child,
    required this.createAddMutation,
    this.autoOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    final formVm = formVmProvider.of(context);
    formVm.mutation = createAddMutation(context);

    _useAutoOpenModal(autoOpen, () => handler(context));

    formVm.useSignalsDispose();

    return FilledButton(
      onPressed: () => handler(context),
      child: const Row(
        spacing: 7,
        mainAxisAlignment: .center,
        children: [Text('Añadir'), Icon(FluentIcons.add_to)],
      ),
    );
  }

  Future<Object?> handler(BuildContext outerContext) {
    return showDialog(
      context: outerContext,
      dismissWithEsc: false,
      builder: (context) {
        return ProviderScopePortal(
          mainContext: outerContext,
          child: ContentDialog(
            title: Text(title, style: AppTheme.dialogTitleStyle),
            content: child,
            constraints: constraints,
            actions: getActions(formVmProvider.of(outerContext)),
          ),
        );
      },
    );
  }

  List<Widget> getActions(FormVm formVm) {
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
              : const Text('Añadir'),
        ),
      ),
    ];
  }

  void _useAutoOpenModal(bool shouldOpen, VoidCallback handler) {
    if (kReleaseMode || !shouldOpen) return;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handler();
      });

      return null;
    }, []);
  }
}
