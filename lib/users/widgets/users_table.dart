import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/shared/widgets/no_rows.dart';
import 'package:servicable_stock/shared/widgets/table.dart';
import 'package:servicable_stock/users/users_constants.dart';
import 'package:servicable_stock/users/users_types.dart';
import 'package:servicable_stock/users/view_model/users_vm.dart';
import 'package:servicable_stock/shared/widgets/card_wrapper.dart';
import 'package:servicable_stock/users/widgets/watch_shift_key.dart';
import 'package:trina_grid/trina_grid.dart';

class UsersTable extends HookWidget {
  final UsersQuery query;
  const UsersTable(this.query, {super.key});

  @override
  Widget build(BuildContext context) {
    final vm = UsersVm.instance.of(context);

    final config = getTrinaBaseConfig(context);
    final cellPadding = config.style.defaultCellPadding;

    return QueryTable(
      query,
      errorMsg: 'Error al obtener los usuarios',
      loaderColumns: getColumns(
        context,
        listLength: 0,
        selfId: null,
        cellsPadding: cellPadding,
      ),
      config: config,
      renderGrid: (usersList) {
        final selfId = AuthState.instance.of(context).user?.id;

        return WatchShiftKey(
          onShiftPressed: (pressed) => vm.shiftPressed = pressed,
          child: CardWrapper(
            TrinaGrid(
              noRowsWidget: NoRows('usuarios'),

              columns: getColumns(
                context,
                listLength: usersList!.length,
                selfId: selfId!,
                cellsPadding: cellPadding,
              ),

              configuration: getTrinaBaseConfig(context),

              onLoaded: (event) => vm.stateManager = event.stateManager,

              onBeforeActiveCellChange: (event) => false,

              onRowChecked: (event) {
                final m = vm.stateManager!;

                if (event.isChecked == true) {
                  final start = vm.lastSelectedIndex;
                  final end = event.rowIdx!;
                  final isRange =
                      vm.lastSelectedIndex > -1 && (start - end).abs() > 1;

                  if (!isRange) {
                    vm.lastSelectedIndex = event.rowIdx!;
                  } else {
                    final isForwards = start > end;

                    for (
                      int i = start;
                      isForwards ? i > end : i < end;
                      isForwards ? i-- : i++
                    ) {
                      final row = m.refRows[i];

                      if (i != event.rowIdx && row.$id! != selfId) {
                        row.setChecked(true);
                      }
                    }

                    vm.lastSelectedIndex = -1;
                    m.notifyListeners();
                  }
                } else {
                  vm.lastSelectedIndex = -1;
                }

                final bool noRowsChecked = m.checkedRows.isEmpty;

                final allSelected =
                    m.checkedRows.length ==
                    // subtract 1 so it doesn't include current user row, which is disabled
                    m.rows.length - 1;

                vm.selectAllCheckedValue.value = allSelected
                    ? true
                    : noRowsChecked
                    ? false
                    : null;
              },

              rows: vm.getRows(context, usersList),
            ),
          ),
        );
      },
    );
  }

  List<TrinaColumn> getColumns(
    BuildContext context, {

    required int listLength,
    int? selfId,
    required EdgeInsets cellsPadding,
  }) => [
    indexColumn(listLength),

    TrinaColumn(
      field: UsersTableColumns.name.name,
      type: .text(),
      title: 'Nombre',
      enableEditingMode: false,
    ),

    TrinaColumn(
      field: UsersTableColumns.username.name,
      type: .text(),
      title: 'Nombre de usuario',
      enableEditingMode: false,
    ),

    TrinaColumn(
      field: UsersTableColumns.role.name,
      type: .text(),
      title: 'Rol',
      enableEditingMode: false,
    ),

    TrinaColumn(
      field: UsersTableColumns.lastLogin.name,
      type: formattedDateColumnType,
      title: 'Último ingreso',
      enableEditingMode: false,
    ),

    if (isAdmin(context) && selfId != null)
      selectAllRowsColumn(
        cellsPadding: cellsPadding,
        selfId: selfId,
        checkValueSignal: UsersVm.instance.of(context).selectAllCheckedValue,
        disabled: (rendererContext) =>
            // When displaying only the current user row, disable the select all checkbox
            rendererContext.stateManager.rows.length == 1 &&
            rendererContext.stateManager.rows[0].$id == selfId,
      ),
  ];
}
