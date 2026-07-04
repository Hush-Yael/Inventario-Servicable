import 'dart:math';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:servicable_stock/stock/products/view_model/products_vm.dart';
import 'package:servicable_stock/shared/fn/mutations/index.dart';
import 'package:trina_grid/trina_grid.dart';

mixin DeleteMutationMixin on ProductsBaseVm {
  SingleDeleteMutation createDeleteMutation(BuildContext context) =>
      createSingleDeleteMutation(
        .new(
          context,
          cb: repository.deleteProduct,
          successName: 'producto',
          unauthPluralName: 'productos',
          queryKey: kProductsQueryKey,
          getStateManager: getStateManager,
          onMutate: (columnCtx, ctx) => _changeCounts(columnCtx, ctx, false),
          onError: (columnCtx, ctx) => _changeCounts(columnCtx, ctx, true),
          timestamped: false,
        ),
        isAdmin: isAdmin,
      );

  void _changeCounts(
    TrinaColumnRendererContext columnCtx,
    MutationFunctionContext ctx,
    bool add,
  ) {
    final hasCategory =
        columnCtx.row.metadata?[ProductMetaKeys.categoryId.name] != null;

    ctx.client.setQueryData<ProductCountsByCategory, dynamic>(
      kProductCountsQueryKey,
      (prev) {
        if (prev != null) {
          return (
            noCategory: !hasCategory
                ? max(0, prev.noCategory + (add ? 1 : -1))
                : prev.noCategory,
            withCategory: hasCategory
                ? max(0, prev.withCategory + (add ? 1 : -1))
                : prev.withCategory,
          );
        }

        return prev;
      },
    );
  }
}
