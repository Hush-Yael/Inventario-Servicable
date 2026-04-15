import 'package:disco/disco.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/users/service/users_repository.dart';
import 'package:servicable_stock/users/service/users_service.dart';
// import 'package:servicable_stock/users/service/users_fake_service.dart';
import 'package:servicable_stock/users/users_types.dart';
import 'package:servicable_stock/users/view_model/users_delete_mixin.dart';
import 'package:servicable_stock/users/view_model/users_table_mixin.dart';
import 'package:servicable_stock/users/view_model/users_change_role_mixin.dart';

class UsersBaseVm {
  final UsersRepository service;
  final AuthState authState;

  UsersBaseVm({required this.service, required this.authState});

  late final Future<UsersList> Function() getUsers = service.fetchUsers;
}

class UsersVm extends UsersBaseVm
    with TableMixin, DeleteMutationMixin, ChangeRoleMutationMixin {
  UsersVm({required super.service, required super.authState});

  static final instance = Provider((ctx) {
    final AppDatabase db = AppDatabase.instance.of(ctx);
    final authState = AuthState.instance.of(ctx);
    final usersService = UsersService(db);
    // final usersService = FakeUsersService();

    return UsersVm(service: usersService, authState: authState);
  });
}
