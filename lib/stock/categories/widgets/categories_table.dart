import 'package:fluent_ui/fluent_ui.dart' hide Title;
import 'package:flutter/material.dart' as m;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/shared/widgets/no_rows.dart';
import 'package:servicable_stock/shared/widgets/table_fetch_error.dart';
import 'package:servicable_stock/shared/widgets/table_loader.dart';
import 'package:servicable_stock/stock/categories/categories_constants.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_vm.dart';
import 'package:servicable_stock/stock/categories/categories_types.dart';
import 'package:trina_grid/trina_grid.dart';

class CategoriesTable extends HookWidget {
  final CategoriesQuery query;

  const CategoriesTable(this.query, {super.key});

  @override
  Widget build(BuildContext context) {
    if (query.isError) {
      return TableFetchError(query, 'Error al obtener las categorías');
    }

    final vm = CategoriesVm.instance.of(context);

    final config = getTrinaBaseConfig(context);

    final CategoriesDeleteMutation deleteMutation = vm.createDeleteMutation(
      context,
    );

    if (query.isLoading) {
      return tableLoader(
        query,
        config: config,
        columns: getColumns(context, const [], deleteMutation),
      );
    }

    final list = query.data!;
    final canEdit = hasPerm(context, .operator);

    final CategoriesChangeNameMutation changeNameMutation = vm
        .createChangeNameMutation(context);

    return TrinaGrid(
      rows: vm.getRows(list),
      columns: getColumns(context, list, deleteMutation),
      onLoaded: (event) => vm.stateManager = event.stateManager,
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
  }

  List<TrinaColumn> getColumns(
    BuildContext context,
    CategoriesList list,
    CategoriesDeleteMutation deleteMutation,
  ) => [
    indexColumn(list.length),

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

    TrinaColumn(
      field: kActionsColumnName,
      type: .custom(),
      renderer: (columnCtx) => Row(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        spacing: 8,
        children: [
          if (isAdmin(context))
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

          DropDownButton(
            title: WindowsIcon(FluentIcons.view, size: 15),
            style: .new(padding: .all(.symmetric(horizontal: 5, vertical: 6))),
            trailing: null,
            placement: .bottomRight,
            items: [
              MenuFlyoutItem(
                text: const Text('Ver productos'),
                onPressed: () {},
              ),
              MenuFlyoutItem(
                text: const Text('Ver unidades'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
      title: 'Acciones',
      titleTextAlign: .center,
      minWidth: 90,
      width: 90,
      suppressedAutoSize: true,
      enableSorting: false,
      enableEditingMode: false,
      enableColumnDrag: false,
      enableContextMenu: false,
      enableDropToResize: false,
    ),
  ];
}
