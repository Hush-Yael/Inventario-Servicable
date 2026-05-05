import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/shared/widgets/filter_field/_filter_widget.dart';
import 'package:servicable_stock/shared/widgets/filter_field/index.dart';
import 'package:trina_grid/trina_grid.dart';

class FieldFilter extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TrinaGridStateManager stateManager;
  final String column;
  final void Function(dynamic) handleOnChanged;
  final List<TrinaFilterType> filters;
  final TrinaFilterType initialFilterValue;
  final int min;
  final TrinaColumn columnRef;

  const FieldFilter({
    super.key,
    required this.controller,
    required this.stateManager,
    required this.focusNode,
    required this.column,
    required this.handleOnChanged,
    required this.filters,
    required this.columnRef,
    required this.initialFilterValue,
    this.min = 0,
  });

  @override
  Widget build(BuildContext context) {
    final menuController = FlyoutController();
    final filter = Signal(initialFilterValue);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: .stretch,
      spacing: 5,
      children: [
        SignalBuilder(
          builder: (context, child) {
            return Expanded(
              child: FilterWidget(
                context,
                min: min,
                handleOnChanged: handleOnChanged,
                type: columnRef.type,
                filter: filter.value,
                value: controller.text,
                controller: controller,
                focusNode: focusNode,
              ),
            );
          },
        ),

        FlyoutTarget(
          controller: menuController,
          child: Button(
            style: .new(
              shape: .all(
                RoundedRectangleBorder(
                  side: BorderSide(color: getBorderColor(context)),
                  borderRadius: borderRadius,
                ),
              ),
            ),
            child: const WindowsIcon(FluentIcons.filter),
            onPressed: () => menuController.showFlyout(
              autoModeConfiguration: FlyoutAutoConfiguration(
                preferredMode: FlyoutPlacementMode.bottomRight,
              ),
              builder: (context) {
                return MenuFlyout(
                  items: filters.mapIndexed((i, f) {
                    return RadioMenuFlyoutItem<TrinaFilterType>(
                      value: f,
                      groupValue: filter.value,
                      text: Text(f.title),
                      onChanged: (newFilter) {
                        filter.value = newFilter;

                        columnRef.setDefaultFilter(newFilter);

                        setFilter(
                          columnRef,
                          stateManager,
                          controller,
                          filterValue: newFilter,
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
