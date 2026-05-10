import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:servicable_stock/shared/form_with_async_validation.dart';

class BaseModalForm extends HookWidget {
  final Widget child;
  final Provider<ModalFormWithAsyncValidation> formVmProvider;
  const BaseModalForm({
    super.key,
    required this.child,
    required this.formVmProvider,
  });

  @override
  Widget build(BuildContext context) {
    final formVm = formVmProvider.of(context);

    bool escapeHandler(KeyEvent event) => _escapeHandler(event, context);

    useEffect(() {
      ServicesBinding.instance.keyboard.addHandler(escapeHandler);

      return () =>
          ServicesBinding.instance.keyboard.removeHandler(escapeHandler);
    }, []);

    return FormBuilder(key: formVm.formKey, child: child);
  }

  /// prevent closing the form when submitting and escape key is pressed
  bool _escapeHandler(KeyEvent event, BuildContext context) {
    final bool isEscape = event.logicalKey == LogicalKeyboardKey.escape;

    if (event is KeyDownEvent && isEscape) {
      final formVm = formVmProvider.of(context);

      if (formVm.enabled) {
        Navigator.of(context).pop();
        return true; // Prevent further propagation
      }
    }

    return false; // Allow other listeners to handle the event
  }
}
