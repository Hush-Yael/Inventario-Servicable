import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/auth_vm.dart';
import 'package:servicable_stock/auth/widgets/external_error.dart';
import 'package:servicable_stock/core/utils/validators.dart';

final nameValidators = FormBuilderValidators.compose([
  Validators.required,
  FormBuilderValidators.match(
    RegExp(r'^[a-zA-Z\u00C0-\u017F\s]+$'),
    errorText: 'El nombre solo puede contener letras y espacios',
  ),
  Validators.minLength(kNameMinLength),
  Validators.maxLength(kNameMaxLength),
]);

final usernameValidators = FormBuilderValidators.compose([
  Validators.required,
  Validators.minLength(kUsernameMinLength),
  Validators.maxLength(kUsernameMaxLength),
  FormBuilderValidators.match(
    RegExp(r'^[a-zA-Z0-9_]+$'),
    errorText:
        'El nombre de usuario solo puede contener letras, números y pisos',
  ),
]);

final passwordValidators = FormBuilderValidators.compose([
  Validators.required,
  Validators.minLength(kPasswordMinLength),
  Validators.maxLength(kPasswordMaxLength),
]);

class FormFields extends StatelessWidget {
  const FormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthVm vm = AuthVm.provider.of(context);
    final isSignIn = vm.isSignIn;
    final isSubmitting = vm.isSubmitting;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Show(
          when: () => !isSignIn.value,
          builder: (context) => Column(
            crossAxisAlignment: .stretch,
            children: [
              const Text('Nombre personal'),
              const SizedBox(height: 8),
              FormBuilderField(
                name: 'name',
                builder: (field) => SignalBuilder(
                  builder: (context, child) => TextFormBox(
                    enabled: !isSubmitting.value,
                    validator: nameValidators,
                    onChanged: field.didChange,
                    onFieldSubmitted: vm.fieldSubmit,
                  ),
                ),
              ),
              const SizedBox(height: 22),
            ],
          ),
        ),

        const Text('Nombre de usuario'),
        const SizedBox(height: 8),

        FormBuilderField(
          name: 'username',
          autovalidateMode: .always,
          builder: (field) => SignalBuilder(
            builder: (context, child) => TextFormBox(
              enabled: !isSubmitting.value,
              validator: (t) {
                vm.invalidUsernameMsg.value = null;
                final String? error = usernameValidators(t);
                return error;
              },
              onChanged: field.didChange,
              onFieldSubmitted: vm.fieldSubmit,
            ),
          ),
        ),

        Show(
          when: () => vm.invalidUsernameMsg.value != null,
          builder: (context) {
            return ExternalError(text: vm.invalidUsernameMsg.value!);
          },
        ),

        const SizedBox(height: 22),

        const Text('Contraseña'),
        const SizedBox(height: 8),

        FormBuilderField(
          name: 'password',
          builder: (field) => SignalBuilder(
            builder: (context, child) => PasswordFormBox(
              enabled: !isSubmitting.value,
              revealMode: .peekAlways,
              // no "onChanged", so use validator instead
              validator: (t) {
                vm.invalidPasswordMsg.value = null;
                final String? error = passwordValidators(t);
                field.didChange(t);
                return error;
              },
              onFieldSubmitted: vm.fieldSubmit,
            ),
          ),
        ),

        Show(
          when: () => vm.invalidPasswordMsg.value != null,
          builder: (context) {
            return ExternalError(text: vm.invalidPasswordMsg.value!);
          },
        ),
      ],
    );
  }
}
