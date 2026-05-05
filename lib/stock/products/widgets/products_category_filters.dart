import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:servicable_stock/stock/products/view_model/products_vm.dart';
import 'package:servicable_stock/stock/products/widgets/with_count.dart';
import 'package:trina_grid/trina_grid.dart';

class CategoryFilters extends StatefulWidget {
  const CategoryFilters({super.key, required this.countsQuery});

  final QueryResult<ProductsCountsByCategory, dynamic> countsQuery;

  @override
  State<CategoryFilters> createState() => _CategoryFiltersState();
}

class _CategoryFiltersState extends State<CategoryFilters> {
  @override
  Widget build(BuildContext context) {
    final vm = ProductsVm.instance.of(context);
    final stateManager = vm.getStateManager();

    final categoryColumn = ProductTableColumns.category.name;

    final columnFilterType = stateManager?.getColumnFilterType(categoryColumn);

    return RadioGroup<CategoryFilterValue>(
      groupValue: getGroupValue(columnFilterType),

      onChanged: (v) {
        switch (v) {
          case .withCategory:
            stateManager!.setColumnFilter(
              columnField: categoryColumn,
              filterType: TrinaFilterTypeIsNotEmpty(),
              filterValue: '',
            );

          case .withoutCategory:
            stateManager!.setColumnFilter(
              columnField: categoryColumn,
              filterType: TrinaFilterTypeIsEmpty(),
              filterValue: '',
            );

          default:
            stateManager!.removeColumnFilter(categoryColumn);
        }

        setState(() {});
      },
      child: Row(
        mainAxisAlignment: .end,
        spacing: 20,
        children: [
          CategoryFilterOpt(
            text: 'Todos',
            count:
                (widget.countsQuery.data?.withCategory ?? 0) +
                (widget.countsQuery.data?.noCategory ?? 0),
            value: CategoryFilterValue.all,
          ),

          CategoryFilterOpt(
            text: 'Con categoría',
            count: widget.countsQuery.data?.withCategory,
            value: CategoryFilterValue.withCategory,
          ),

          CategoryFilterOpt(
            text: 'Sin categoría',
            count: widget.countsQuery.data?.noCategory,
            value: CategoryFilterValue.withoutCategory,
          ),
        ],
      ),
    );
  }

  CategoryFilterValue getGroupValue(TrinaFilterType? columnFilterType) {
    if (columnFilterType is TrinaFilterTypeIsNotEmpty) {
      return .withCategory;
    }

    return columnFilterType is TrinaFilterTypeIsEmpty ? .withoutCategory : .all;
  }
}
