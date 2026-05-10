import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/navigation/navigation_pages.dart';
import 'package:servicable_stock/stock/categories/categories_constants.dart';
import 'package:trina_grid/trina_grid.dart';

class SeeBtn extends StatelessWidget {
  final TrinaColumnRendererContext columnCtx;

  const SeeBtn(this.columnCtx, {super.key});

  @override
  Widget build(BuildContext context) {
    final categoryName = columnCtx.row.cellValue<String>(
      CategoryTableColumns.name.name,
    );

    return DropDownButton(
      title: const WindowsIcon(FluentIcons.view, size: 15),
      style: .new(padding: .all(const .symmetric(horizontal: 5, vertical: 6))),
      trailing: null,
      placement: .bottomRight,
      items: [
        MenuFlyoutItem(
          text: const Text('Ver productos'),
          onPressed: () => go(
            context,
            categoryName,
            destination: MainNavigationPages.products.name,
          ),
        ),

        MenuFlyoutItem(
          text: const Text('Ver unidades'),
          onPressed: () => go(
            context,
            categoryName,
            destination: MainNavigationPages.units.name,
          ),
        ),
      ],
    );
  }

  void go(
    BuildContext context,
    String categoryName, {
    required String destination,
  }) {
    context.goNamed(
      destination,
      queryParameters: {'categoryName': categoryName},
    );
  }
}
