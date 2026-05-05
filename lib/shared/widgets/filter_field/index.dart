import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/shared/widgets/filter_field/_filter_field.dart';
import 'package:trina_grid/trina_grid.dart';

TrinaFilterColumnWidgetDelegate fieldWithFilterType({
  required String column,
  TrinaFilterType? defaultFilter,
  List<TrinaFilterType>? filters,
}) {
  bool builtOnce = false;

  return TrinaFilterColumnWidgetDelegate.builder(
    filterWidgetBuilder:
        (focusNode, controller, enabled, handleOnChanged, stateManager) {
          final columnRef = stateManager.refColumns.firstWhere(
            (c) => c.field == column,
          );

          // widget is rebuilt every time it changes, so we only want to set the default filter once to prevent losing selected filter if the filter row is deleted
          if (!builtOnce) {
            builtOnce = true;

            if (defaultFilter != null) {
              columnRef.setDefaultFilter(defaultFilter);
            }
          }

          return FieldFilter(
            controller: controller,
            column: column,
            focusNode: focusNode,
            stateManager: stateManager,
            handleOnChanged: handleOnChanged,
            columnRef: columnRef,
            initialFilterValue: columnRef.defaultFilter,
            filters:
                filters ??
                getDefaultFilters(columnRef.type)
                    .where(
                      (f) =>
                          f is! TrinaFilterTypeIsEmpty &&
                          f is! TrinaFilterTypeIsNotEmpty,
                    )
                    .toList(),
          );
        },
  );
}

const stringFilters = [
  TrinaFilterTypeContains(),
  TrinaFilterTypeEquals(),
  TrinaFilterTypeStartsWith(),
  TrinaFilterTypeEndsWith(),
  TrinaFilterTypeRegex(),
];

void setFilter(
  TrinaColumn columnRef,
  TrinaGridStateManager stateManager,
  TextEditingController controller, {
  required TrinaFilterType filterValue,
}) {
  columnRef.setDefaultFilter(filterValue);

  stateManager.setColumnFilter(
    columnField: columnRef.field,
    filterType: filterValue,
    filterValue: controller.text,
  );
}

List<TrinaFilterType> getDefaultFilters(TrinaColumnType type) {
  if (type.isNumber) {
    return FilterHelper.defaultFilters
        .where((f) => f is! TrinaFilterTypeRegex)
        .toList();
  }

  return stringFilters;
}

const borderRadius = BorderRadius.all(Radius.circular(1));

Color getBorderColor(BuildContext context) =>
    context.theme.brightness == Brightness.light
    ? context.theme.resources.cardStrokeColorDefaultSolid
    : Colors.grey[140];
