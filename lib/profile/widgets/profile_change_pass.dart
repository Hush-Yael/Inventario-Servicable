import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/profile/profile_constants.dart';
import 'package:servicable_stock/profile/view_models/profile_pass_vm.dart';
import 'package:servicable_stock/shared/widgets/form/field.dart';
import 'package:servicable_stock/shared/widgets/form/submit_btn_ring.dart';

class ChangePass extends HookWidget {
  const ChangePass({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = ProfilePassVm.instance.of(context);
    final authState = AuthState.instance.of(context);

    final currentPassController = useTextEditingController();
    final confirmPassController = useTextEditingController();
    final newPassController = useTextEditingController();

    vm.mutation = useMutation(
      (input, _) async => await vm.repository.updateCurrentPassword(input),
      onError: (error, variables, onMutateResult, _) {
        showMsg(context: context, message: error.toString(), severity: .error);
      },
      onSuccess: (user, variables, onMutateResult, _) {
        showMsg(
          context: context,
          message: 'Contraseña actualizada',
          severity: .success,
        );

        vm.formKey.currentState!.validate();

        currentPassController.text = '';
        newPassController.text = '';
        confirmPassController.text = '';

        authState.setUser(user);
      },
    );

    void changePass() {
      final value = (currentPassController.text);

      vm.changeAndClearAsyncError(
        value,
        vm.formKey.currentState!.fields[ProfilePassFormFields
            .currentPassword
            .name]!,
      );
    }

    useEffect(() {
      currentPassController.addListener(changePass);

      return () => currentPassController.removeListener(changePass);
    }, [currentPassController]);

    return FormBuilder(
      key: vm.formKey,
      child: Column(
        spacing: 34,
        crossAxisAlignment: .start,
        children: [
          PasswordField(
            field: ProfilePassFormFields.currentPassword.name,
            controller: currentPassController,
            label: 'Contraseña actual',
            validator: (v, field) => vm.fieldSyncAndAsyncValidation(
              field,
              validator: AuthValidators.password,
            ),
          ),

          PasswordField(
            field: ProfilePassFormFields.newPassword.name,
            controller: newPassController,
            label: 'Nueva contraseña',
            validator: (v, field) => AuthValidators.password(v),
          ),

          PasswordField(
            field: ProfilePassFormFields.confirmNewPassword.name,
            controller: confirmPassController,
            label: 'Confirmar contraseña',
            validator: (v, field) {
              if (v != null && v != newPassController.text) {
                return 'Las contraseñas no coinciden';
              }

              return AuthValidators.password(v);
            },
          ),

          Align(
            alignment: .bottomRight,
            child: SignalBuilder(
              builder: (context, child) => FilledButton(
                onPressed: !vm.enabled ? null : () => vm.submit(context),
                child: Row(
                  mainAxisSize: .min,
                  spacing: 10,
                  children: [
                    if (vm.isSubmitting.value) const SubmitBtnRing(size: 14),
                    const Text('Cambiar contraseña'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  final String field;
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String? value, FormFieldState<String?> field)?
  validator;

  const PasswordField({
    super.key,
    required this.field,
    required this.label,
    this.validator,
    this.controller,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final vm = ProfilePassVm.instance.of(context);

    return Field<String>(
      field,
      label: label,
      initialValue: initialValue,
      valueTransformer: (value) => value?.trim(),
      childBuilder: (field) {
        return SignalBuilder(
          builder: (context, child) => PasswordFormBox(
            enabled: vm.enabled,
            controller: controller,
            initialValue: controller != null ? null : field.value,
            autovalidateMode: .onUserInteraction,
            onFieldSubmitted: (v) => vm.submit(context),
            validator: validator != null
                ? (value) => validator!(value, field)
                : AuthValidators.password,
            onSaved: field.didChange,
          ),
        );
      },
    );
  }
}
