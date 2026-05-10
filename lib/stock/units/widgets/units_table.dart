import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/shared/shared_constants.dart';
import 'package:servicable_stock/shared/widgets/card_wrapper.dart';
import 'package:servicable_stock/shared/widgets/table.dart';
import 'package:servicable_stock/stock/units/units_constants.dart';
import 'package:servicable_stock/stock/units/units_types.dart';
import 'package:servicable_stock/stock/units/view_model/units_vm.dart';
import 'package:trina_grid/trina_grid.dart';

class UnitsTable extends HookWidget {
  final UnitsQuery query;
  const UnitsTable(this.query, {super.key});

  @override
  Widget build(BuildContext context) {
    final vm = UnitsVm.instance.of(context);

    final productNames = useQuery(
      kProductNamesQueryKey,
      vm.service.getProductNames,
    );

    const ProductForeignKeyOptions emptyList = [];

    return QueryTable(
      query,
      errorMsg: 'Error al obtener las unidades',
      config: getTrinaBaseConfig(context),
      loaderColumns: vm.getColumns(context, 0, null, productNames: emptyList),
      renderGrid: (list, config, canEdit) {
        final deleteMutation = vm.createDeleteMutation(context);
        final changeIdentifierMutation = vm.createChangeIdentifier(context);
        final changeProductMutation = vm.createChangeProduct(context);
        final changeSoldToMutation = vm.createChangeSoldTo(context);
        final changeDetailsMutation = vm.createChangeDetails(context);

        return CardWrapper(
          TrinaGrid(
            rows: vm.getRows(list!),
            columns: vm.getColumns(
              context,
              list.length,
              deleteMutation,
              productNames: productNames.data ?? emptyList,
            ),
            configuration: config,
            onLoaded: (event) {
              final stateManager = event.stateManager;
              vm.setStateManager(stateManager);
              stateManager.setShowColumnFilter(true);
            },
            onBeforeActiveCellChange: (event) {
              if (!canEdit) return false;

              final field = event.newCell.column.field;

              return field != UnitsTableColumns.category.name;
            },
            onChanged: (event) {
              final field = UnitsTableColumns.values.byName(event.column.field);

              switch (field) {
                case .identifier:
                  changeIdentifierMutation.mutate(event);
                case .product:
                  changeProductMutation.mutate(event);
                case .soldTo:
                  changeSoldToMutation.mutate(event);
                case .details:
                  changeDetailsMutation.mutate(event);
                default:
                  break;
              }
            },
          ),
        );
      },
    );
  }
}
