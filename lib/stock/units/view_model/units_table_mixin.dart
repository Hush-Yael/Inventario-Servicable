import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/utils/fn.dart' as utils;
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/shared/shared_constants.dart';
import 'package:servicable_stock/shared/shared_types.dart';
import 'package:servicable_stock/shared/widgets/filter_field/index.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/units/units_constants.dart';
import 'package:servicable_stock/stock/units/units_models.dart';
import 'package:servicable_stock/stock/units/units_types.dart';
import 'package:servicable_stock/stock/units/view_model/units_vm.dart';
import 'package:servicable_stock/stock/units/widgets/units_delete_btn.dart';
import 'package:trina_grid/trina_grid.dart';

mixin TableMixin on UnitsBaseVm {
  List<TrinaColumn> getColumns(
    BuildContext context,
    int listLength,
    ProductsDeleteMutation? deleteMutation, {
    required ProductForeignKeyOptions productOptions,
    required TableForeignKeyOptions categoryOptions,
  }) {
    final isAdmin = utils.isAdmin(context);

    return [
      indexColumn(listLength),

      .new(
        title: 'Identificador',
        field: UnitsTableColumns.identifier.name,
        type: .text(),
        filterWidgetDelegate: fieldWithFilterType(
          column: UnitsTableColumns.identifier.name,
        ),
      ),

      .new(
        title: 'Producto',
        field: UnitsTableColumns.product.name,
        type: .select<String>(productOptions.map((opt) => opt.label).toList()),
        filterWidgetDelegate: fieldWithFilterType(
          column: UnitsTableColumns.product.name,
        ),
      ),

      .new(
        title: 'Categoría',
        field: UnitsTableColumns.category.name,
        type: .select<String>(
          categoryOptions.map((opt) => opt!.label).toList(),
        ),
        enableEditingMode: false,
        filterWidgetDelegate: fieldWithFilterType(
          column: UnitsTableColumns.category.name,
        ),
      ),

      .new(
        title: 'Adquirido por',
        field: UnitsTableColumns.soldTo.name,
        type: .text(),
        filterWidgetDelegate: fieldWithFilterType(
          column: UnitsTableColumns.soldTo.name,
        ),
      ),

      .new(
        title: 'Detalles',
        field: UnitsTableColumns.details.name,
        type: .text(),
        filterWidgetDelegate: fieldWithFilterType(
          column: UnitsTableColumns.details.name,
        ),
      ),

      actionsColumn(
        renderer: !isAdmin || deleteMutation == null
            ? null
            : (columnCtx) => DeleteBtn(columnCtx, deleteMutation),
      ),
    ];
  }

  TrinaRow createRow(int index, UnitWithDetails unit) {
    return TrinaRow(
      metadata: {'id': unit.id, UnitsMetaKeys.productId.name: unit.productId},
      cells: {
        kIndexColumnField: TrinaCell(value: index + 1),

        UnitsTableColumns.identifier.name: TrinaCell(value: unit.identifier),

        UnitsTableColumns.category.name: TrinaCell(
          value: unit.categoryName ?? '',
        ),

        UnitsTableColumns.product.name: TrinaCell(
          value: unit.productName ?? '',
        ),

        UnitsTableColumns.soldTo.name: TrinaCell(value: unit.soldTo ?? ''),

        UnitsTableColumns.details.name: TrinaCell(value: unit.details ?? ''),

        kActionsColumnName: TrinaCell(),
      },
    );
  }

  List<TrinaRow> getRows(UnitsList list) {
    return list.mapIndexed((index, unit) => createRow(index, unit)).toList();
  }
}
