import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart' hide Debouncer;
import 'package:servicable_stock/shared/debouncer.dart';

class FormWithAsyncValidation {
  final bool isModal;

  FormWithAsyncValidation({this.isModal = false});

  final formKey = GlobalKey<FormBuilderState>();

  late final isSubmitting = Signal(false, autoDispose: !isModal);

  bool get enabled => !isSubmitting.value;
  bool get invalid => formKey.currentState!.saveAndValidate() != true;

  /// To show async errors, fields are manually invalidated. Those errors are then shown using field.errorText
  String? fieldSyncAndAsyncValidation<T extends FormFieldState<String?>>(
    T field, {
    required String? Function(String?) validator,
  }) {
    final error = validator(field.value) ?? field.errorText;

    return error;
  }

  void changeAndClearAsyncError<T>(T value, FormFieldState<T> field) {
    if (field.errorText != null) field.validate();
    field.didChange(value);
  }

  TextEditingController useAsyncValidationController(
    Future<bool> Function(String text) check,
  ) {
    final timer = Debouncer(700);
    final controller = useTextEditingController();

    listener() {
      final text = controller.text.trim();
      if (text.isNotEmpty) timer.run(() => check(text));
    }

    useEffect(() {
      controller.addListener(listener);

      return () {
        timer.dispose();
        controller.removeListener(listener);
      };
    }, [controller]);

    return controller;
  }
}

class ModalFormWithAsyncValidation extends FormWithAsyncValidation {
  ModalFormWithAsyncValidation({super.isModal = true});

  /// Used signals must be disposed manually to prevent crashing when using them when modal is opened again
  void disposeSignals() {
    isSubmitting.dispose();
  }

  /// Dispose signals when the widget that shows  is disposed
  void useSignalsDispose() {
    useEffect(() {
      return disposeSignals;
    }, []);
  }
}
