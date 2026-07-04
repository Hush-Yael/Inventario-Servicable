import 'package:disco/disco.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/utils/fn.dart' as utils;
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/users/users_repository.dart';
import 'package:servicable_stock/users/users_types.dart';
import 'package:servicable_stock/users/view_model/users_delete_mixin.dart';
import 'package:servicable_stock/users/view_model/users_table_mixin.dart';
import 'package:servicable_stock/users/view_model/users_change_role_mixin.dart';

class UsersBaseVm with VmTrinaGridMixin {
  final UsersRepository repository;
  final AuthState authState;
  final bool isAdmin;

  UsersBaseVm({
    required this.repository,
    required this.authState,
    required this.isAdmin,
  });

  late final Future<UsersList> Function() getUsers = repository.fetchUsers;
}

class UsersVm extends UsersBaseVm
    with TableMixin, DeleteMutationMixin, ChangeRoleMutationMixin {
  UsersVm({
    required super.repository,
    required super.authState,
    required super.isAdmin,
  });

  static final instance = Provider((ctx) {
    final AppDatabase db = AppDatabase.instance.of(ctx);
    final authState = AuthState.instance.of(ctx);
    final usersRepository = UsersRepository(db, table: db.users);
    final bool isAdmin = utils.isAdmin(ctx);

    return UsersVm(
      repository: usersRepository,
      authState: authState,
      isAdmin: isAdmin,
    );
  });
}
