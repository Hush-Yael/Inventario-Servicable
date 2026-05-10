import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/shared/fn/mutations/index.dart';
import 'package:servicable_stock/shared/shared_constants.dart';
import 'package:servicable_stock/shared/shared_types.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:servicable_stock/stock/products/products_models.dart';
import 'package:servicable_stock/stock/products/view_model/products_table_mixin.dart';

mixin AddMixin on TableMixin {
  ProductsAddMutation createAddMutation(BuildContext context) =>
      createSingleAddMutation(
        .new(
          context,
          queryKey: kProductsQueryKey,
          timestamped: false,
          getStateManager: getStateManager,
          objName: 'producto',
          objPluralName: 'productos',
          cb: service.addProduct,
        ),
        createRow: createRow,
        createNewObj: (variables, ctx) {
          final (:name, :code, :units, :usesDetailedUnits, :categoryId) =
              variables;

          final categoryNames = ctx.client.getQueryData<TableForeignKeyOptions>(
            kCategoryNamesQueryKey,
          );

          final categoryName = categoryNames
              ?.firstWhere((c) => c!.id == categoryId)!
              .label;

          return ProductWithDetails(
            id: -1,
            name: name,
            code: code,
            units: 0,
            usesDetailedUnits: usesDetailedUnits,
            categoryName: categoryName,
            categoryId: categoryId,
          );
        },
      );
}
