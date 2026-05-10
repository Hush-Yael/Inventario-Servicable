import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/stock/units/view_model/units_vm.dart';
import 'package:trina_grid/trina_grid.dart';

typedef UnitTriStateOption = (bool?, String);

const List<UnitTriStateOption> triStateOptions = [
  (null, '-'),
  (true, 'Sí'),
  (false, 'No'),
];

class UnitTriStateFilter extends StatelessWidget {
  final String label;
  final String column;

  const UnitTriStateFilter({
    super.key,
    required this.label,
    required this.column,
  });

  @override
  Widget build(BuildContext context) {
    final vm = UnitsVm.instance.of(context);
    final value = Signal<UnitTriStateOption>(triStateOptions.first);

    return Row(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: .center,
      mainAxisAlignment: .spaceBetween,
      children: [
        Text('$label:', style: context.theme.typography.body),

        SignalBuilder(
          builder: (context, child) {
            return ComboBox<UnitTriStateOption>(
              value: value.value,
              style: AppTheme.fixedTextHeightStyle,
              items: triStateOptions
                  .map((val) => ComboBoxItem(value: val, child: Text(val.$2)))
                  .toList(),
              onChanged: (v) {
                value.value = v!;

                final stateManager = vm.getStateManager()!;

                switch (v.$1) {
                  case true:
                    stateManager.setColumnFilter(
                      columnField: column,
                      filterType: TrinaFilterTypeIsNotEmpty(),
                      filterValue: '',
                    );

                  case false:
                    stateManager.setColumnFilter(
                      columnField: column,
                      filterType: TrinaFilterTypeIsEmpty(),
                      filterValue: '',
                    );

                  default:
                    stateManager.removeColumnFilter(column);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
