import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:go_router/go_router.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/navigation/navigation_pages.dart';
import 'package:servicable_stock/stock/categories/view_model/categories_vm.dart';
import 'package:trina_grid/trina_grid.dart';

class SeeBtn extends StatelessWidget {
  final TrinaColumnRendererContext columnCtx;

  const SeeBtn(this.columnCtx, {super.key});

  @override
  Widget build(BuildContext context) {
    final vm = CategoriesVm.instance.of(context);
    final loading = Signal(false);

    return SignalBuilder(
      builder: (context, child) => DropDownButton(
        title: loading.value
            ? const SizedBox(
                width: 15,
                height: 15,
                child: ProgressRing(strokeWidth: 3),
              )
            : const WindowsIcon(FluentIcons.view, size: 15),
        style: .new(
          padding: .all(const .symmetric(horizontal: 5, vertical: 6)),
        ),
        trailing: null,
        placement: .bottomRight,
        items: [
          MenuFlyoutItem(
            text: const Text('Ver productos'),
            onPressed: () async {
              loading.value = true;

              try {
                final categoryName = await vm.service.getCategoryName(
                  columnCtx.row.$id!,
                );

                /* final categoryName = await Future.delayed(
                  const Duration(seconds: 1),
                  () => Future.error('error'),
                ); */

                if (!context.mounted) return;

                if (categoryName == null) {
                  return showMsg(
                    context: context,
                    message: 'No se encontró el nombre de la categoría',
                    severity: .error,
                    alignment: .bottomRight,
                  );
                }

                context.goNamed(
                  MainNavigationPages.products.name,
                  queryParameters: {'categoryName': categoryName},
                );
              } catch (e) {
                showMsg(
                  context: context,
                  message: 'Error al obtener el nombre de la categoría',
                  severity: .error,
                  alignment: .bottomRight,
                );
              } finally {
                loading.value = false;
              }
            },
          ),

          MenuFlyoutItem(text: const Text('Ver unidades'), onPressed: () {}),
        ],
      ),
    );
  }
}
