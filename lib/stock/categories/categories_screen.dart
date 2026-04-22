import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/core/utils/guard_widget.dart';
import 'package:servicable_stock/shared/widgets/table_title.dart';
import 'package:servicable_stock/stock/categories/categories_constants.dart';
import 'package:servicable_stock/stock/categories/widgets/categories_form.dart';
import 'package:servicable_stock/stock/categories/widgets/categories_table.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_vm.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      providers: [CategoriesVm.instance],
      child: const _CategoriesScreen(),
    );
  }
}

class _CategoriesScreen extends HookWidget {
  const _CategoriesScreen();

  @override
  Widget build(BuildContext context) {
    final vm = CategoriesVm.instance.of(context);

    final query = useQuery(
      kCategoriesQueryKey,
      (context) => vm.service.fetchCategories(),
    );

    return ScaffoldPage(
      header: Padding(
        padding: const .only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Column(
              crossAxisAlignment: .start,
              spacing: 6,
              children: [
                TableTitle(
                  query: query,
                  text: 'Categorías de productos',
                  style: context.theme.typography.title,
                ),

                Text(
                  'Controla los tipos de productos manejados en el inventario',
                  style: .new(
                    fontSize: 16,
                    color: context.theme.resources.textFillColorSecondary,
                  ),
                ),
              ],
            ),

            Guard(role: UserRole.operator, child: CategoriesForm()),
          ],
        ),
      ),
      content: Padding(padding: const .all(20), child: CategoriesTable(query)),
    );
  }
}
