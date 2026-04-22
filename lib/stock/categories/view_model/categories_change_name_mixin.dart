import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/stock/categories/categories_constants.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_table_mixin.dart';
import 'package:servicable_stock/stock/categories/categories_types.dart';
import 'package:trina_grid/trina_grid.dart';

mixin ChangeNameMixin on TableMixin {
  CategoriesChangeNameMutation createChangeNameMutation(BuildContext context) =>
      useMutation(
        (event, _) async {
          if (!hasPerm(context, .operator)) {
            return Future.error('No tienes permiso para editar categorías');
          }

          final int id = event.row.$id!;
          final newName = event.value;

          await service.updateCategoryName(id, newName);
        },

        onMutate: (event, _) {
          stateManager!.setEditing(false); // important! prevents crashing

          final field = CategoryTableColumns.updatedAt.name;

          final previousUpdatedAt = event.row.cellValue<DateTime>(field);

          event.row.cells[field] = TrinaCell(value: DateTime.now());

          return previousUpdatedAt;
        },

        onError: (error, event, previousUpdatedAt, _) {
          showMutationResultMsg(
            context: context,
            message: error.toString(),
            severity: .error,
          );

          try {
            event.cell.value = event.oldValue;

            final createdAt = event.row.cellValue<DateTime>(
              CategoryTableColumns.createdAt.name,
            );

            event.row.cells[CategoryTableColumns.updatedAt.name] =
                getUpdatedAtCell(createdAt, previousUpdatedAt!);
          } catch (e) {
            print(e);
          }
        },

        onSuccess: (_, event, _, ctx) {
          showMutationResultMsg(
            context: context,
            message: 'Nombre actualizado',
            severity: .success,
          );

          ctx.client.setQueryData<CategoriesList, dynamic>(
            kCategoriesQueryKey,
            (cats) {
              final int id = event.row.$id!;

              for (var i = 0; i < cats!.length; i++) {
                final cat = cats[i];

                if (cat.id == id) {
                  cats[i] = cat.copyWith(
                    name: event.value,
                    updatedAt: event.row.cellValue<DateTime>(
                      CategoryTableColumns.updatedAt.name,
                    ),
                  );

                  return cats;
                }
              }

              return cats;
            },
          );
        },
      );
}
