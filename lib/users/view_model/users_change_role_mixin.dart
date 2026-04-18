import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/users/users_constants.dart';
import 'package:servicable_stock/users/users_types.dart';
import 'package:servicable_stock/users/view_model/users_table_mixin.dart';

mixin ChangeRoleMutationMixin on TableMixin {
  ChangeRoleMutation createChangeRoleMutation(BuildContext context) {
    return useMutation(
      (role, _) async {
        return await service.changeUsersRole(role, getIdsFromSelected);
      },

      onMutate: (role, _) {
        try {
          final users = selectedRows;

          final prevRoles = users
              .map(
                (row) => (
                  id: row.metadata?['id'] as int,
                  role: row.cells[UsersTableColumns.role.name]?.value as String,
                ),
              )
              .toList();

          for (var row in users) {
            row.cells[UsersTableColumns.role.name]?.value = role.label;
          }

          stateManager!.notifyListeners();

          return prevRoles;
        } catch (e) {
          print(e);
          rethrow;
        }
      },

      onError: (error, role, prevRoles, _) {
        showMutationResultMsg(
          context: context,
          message: 'No se pudieron cambiar los roles',
          severity: .error,
        );

        try {
          for (var user in selectedRows) {
            final int id = user.metadata?['id'];

            final int changedUserIndex = prevRoles!.indexWhere(
              (prevUser) => prevUser.id == id,
            );

            if (changedUserIndex >= 0) {
              user.cells[UsersTableColumns.role.name]?.value =
                  prevRoles[changedUserIndex].role;
              // reduce prevUsers length to optimize searching next time
              prevRoles.removeAt(changedUserIndex);
            }
          }

          stateManager!.notifyListeners();
        } catch (e) {
          print(e);
        }
      },

      onSuccess: (data, role, prevRoles, ctx) {
        showMutationResultMsg(
          context: context,
          message: 'Roles cambiados',
          severity: .success,
        );

        ctx.client.setQueryData<UsersList, dynamic>(kUserTableQueryKey, (
          users,
        ) {
          for (var i = 0; i < users!.length; i++) {
            final user = users[i];

            final int changedRoleIndex = prevRoles!.indexWhere(
              (prevUser) => prevUser.id == user.id,
            );

            if (changedRoleIndex >= 0) {
              // reduce prevUsers length to optimize searching next time
              prevRoles.removeAt(changedRoleIndex);
              users[i] = user.copyWith(role: role);
            }
          }

          return users;
        });
      },
    );
  }
}
