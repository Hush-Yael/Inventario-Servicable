import 'package:disco/disco.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/profile/profile_constants.dart';
import 'package:servicable_stock/profile/profile_types.dart';
import 'package:servicable_stock/profile/services/profile_data_service.dart';
import 'package:servicable_stock/shared/form_with_async_validation.dart';
import 'package:servicable_stock/core/db/db.dart';

class ProfileDataVm
    extends FormWithAsyncValidation<UpdateDataInput, UpdateDataMutation> {
  ProfileDataVm({required this.service});

  final ProfileDataService service;

  static final instance = Provider((ctx) {
    final db = AppDatabase.instance.of(ctx);
    final currentId = AuthState.instance.of(ctx).user!.id;

    return ProfileDataVm(
      service: ProfileDataService(db, table: db.users, currentId: currentId),
    );
  });

  @override
  Future<bool> checkAsyncErrorsBeforeSubmit() async {
    return await checkUsername(
      getValue<String>(ProfileDataFormFields.username.name),
    );
  }

  @override
  UpdateDataInput getFormData() {
    return (
      name: getValue<String>(ProfileDataFormFields.name.name),
      username: getValue<String>(ProfileDataFormFields.username.name),
    );
  }

  Future<bool> checkUsername(String text) async {
    final isError = await service.checkUserNameExists(text);

    if (isError) {
      formKey.currentState!.fields[ProfileDataFormFields.username.name]!
          .invalidate(
            'El nombre de usuario ya está en uso',
            shouldFocus: false,
          );
    }

    return isError;
  }
}
