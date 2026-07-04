import 'package:disco/disco.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/profile/profile_constants.dart';
import 'package:servicable_stock/profile/profile_types.dart';
import 'package:servicable_stock/profile/repositories/profile_pass_repo.dart';
import 'package:servicable_stock/shared/form_with_async_validation.dart';

class ProfilePassVm
    extends FormWithAsyncValidation<UpdatePassInput, UpdatePassMutation> {
  ProfilePassVm(this.repository, this.authState);

  final ProfilePassRepository repository;
  final AuthState authState;

  static final instance = Provider((ctx) {
    final db = AppDatabase.instance.of(ctx);
    final authState = AuthState.instance.of(ctx);

    final repository = ProfilePassRepository(
      db,
      currentId: authState.user!.id,
      table: db.users,
    );

    return ProfilePassVm(repository, authState);
  });

  @override
  checkAsyncErrorsBeforeSubmit() async {
    final passValue = getValue<String>(
      ProfilePassFormFields.currentPassword.name,
    );

    final isValid = await repository.checkPassword(
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
