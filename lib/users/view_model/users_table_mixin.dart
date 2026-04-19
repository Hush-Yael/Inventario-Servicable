import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/users/users_constants.dart';
import 'package:servicable_stock/users/users_types.dart';
import 'package:servicable_stock/users/view_model/users_vm.dart';
import 'package:collection/collection.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:trina_grid/trina_grid.dart';

mixin TableMixin on UsersBaseVm {
  TrinaGridStateManager? _stateManager;

  TrinaGridStateManager? get stateManager => _stateManager;

  set stateManager(TrinaGridStateManager stateManager) {
    _stateManager = stateManager;
  }

  bool shiftPressed = false;
  int lastSelectedIndex = -1;

  final selectAllCheckedValue = Signal<bool?>(false);

  late Computed<bool> noRowsSelected = Computed(
    () => selectAllCheckedValue.value == false && selectedRows.isEmpty,
  );

  List<TrinaRow<dynamic>> get selectedRows =>
      stateManager?.checkedRows ?? const [];

  List<int> get getIdsFromSelected =>
      selectedRows.map((row) => row.metadata?['id'] as int).toList();

  List<TrinaRow> getRows(BuildContext context, UsersList usersList) {
    final selfId = authState.user?.id;
    final UserRole role =
        AuthState.instance.of(context).user?.role ?? UserRole.supervisor;

    final bool isAdmin = role == UserRole.admin;

    return usersList.mapIndexed((rowIndex, user) {
      final cells = {
        kIndexColumnField: TrinaCell(value: rowIndex + 1),
        UsersTableColumns.name.name: TrinaCell(
          value: user.name,
          renderer: user.id == selfId
              ? (ctx) => Row(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .spaceBetween,
                  spacing: 7,
                  children: [
                    Text(ctx.cell.value),
                    InfoBadge.informational(
                      source: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: const Text(
                          'Tú',
                          style: TextStyle(fontWeight: .w600),
                        ),
                      ),
                    ),
                  ],
                )
              : null,
        ),

        UsersTableColumns.username.name: TrinaCell(value: user.username),

        UsersTableColumns.role.name: TrinaCell(value: user.role.label),

        UsersTableColumns.lastLogin.name: TrinaCell(value: user.lastLogin),
      };

      if (isAdmin) {
        cells[kSelectAllRowsColumnField] = TrinaCell();
      }

      return TrinaRow(metadata: {'id': user.id}, cells: cells);
    }).toList();
  }
}
