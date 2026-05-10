import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:servicable_stock/core/utils/fn.dart' as utils;
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/shared/shared_constants.dart';
import 'package:servicable_stock/shared/shared_types.dart';
import 'package:servicable_stock/shared/widgets/filter_field/index.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:servicable_stock/stock/products/products_models.dart';
import 'package:servicable_stock/stock/products/view_model/products_vm.dart';
import 'package:servicable_stock/stock/products/widgets/products_delete_btn.dart';
import 'package:servicable_stock/stock/products/widgets/products_units_link.dart';
import 'package:trina_grid/trina_grid.dart';

mixin TableMixin on ProductsBaseVm {
  List<TrinaColumn> getColumns(
    BuildContext context,
    ProductsDeleteMutation? deleteMutation, {
    required int listLength,
    required TableForeignKeyOptions categoryNames,
  }) {
    final isAdmin = utils.isAdmin(context);

    return [
      indexColumn(listLength),

      .new(
        type: .text(),
        title: 'Nombre',
        field: ProductTableColumns.name.name,
        filterWidgetDelegate: fieldWithFilterType(
          column: ProductTableColumns.name.name,
        ),
      ),

      .new(
        type: .text(),
        title: 'Código',
        field: ProductTableColumns.code.name,
        filterWidgetDelegate: fieldWithFilterType(
          column: ProductTableColumns.code.name,
        ),
      ),

      .new(
        type: .select<String>(categoryNames.map((opt) => opt!.label).toList()),
        title: 'Categoría',
        field: ProductTableColumns.category.name,
        filterWidgetDelegate: fieldWithFilterType(
          column: ProductTableColumns.category.name,
        ),
      ),

      .new(
        title: 'Unidades',
        field: ProductTableColumns.units.name,
        type: .number(negative: false),
        cellPadding: const EdgeInsets.all(0),
        filterWidgetDelegate: fieldWithFilterType(
          column: ProductTableColumns.units.name,
          defaultFilter: const TrinaFilterTypeEquals(),
        ),
        renderer: (ctx) {
          final usesDetailedUnits =
              ctx.row.metadata?[ProductMetaKeys.usesDetailedUnits.name] == true;

          final padding = TrinaGridSettings.cellPadding;

          return !usesDetailedUnits
              ? Padding(
                  padding: padding,
                  child: Text(ctx.cell.value.toString()),
                )
              : UnitsLink(
                  text: ctx.cell.value.toString(),
                  rowHeight: ctx.row.height ?? TrinaGridSettings.rowHeight,
                  productName: ctx.row.cellValue<String>(
                    ProductTableColumns.name.name,
                  ),
                );
        },
      ),

      actionsColumn(
        renderer: !isAdmin || deleteMutation == null
            ? null
            : (columnCtx) => DeleteBtn(columnCtx, deleteMutation),
      ),
    ];
  }

  TrinaRow createRow(int index, ProductWithDetails product) {
    return .new(
      metadata: {
        'id': product.id,
        ProductMetaKeys.usesDetailedUnits.name: product.usesDetailedUnits,
        ProductMetaKeys.categoryId.name: product.categoryId,
      },
      cells: {
        kIndexColumnField: .new(value: index + 1),

        ProductTableColumns.name.name: .new(value: product.name),

        ProductTableColumns.code.name: .new(value: product.code),

        ProductTableColumns.category.name: .new(
          value: product.categoryName ?? '',
        ),

        ProductTableColumns.units.name: .new(value: product.units),

        kActionsColumnName: .new(),
      },
    );
  }

  List<TrinaRow> getRows(ProductsList list) {
    return list
        .mapIndexed((index, product) => createRow(index, product))
        .toList();
  }
}
