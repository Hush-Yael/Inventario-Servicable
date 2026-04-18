import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/users/users_constants.dart';
import 'package:servicable_stock/users/users_types.dart';
import 'package:servicable_stock/users/view_model/users_table_mixin.dart';

mixin DeleteMutationMixin on TableMixin {
  DeleteMutation createDeleteMutation(BuildContext context) {
    return useMutation(
      (values, _) async {
        return await service.deleteUsers(getIdsFromSelected);
      },

      onMutate: (variables, _) {
        final ids = [...getIdsFromSelected];
        stateManager!.removeRows(selectedRows);

        selectAllCheckedValue.value = false;

        return ids;
      },

      onError: (error, variables, deletedIds, ctx) {
        showMutationResultMsg(
          context: context,
          message: 'Error al eliminar los usuarios',
          severity: .error,
        );

        try {
          final prevRows = getRows(
            context,
            ctx.client.getQueryData(kUserTableQueryKey),
          );

          stateManager!.refRows.clear();
          stateManager!.refRows.addAll(prevRows);
          stateManager!.notifyListeners();
        } catch (e) {
          print(e);
          rethrow;
        }
      },

      onSuccess: (data, variables, deletedIds, ctx) {
        showMutationResultMsg(
          context: context,
          message: 'Usuarios eliminados',
          severity: .success,
        );

        ctx.client.setQueryData<UsersList, dynamic>(kUserTableQueryKey, (
          usersList,
        ) {
          usersList!.removeWhere((user) {
            final int index = deletedIds!.indexOf(user.id);
            final bool found = index >= 0;

            // reduce deletedIds length to optimize searching next time
            if (found) deletedIds.removeAt(index);

            return found;
          });

          return usersList;
        });
      },
    );
  }
}
