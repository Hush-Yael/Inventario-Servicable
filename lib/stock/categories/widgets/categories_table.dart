import 'package:fluent_ui/fluent_ui.dart' hide Title;
import 'package:flutter/material.dart' as m;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/shared/widgets/no_rows.dart';
import 'package:servicable_stock/shared/widgets/table.dart';
import 'package:servicable_stock/stock/categories/categories_constants.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_vm.dart';
import 'package:servicable_stock/stock/categories/categories_types.dart';
import 'package:servicable_stock/stock/categories/widgets/categories_see_btn.dart';
import 'package:trina_grid/trina_grid.dart';

class CategoriesTable extends HookWidget {
  final CategoriesQuery query;

  const CategoriesTable(this.query, {super.key});

  @override
  Widget build(BuildContext context) {
    final vm = CategoriesVm.instance.of(context);

    return QueryTable(
      query,
      errorMsg: 'Error al obtener las categorías',
      config: getTrinaBaseConfig(context),
      loaderColumns: getColumns(context, 0),
      renderGrid: (list, config) {
        final canEdit = hasPerm(context, .operator);

        final CategoriesDeleteMutation deleteMutation = vm.createDeleteMutation(
          context,
        );

        final changeNameMutation = vm.createChangeNameMutation(context);

        return TrinaGrid(
          rows: vm.getRows(list!),
          columns: getColumns(context, list.length, deleteMutation),
          onLoaded: (event) {
            vm.setStateManager(event.stateManager);
          },
          onChanged: (event) {
            if (event.column.field == CategoryTableColumns.name.name) {
              changeNameMutation.mutate(event);
            }
          },
          onBeforeActiveCellChange: (event) {
            return (canEdit &&
                event.newCell.column.field == CategoryTableColumns.name.name);
          },
          configuration: config,
          noRowsWidget: NoRows('categorías'),
        );
      },
    );
  }

  List<TrinaColumn> getColumns(
    BuildContext context,
    int listLength, [
    CategoriesDeleteMutation? deleteMutation,
  ]) => [
    indexColumn(listLength),

    TrinaColumn(
      field: CategoryTableColumns.name.name,
      type: .text(),
      title: 'Nombre',
      editCellRenderer:
          (
            defaultEditCellWidget,
            cell,
            controller,
            focusNode,
            handleSelected,
          ) => m.Card(
            color: Colors.transparent,
            elevation: 0,
            child: defaultEditCellWidget,
          ),
    ),

    TrinaColumn(
      field: CategoryTableColumns.createdAt.name,
      type: formattedDateColumnType,
      title: 'Fecha de creación',
      readOnly: true,
    ),

    TrinaColumn(
      field: CategoryTableColumns.updatedAt.name,
      type: formattedDateColumnType,
      title: 'Fecha de modificación',
      readOnly: true,
    ),

    TrinaColumn(
      title: 'Productos',
      field: CategoryTableColumns.products.name,
      type: .number(),
      width: 120,
      suppressedAutoSize: true,
    ),

    TrinaColumn(
      title: 'Unidades',
      field: CategoryTableColumns.units.name,
      type: .number(),
      width: 120,
      suppressedAutoSize: true,
    ),

    actionsColumn(
      renderer: (columnCtx) => Row(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        spacing: 8,
        children: [
          if (isAdmin(context) && deleteMutation != null)
            IconButton(
              style: BtnStyles.dangerButtonStyle,
              icon: WindowsIcon(FluentIcons.delete),
              onPressed: () {
                final pCount = columnCtx.row.cellValue<int>(
                  CategoryTableColumns.products.name,
                );

                final title = 'Eliminar categoría';

                cb() => deleteMutation.mutate(columnCtx);

                if (pCount == 0) {
                  confirmDeletion(
                    context,
                    title: title,
                    msg: '¿Realmente quieres eliminar la categoría?',
                    onConfirmed: cb,
                  );
                } else {
                  confirmCascadeDeletion(
                    context,
                    title: title,
                    msg:
                        '${pCount.multiPlural('\$ producto será desasociado', {2: 'n'})} (pero no se ${pCount.plural('eliminará', suffix: 'n', included: false)}).',
                    onConfirmed: cb,
                    cancelTxt: 'Conservar',
                    confirmTxt: 'Eliminar',
                  );
                }
              },
            ),

          SeeBtn(columnCtx),
        ],
      ),
    ),
  ];
}
