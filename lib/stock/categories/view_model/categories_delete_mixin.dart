import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/utils/fn.dart' show showMutationResultMsg;
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/stock/categories/categories_constants.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_vm.dart';
import 'package:servicable_stock/stock/categories/categories_types.dart';

mixin DeleteMixin on CategoriesBaseVm {
  CategoriesDeleteMutation createDeleteMutation(BuildContext context) =>
      useMutation(
        (ctx, _) async {
          if (!isAdmin) {
            return Future.error('No tienes permiso para eliminar categorías');
          }

          /* return await Future.delayed(const Duration(seconds: 1), () {
            // return Future.error('error');
          }); */

          final id = ctx.row.$id!;
          return await service.deleteCategory(id);
        },

        onMutate: (ctx, _) {
          final rows = stateManager!.refRows;
          final id = ctx.row.$id!;

          for (var i = 0; i < rows.length; i++) {
            final row = rows[i];

            if (row.$id == id) {
              rows.removeAt(i);
              return i - 1;
            }
          }

          return rows.length - 2;
        },

        onError: (error, ctx, beforeIndex, _) {
          showMutationResultMsg(
            context: context,
            message: error.toString(),
            severity: .error,
          );

          try {
            stateManager!.refRows.insert(beforeIndex! + 1, ctx.row);
          } catch (e) {
            print(e);
            rethrow;
          }
        },

        onSuccess: (_, event, _, ctx) {
          showMutationResultMsg(
            context: context,
            message: 'Categoría eliminada',
            severity: .success,
          );

          ctx.client.setQueryData<CategoriesList, dynamic>(
            kCategoriesQueryKey,
            (cats) {
              final id = event.row.$id!;

              cats!.removeWhere((cat) => cat.id == id);

              return cats;
            },
          );
        },
      );
}
