import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/utils/fn.dart'
    show hasPerm, showMutationResultMsg;
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/stock/categories/categories_constants.dart';
import 'package:servicable_stock/stock/categories/categories_models.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_table_mixin.dart';
import 'package:servicable_stock/stock/categories/categories_types.dart';

mixin AddMixin on TableMixin {
  CategoriesAddMutation createAddMutation(BuildContext context) => useMutation(
    (String name, _) async {
      if (!hasPerm(context, .operator)) {
        return Future.error('No tienes permiso para añadir categorías');
      }

      /* await Future.delayed(const Duration(seconds: 1));
      return 11; */
      final newCat = await service.addCategory(name);
      return newCat.id;
    },

    onMutate: (name, a) {
      try {
        final state = stateManager!;

        final now = DateTime.now();

        final newCat = CategoryWithCounts(
          id: -1,
          createdAt: now,
          updatedAt: now,
          name: name,
          productCount: 0,
          unitCount: 0,
        );

        final newRow = createRow(state.refRows.length, newCat);

        state.insertRows(state.refRows.length, [newRow]);

        return (row: newRow, cat: newCat);
      } catch (e) {
        print(e);
        rethrow;
      }
    },

    onSuccess: (addedId, name, variables, ctx) {
      showMutationResultMsg(
        context: context,
        message: 'Categoría añadida',
        severity: .success,
      );

      variables!.row.$id = addedId;

      ctx.client.setQueryData<CategoriesList, dynamic>(kCategoriesQueryKey, (
        list,
      ) {
        list!.add(variables.cat.copyWith(id: addedId));
        return list;
      });
    },

    onError: (error, name, variables, ctx) {
      showMutationResultMsg(
        context: context,
        message: error.toString(),
        severity: .error,
      );

      final state = stateManager!;

      state.refRows.remove(variables!.row);

      state.notifyListeners();
    },
  );
}
