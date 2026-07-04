import 'package:drift/drift.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/shared/fn/mutations/index.dart';
import 'package:servicable_stock/shared/shared_types.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:servicable_stock/stock/products/view_model/products_table_mixin.dart';

mixin UpdateMutationsMixin on TableMixin {
  SingleUpdateMutation _createUpdateMutation(
    BuildContext context, {
    required String msgPropName,
    msgPropNameVocal = 'o',
    required String prop,
    required SingleUpdateMutationCb updateFn,
    SingleUpdateMutationSideEffect onSuccess,
  }) => createSingleUpdateMutation(
    .new(
      context,
      queryKey: kProductsQueryKey,
      successName: msgPropName,
      unauthPluralName: 'productos',
      getStateManager: getStateManager,
      successMsgVocal: msgPropNameVocal,
      cb: updateFn,
      timestamped: false,
      onSuccess: onSuccess,
    ),
    propName: prop,
  );

  SingleUpdateMutation createChangeCategoryMutation(BuildContext context) {
    return _createUpdateMutation(
      context,
      msgPropName: 'categoría',
      msgPropNameVocal: 'a',
      prop: ProductTableColumns.category.name,
      updateFn: (id, newCategory, [ctx]) async {
        return repository.changeProductCategoryId(
          id,
          _getCategoryId(ctx!, newCategory),
        );
      },
      // update category name and id
      onSuccess: (event, ctx) {
        ctx.client.setQueryData<ProductsList, dynamic>(kProductsQueryKey, (
          list,
        ) {
          final id = event.row.$id;

          if (list != null && id != null) {
            for (int i = 0; i < list.length; i++) {
              final product = list[i];

              if (product.id == id) {
                product.copyWith(
                  categoryName: event.value as String,
                  categoryId: Value(_getCategoryId(ctx, event.value as String)),
                );

                list[i] = product;
                return list;
              }
            }
          }

          return list;
        });
      },
    );
  }

  int _getCategoryId(MutationFunctionContext ctx, String categoryName) {
    final categoryOptions = ctx.client.getQueryData<TableForeignKeyOptions>(
      kProductsCategoryOptionsQueryKey,
    );

    return categoryOptions!.firstWhere((opt) => opt.label == categoryName).id;
  }

  SingleUpdateMutation createChangeCodeMutation(BuildContext context) =>
      _createUpdateMutation(
        context,
        msgPropName: 'código',
        prop: ProductTableColumns.code.name,
        updateFn: (id, newCode, [ctx]) =>
            repository.changeProductCode(id, newCode),
      );

  SingleUpdateMutation createRenameMutation(BuildContext context) =>
      _createUpdateMutation(
        context,
        msgPropName: 'nombre',
        prop: ProductTableColumns.name.name,
        updateFn: (id, newName, [ctx]) => repository.renameProduct(id, newName),
      );

  SingleUpdateMutation createChangeUnitsMutation(BuildContext context) =>
      _createUpdateMutation(
        context,
        msgPropName: 'unidades',
        msgPropNameVocal: 'as',
        prop: ProductTableColumns.units.name,
        updateFn: (id, newUnits, [ctx]) =>
            repository.changeProductUnits(id, newUnits),
      );
}
