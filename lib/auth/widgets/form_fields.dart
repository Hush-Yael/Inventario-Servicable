import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/view_model/auth_vm.dart';
import 'package:servicable_stock/shared/widgets/field.dart';

class FormFields extends HookWidget {
  const FormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthVm vm = AuthVm.instance.of(context);

    final usernameController = vm.useAsyncValidationController(
      vm.checkUsername,
    );

    final passwordController = useTextEditingController();

    void changePass() {
      final value = (passwordController.text);

      vm.changeAndClearAsyncError(value, vm.password);
    }

    useEffect(() {
      passwordController.addListener(changePass);

      return () => passwordController.removeListener(changePass);
    }, [passwordController]);

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Show(
          when: () => !vm.isSignIn.value,
          builder: (context) {
            return Field<String>(
              AuthFormFields.name.name,
              label: 'Nombre personal',
              childBuilder: (field) {
                return Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    SignalBuilder(
                      builder: (context, child) => TextFormBox(
                        autovalidateMode: .onUserInteraction,
                        initialValue: field.value,
                        enabled: vm.enabled,
                        validator: AuthValidators.nameValidators,
                        onChanged: field.didChange,
                        onFieldSubmitted: vm.submit,
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],
                );
              },
            );
          },
        ),

        Field<String>(
          AuthFormFields.username.name,
          label: 'Nombre de usuario',
          childBuilder: (field) {
            return SignalBuilder(
              builder: (context, child) => TextFormBox(
                controller: usernameController,
                autovalidateMode: .onUserInteraction,
                enabled: vm.enabled,
                validator: (value) => vm.fieldSyncAndAsyncValidation(
                  field,
                  validator: AuthValidators.usernameValidators,
                ),
                onChanged: (v) => vm.changeAndClearAsyncError(v, field),
                onFieldSubmitted: vm.submit,
              ),
            );
          },
        ),

        const SizedBox(height: 22),

        Field<String>(
          AuthFormFields.password.name,
          label: 'Contraseña',
          childBuilder: (field) {
            return SignalBuilder(
              builder: (context, child) => PasswordFormBox(
                controller: passwordController,
                autovalidateMode: .onUserInteraction,
                enabled: vm.enabled,
                onFieldSubmitted: vm.submit,
                revealMode: .peekAlways,
                onSaved: field.didChange,
                validator: (value) => vm.fieldSyncAndAsyncValidation(
                  field,
                  validator: AuthValidators.passwordValidators,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
