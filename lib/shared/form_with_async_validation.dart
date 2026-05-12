import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:flutter_solidart/flutter_solidart.dart' hide Debouncer;
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/shared/debouncer.dart';
import 'package:servicable_stock/shared/fn/mutations/single_add.dart';

class FormWithAsyncValidation<
  MutInput,
  Mutation extends MutationResult<dynamic, dynamic, MutInput, dynamic>
> {
  final bool isModal;
  Mutation? mutation;

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
    Future<bool> Function(String text) check, {
    String? initialValue,
  }) {
    final timer = Debouncer(700);
    final controller = useTextEditingController(text: initialValue);

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

  Future<bool> checkAsyncErrorsBeforeSubmit() {
    throw UnimplementedError();
  }

  T getValue<T>(String key) {
    final val = formKey.currentState!.fields[key]?.value;

    if (val.runtimeType == String) return val.trim();

    return val;
  }

  Future<dynamic> submit(BuildContext context) async {
    if (isSubmitting.value || invalid) return;

    isSubmitting.value = true;

    final error = await stall(
      checkAsyncErrorsBeforeSubmit(),
      const .new(milliseconds: 250),
    );

    if (error) return isSubmitting.value = false;

    final input = getFormData();

    try {
      return await mutation!.mutateAsync(input);
    } catch (e) {
      if (context.mounted) {
        showMsg(context: context, message: e.toString(), severity: .error);
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  MutInput getFormData() {
    throw UnimplementedError(
      'getFormData must be implemented to perform mutation',
    );
  }
}

class ModalFormWithAsyncValidation<Input, NewObj extends Object>
    extends FormWithAsyncValidation<Input, SingleAddMutation<Input, NewObj>> {
  ModalFormWithAsyncValidation(this.db, {super.isModal = true});

  final AppDatabase db;

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

  @override
  // ignore: avoid_renaming_method_parameters
  Future<dynamic> submit(BuildContext modalContext) async {
    final result = await super.submit(modalContext);

    if (modalContext.mounted) Navigator.of(modalContext).pop();

    return result;
  }
}
