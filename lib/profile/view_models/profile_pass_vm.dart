import 'package:disco/disco.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/profile/profile_constants.dart';
import 'package:servicable_stock/profile/profile_types.dart';
import 'package:servicable_stock/profile/services/profile_pass_service.dart';
import 'package:servicable_stock/shared/form_with_async_validation.dart';

class ProfilePassVm
    extends FormWithAsyncValidation<UpdatePassInput, UpdatePassMutation> {
  ProfilePassVm(this.service, this.authState);

  final ProfilePassService service;
  final AuthState authState;

  static final instance = Provider((ctx) {
    final db = AppDatabase.instance.of(ctx);
    final authState = AuthState.instance.of(ctx);

    final service = ProfilePassService(
      db,
      currentId: authState.user!.id,
      table: db.users,
    );

    return ProfilePassVm(service, authState);
  });

  @override
  checkAsyncErrorsBeforeSubmit() async {
    final passValue = getValue<String>(
      ProfilePassFormFields.currentPassword.name,
    );

    final isValid = await service.checkPassword(
      newPassword: passValue,
      hashedPassword: authState.user!.password,
      encodedSalt: authState.user!.salt,
    );

    if (!isValid) {
      formKey.currentState!.fields[ProfilePassFormFields.currentPassword.name]!
          .invalidate('La contraseña es incorrecta', shouldFocus: false);
    }

    return !isValid;
  }

  @override
  getFormData() => getValue<String>(ProfilePassFormFields.newPassword.name);
}
