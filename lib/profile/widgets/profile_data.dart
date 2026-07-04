import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/profile/profile_constants.dart';
import 'package:servicable_stock/profile/view_models/profile_data_vm.dart';
import 'package:servicable_stock/shared/widgets/form/field.dart';
import 'package:servicable_stock/shared/widgets/form/submit_btn_ring.dart';

class Data extends HookWidget {
  const Data({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = ProfileDataVm.instance.of(context);
    final authState = AuthState.instance.of(context);

    vm.mutation = useMutation(
      (input, _) async => await vm.repository.updateCurrentUser(input),
      onError: (error, variables, onMutateResult, _) {
        showMsg(context: context, message: error.toString(), severity: .error);
      },
      onSuccess: (user, variables, onMutateResult, _) {
        showMsg(
          context: context,
          message: 'Datos actualizados',
          severity: .success,
        );

        authState.setUser(user);
      },
    );

    final currentUserData = authState.user;

    final usernameController = vm.useAsyncValidationController(
      vm.checkUsername,
      initialValue: currentUserData!.username,
    );

    final nameController = useTextEditingController(text: currentUserData.name);

    final initialName = currentUserData.name;
    final initialUsername = currentUserData.username;

    return FormBuilder(
      key: vm.formKey,
      child: Column(
        spacing: 34,
        children: [
          Field<String>(
            ProfileDataFormFields.name.name,
            label: 'Nombre personal',
            initialValue: initialName,
            childBuilder: (field) {
              return SignalBuilder(
                builder: (context, child) => TextFormBox(
                  autovalidateMode: .onUserInteraction,
                  controller: nameController,
                  enabled: vm.enabled,
                  validator: AuthValidators.name,
                  onChanged: field.didChange,
                  onFieldSubmitted: (v) => vm.submit(context),
                ),
              );
            },
          ),

          Field(
            ProfileDataFormFields.username.name,
            label: 'Nombre de usuario',
            initialValue: initialUsername,
            childBuilder: (field) {
              return SignalBuilder(
                builder: (context, child) => TextFormBox(
                  controller: usernameController,
                  autovalidateMode: .onUserInteraction,
                  enabled: vm.enabled,
                  validator: (v) => vm.fieldSyncAndAsyncValidation(
                    field,
                    validator: AuthValidators.username,
                  ),
                  onChanged: (v) => vm.changeAndClearAsyncError(v, field),
                  onFieldSubmitted: (v) => vm.submit(context),
                ),
              );
            },
          ),

          SignalBuilder(
            builder: (context, child) => Row(
              spacing: 10,
              mainAxisAlignment: .end,
              children: [
                Button(
                  onPressed: !vm.enabled
                      ? null
                      : () {
                          vm.formKey.currentState!.reset();

                          nameController.text = initialName;

                          usernameController.text = initialUsername;
                        },
                  child: const Text('Descartar cambios'),
                ),

                FilledButton(
                  onPressed: !vm.enabled ? null : () => vm.submit(context),
                  child: Row(
                    spacing: 10,
                    children: [
                      if (vm.isSubmitting.value) const SubmitBtnRing(size: 14),
                      const Text('Actualizar información'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
