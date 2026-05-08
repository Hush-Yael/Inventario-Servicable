import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/shared/widgets/row_vertical_separator.dart';
import 'package:servicable_stock/shared/widgets/table_padding.dart';
import 'package:servicable_stock/shared/widgets/table_title.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:servicable_stock/stock/products/view_model/products_form_vm.dart';
import 'package:servicable_stock/stock/products/view_model/products_vm.dart';
import 'package:servicable_stock/stock/products/widgets/products_category_filters.dart';
import 'package:servicable_stock/stock/products/widgets/form/products_form_btn.dart';
import 'package:servicable_stock/stock/products/widgets/products_table.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      providers: [ProductsVm.instance],
      child: _ProductsScreen(),
    );
  }
}

class _ProductsScreen extends HookWidget {
  const _ProductsScreen();

  @override
  Widget build(BuildContext context) {
    final vm = ProductsVm.instance.of(context);

    final ProductsQuery query = useQuery(
      kProductsQueryKey,
      (context) => vm.service.getProducts(),
    );

    final countsQuery = useQuery(
      kProductCountsQueryKey,
      (_) => vm.service.fetchProductsCountsByCategory(),
    );

    final isAdmin = vm.isAdmin;

    return ScaffoldPage(
      header: PageHeader(
        title: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            TableTitle(query: query, text: 'Productos', noCount: true),

            ProviderScope(
              providers: [ProductsFormVm.instance],
              child: Expanded(
                child: Row(
                  spacing: 14,
                  mainAxisAlignment: .end,
                  children: [
                    CategoryFilters(countsQuery: countsQuery),

                    if (isAdmin) RowVerticalSeparator(),

                    if (isAdmin) const ProductsFormBtn(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      content: TablePadding(ProductsTable(query)),
    );
  }
}
