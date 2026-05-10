import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/shared/fn/mutations/single_update.dart';
import 'package:servicable_stock/stock/units/units_constants.dart';
import 'package:servicable_stock/stock/units/units_types.dart';
import 'package:servicable_stock/stock/units/view_model/units_table_mixin.dart';
import 'package:trina_grid/trina_grid.dart';

mixin UpdateMutationsMixin on TableMixin {
  SingleUpdateMutation createChangeIdentifier(BuildContext context) =>
      createSingleUpdateMutation(
        sharedMutParams(
          context,
          cb: (id, newIdentifier, [ctx]) =>
              service.changeUnitIdentifier(id, newIdentifier),
          msgSuccessName: 'identificador',
        ),
        propName: UnitsTableColumns.identifier.name,
      );

  SingleUpdateMutation createChangeSoldTo(BuildContext context) =>
      createSingleUpdateMutation(
        sharedMutParams(
          context,
          cb: (id, newIdentifier, [ctx]) =>
              service.changeUnitSoldTo(id, newIdentifier),
          msgSuccessName: 'adquiriente',
        ),
        propName: UnitsTableColumns.soldTo.name,
      );

  SingleUpdateMutation createChangeProduct(BuildContext context) =>
      createSingleUpdateMutation(
        sharedMutParams(
          context,
          msgSuccessName: 'producto asociado',
          cb: (id, newPrice, [ctx]) => service.changeUnitProduct(id, newPrice),
          // update category name as well
          onSuccess: (event, ctx) {
            final productOptions = ctx.client
                .getQueryData<ProductForeignKeyOptions>(
                  kUnitsProductOptionsQueryKey,
                );

            if (productOptions == null || productOptions.isEmpty) return;

            final newProduct = event.value;

            final product = productOptions.firstWhere(
              (p) => p.label == newProduct,
            );

            event.row.metadata![UnitsMetaKeys.productId.name] = product.id;

            event.row.cells[UnitsTableColumns.category.name] = TrinaCell(
              value: product.categoryName ?? '',
            );
          },
        ),
        propName: UnitsTableColumns.product.name,
      );

  SingleUpdateMutation createChangeDetails(BuildContext context) =>
      createSingleUpdateMutation(
        sharedMutParams(
          context,
          cb: (id, newDetails, [ctx]) =>
              service.changeUnitDetails(id, newDetails),
          msgSuccessName: 'detalles',
        ),
        propName: UnitsTableColumns.details.name,
      );
}
