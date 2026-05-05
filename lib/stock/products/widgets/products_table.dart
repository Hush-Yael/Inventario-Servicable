import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/utils/fn.dart' as utils;
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/shared/shared_constants.dart';
import 'package:servicable_stock/shared/widgets/table.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:servicable_stock/stock/products/view_model/products_vm.dart';
import 'package:servicable_stock/shared/widgets/card_wrapper.dart';
import 'package:trina_grid/trina_grid.dart';

class ProductsTable extends HookWidget {
  final ProductsQuery query;

  const ProductsTable(this.query, {super.key});

  @override
  Widget build(BuildContext context) {
    final vm = ProductsVm.instance.of(context);

    final categoryNamesQuery = useQuery(
      kCategoryNamesQueryKey,
      (_) => vm.service.fetchCategoryNames(),
    );

    return QueryTable(
      query,
      errorMsg: 'Error al obtener los productos',
      config: getTrinaBaseConfig(context),
      loaderColumns: vm.getColumns(
        context,
        null,
        listLength: 0,
        categoryNames: const [],
      ),
      renderGrid: (data) {
        final canEdit = utils.hasPerm(context, .operator);

        final deleteMutation = vm.createDeleteMutation(context);
        final renameMutation = vm.createRenameMutation(context);
        final changeCategoryMutation = vm.createChangeCategoryMutation(context);
        final changeCodeMutation = vm.createChangeCodeMutation(context);
        final changeUnitsMutation = vm.createChangeUnitsMutation(context);

        return CardWrapper(
          TrinaGrid(
            configuration: getTrinaBaseConfig(
              context,
            ).copyWith(columnFilter: .new(debounceMilliseconds: 500)),
            columns: vm.getColumns(
              context,
              deleteMutation,
              listLength: 0,
              categoryNames: categoryNamesQuery.data ?? [],
            ),
            rows: vm.getRows(data!),
            onLoaded: (event) {
              vm.setStateManager(event.stateManager);
              event.stateManager.setShowColumnFilter(true);
            },
            onChanged: (event) {
              final field = ProductTableColumns.values.byName(
                event.column.field,
              );

              switch (field) {
                case ProductTableColumns.name:
                  renameMutation.mutate(event);
                case ProductTableColumns.category:
                  changeCategoryMutation.mutate(event);
                case ProductTableColumns.code:
                  changeCodeMutation.mutate(event);
                case ProductTableColumns.units:
                  // for some reason it crashes if called fully synchronously
                  Future.microtask(() => changeUnitsMutation.mutate(event));
                default:
                  break;
              }
            },
            onBeforeActiveCellChange: (event) {
              if (!canEdit) return false;

              final field = event.newCell.column.field;

              // can't edit stock when product uses units
              if (field == ProductTableColumns.units.name) {
                return event.newCell.row.metadata?[ProductMetaKeys
                        .usesDetailedUnits
                        .name] !=
                    true;
              }

              return field != kActionsColumnName && field != kIndexColumnField;
            },
          ),
        );
      },
    );
  }
}
