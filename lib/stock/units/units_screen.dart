import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/shared/widgets/row_vertical_separator.dart';
import 'package:servicable_stock/shared/widgets/table_padding.dart';
import 'package:servicable_stock/shared/widgets/table_title.dart';
import 'package:servicable_stock/stock/units/units_constants.dart';
import 'package:servicable_stock/stock/units/units_types.dart';
import 'package:servicable_stock/stock/units/view_model/units_form_vm.dart';
import 'package:servicable_stock/stock/units/view_model/units_vm.dart';
import 'package:servicable_stock/stock/units/widgets/form/units_form.dart';
import 'package:servicable_stock/stock/units/widgets/units_filters.dart';
import 'package:servicable_stock/stock/units/widgets/units_table.dart';

class UnitsScreen extends StatelessWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      providers: [UnitsVm.instance],
      child: const _UnitsScreen(),
    );
  }
}

class _UnitsScreen extends HookWidget {
  const _UnitsScreen();

  @override
  Widget build(BuildContext context) {
    final vm = UnitsVm.instance.of(context);

    final UnitsQuery query = useQuery(
      kUnitsQueryKey,
      (_) => vm.service.getUnits(),
    );

    final formVm = UnitsFormVm.instance;

    return ScaffoldPage(
      header: PageHeader(
        title: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            TableTitle(query: query, text: 'Unidades de productos'),

            Row(
              spacing: 14,
              children: [
                const UnitsFilters(),

                if (vm.isAdmin) const RowVerticalSeparator(),

                if (vm.isAdmin)
                  ProviderScope(
                    providers: [formVm],
                    child: UnitsFormBtn(
                      title: 'Añadir unidad',
                      createAddMutation: vm.createAddMutation,
                      formVmProvider: formVm,
                      constraints: const BoxConstraints(
                        maxWidth: 750,
                        maxHeight: 400,
                      ),
                      child: UnitsForm(
                        formVmProvider: formVm,
                        getProductNames: vm.service.getProductNames,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      content: TablePadding(UnitsTable(query)),
    );
  }
}
