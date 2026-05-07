import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_solidart/flutter_solidart.dart';

class FormWithAsyncValidation {
  final formKey = GlobalKey<FormBuilderState>();
  final isSubmitting = Signal(false);

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
}
