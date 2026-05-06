import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/view_model/auth_vm.dart';
import 'package:servicable_stock/auth/widgets/external_error.dart';
import 'package:servicable_stock/shared/widgets/field.dart';

class FormFields extends StatelessWidget {
  const FormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthVm vm = AuthVm.instance.of(context);
    final isSignIn = vm.isSignIn;
    final isSubmitting = vm.isSubmitting;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Show(
          when: () => !isSignIn.value,
          builder: (context) {
            return Field(
              'name',
              label: 'Nombre personal',
              childBuilder: (field) {
                return Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    SignalBuilder(
                      builder: (context, child) => TextFormBox(
                        autovalidateMode: .onUserInteraction,
                        enabled: !isSubmitting.value,
                        validator: nameValidators,
                        onChanged: field.didChange,
                        onFieldSubmitted: vm.fieldSubmit,
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],
                );
              },
            );
          },
        ),

        Field(
          'username',
          label: 'Nombre de usuario',
          childBuilder: (field) {
            return SignalBuilder(
              builder: (context, child) => TextFormBox(
                autovalidateMode: .onUserInteraction,
                enabled: !isSubmitting.value,
                validator: (t) {
                  vm.invalidUsernameMsg.value = null;
                  final String? error = usernameValidators(t);
                  return error;
                },
                onChanged: field.didChange,
                onFieldSubmitted: vm.fieldSubmit,
              ),
            );
          },
        ),

        Show(
          when: () => vm.invalidUsernameMsg.value != null,
          builder: (context) {
            return ExternalError(text: vm.invalidUsernameMsg.value!);
          },
        ),

        const SizedBox(height: 22),

        Field(
          'password',
          label: 'Contraseña',
          childBuilder: (field) {
            return SignalBuilder(
              builder: (context, child) => PasswordFormBox(
                autovalidateMode: .onUserInteraction,
                enabled: !isSubmitting.value,
                onFieldSubmitted: vm.fieldSubmit,
                revealMode: .peekAlways,
                // no "onChanged", so use validator instead
                validator: (t) {
                  vm.invalidPasswordMsg.value = null;
                  final String? error = passwordValidators(t);
                  field.didChange(t);
                  return error;
                },
              ),
            );
          },
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
