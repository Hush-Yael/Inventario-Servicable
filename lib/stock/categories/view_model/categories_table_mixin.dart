import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/stock/categories/categories_constants.dart';
import 'package:servicable_stock/stock/categories/categories_models.dart';
import 'package:servicable_stock/stock/categories/categories_types.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_vm.dart';

import 'package:trina_grid/trina_grid.dart';

mixin TableMixin on CategoriesBaseVm {
  TrinaRow createRow(int index, CategoryWithCounts cat) => TrinaRow(
    metadata: {'id': cat.id},
    cells: {
      kIndexColumnField: TrinaCell(value: index + 1),

      CategoryTableColumns.name.name: TrinaCell(value: cat.name),

      CategoryTableColumns.createdAt.name: TrinaCell(value: cat.createdAt),

      CategoryTableColumns.updatedAt.name: getUpdatedAtCell(
        cat.createdAt,
        cat.updatedAt,
      ),

      CategoryTableColumns.products.name: TrinaCell(value: cat.productCount),

      CategoryTableColumns.units.name: TrinaCell(value: cat.unitCount),

      if (isAdmin) kActionsColumnName: TrinaCell(),
    },
  );

  /// If createdAt and updatedAt are the same, show nothing on the cell
  TrinaCell getUpdatedAtCell(DateTime createdAt, DateTime updatedAt) {
    return TrinaCell(
      value: updatedAt,
      renderer: createdAt.isAtSameMomentAs(updatedAt)
          ? (ctx) => Text('')
          : null,
    );
  }

  List<TrinaRow> getRows(CategoriesList list) {
    return list.mapIndexed((index, cat) => createRow(index, cat)).toList();
  }
}
