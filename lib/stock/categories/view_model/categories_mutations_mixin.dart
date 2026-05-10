import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/shared/fn/mutations/index.dart';
import 'package:servicable_stock/stock/categories/categories_constants.dart';
import 'package:servicable_stock/stock/categories/categories_models.dart';
import 'package:servicable_stock/stock/categories/categories_types.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_table_mixin.dart';

mixin MutationsMixin on TableMixin {
  CategoriesAddMutation createAddMutation(BuildContext context) =>
      createSingleAddMutation(
        _params(context, service.addCategory),
        createRow: createRow,
        createNewObj: (name, ctx) {
          final now = DateTime.now();

          return CategoryWithCounts(
            id: -1,
            createdAt: now,
            updatedAt: now,
            name: name,
            productCount: 0,
            unitCount: 0,
          );
        },
      );

  SingleUpdateMutation createChangeNameMutation(BuildContext context) =>
      createSingleUpdateMutation(
        _params(
          context,
          (id, newName, [ctx]) => service.updateCategoryName(id, newName),
        ),
        propName: CategoryTableColumns.name.name,
      );

  SingleDeleteMutation createDeleteMutation(BuildContext context) =>
      createSingleDeleteMutation(
        _params(context, service.deleteCategory),
        isAdmin: isAdmin,
      );

  MutationCommonParams<C, S> _params<C extends Function, S extends Function>(
    BuildContext context,
    C cb,
  ) => .new(
    context,
    queryKey: kCategoriesQueryKey,
    getStateManager: getStateManager,
    successName: 'categoría',
    unauthPluralName: 'categorías',
    successMsgVocal: 'a',
    cb: cb,
    timestamped: true,
  );
}
