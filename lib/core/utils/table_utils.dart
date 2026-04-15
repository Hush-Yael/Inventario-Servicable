import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/theme.dart';
import 'package:trina_grid/trina_grid.dart';

TrinaGridConfiguration getTrinaBaseConfig(BuildContext context) {
  return TrinaGridConfiguration(
    localeText: TrinaGridLocaleText(
      unfreezeColumn: 'Desfijar columna',
      freezeColumnToEnd: 'Fijar columna al final',
      freezeColumnToStart: 'Fijar columna al inicio',
      autoFitColumn: 'Ajustar columna al contenido',
      hideColumn: 'Esconder columna',
      setColumns: 'Establecer columnas',
      setColumnsTitle: 'Todas',
      setFilter: 'Filtrar',
      resetFilter: 'Limpiar filtro',
    ),

    scrollbar: .new(columnShowScrollWidth: false),

    columnSize: .new(autoSizeMode: .equal),

    style: Function.apply(
      context.theme.brightness == Brightness.dark
          ? TrinaGridStyleConfig.dark
          : TrinaGridStyleConfig.new,
      null,
      {
        #gridBackgroundColor:
            context.theme.resources.cardBackgroundFillColorDefault,

        #enableCellBorderVertical: false,
        #enableColumnBorderVertical: false,

        #borderColor: context.theme.brightness == Brightness.dark
            ? Color(0xff595959)
            : context.theme.resources.cardStrokeColorDefaultSolid,

        #gridBorderColor: context.theme.brightness == Brightness.dark
            ? Colors.grey[140]
            : context.theme.resources.cardStrokeColorDefault,

        #gridBorderRadius: BorderRadius.all(.circular(4)),

        #columnTextStyle: TextStyle(
          color: context.theme.resources.textFillColorPrimary,
          fontWeight: .bold,
        ),

        #menuBackgroundColor: context.theme.menuColor,

        #filterPopupHeaderColor: context.theme.menuColor,

        #rowColor: context.theme.resources.cardBackgroundFillColorDefault,

        #rowCheckedColor:
            context.theme.resources.cardBackgroundFillColorDefault,

        #cellColorInEditState: context.theme.brightness == Brightness.dark
            ? context.theme.resources.surfaceStrokeColorDefault
            : context.theme.resources.solidBackgroundFillColorBase,

        // color for check icon
        #cellCheckedColor: Colors.white,

        #activatedColor: context.theme.brightness == Brightness.dark
            ? context.theme.resources.surfaceStrokeColorDefault
            : context.theme.resources.solidBackgroundFillColorBase,

        #activatedBorderColor: context.theme.accentColor,
      },
    ),
  );
}

const kIndexColumnField = 'index';

/// Returns a column that contains the index of the row, [listLength] is used to calculate the minimum width needed to fit longest number of the list length
TrinaColumn indexColumn(int listLength) {
  final span = TextSpan(text: listLength.toString());
  final painter = TextPainter(text: span, textDirection: .ltr, maxLines: 1);

  painter.layout();

  return TrinaColumn(
    title: '#',
    field: kIndexColumnField,
    type: .number(),
    titleTextAlign: .right,
    suppressedAutoSize: true,
    textAlign: .right,
    width: painter.width + 30,
    enableEditingMode: false,
    enableColumnDrag: false,
    enableContextMenu: false,
    enableDropToResize: false,
  );
}

const kSelectAllRowsColumnField = 'selected';

TrinaColumn selectAllRowsColumn({
  required EdgeInsets cellsPadding,
  required int selfId,
  required Signal<bool?> checkValueSignal,
  bool Function(TrinaColumnTitleRendererContext ctx)? disabled,
}) => TrinaColumn(
  title: '',
  field: kSelectAllRowsColumnField,
  type: .custom(toDisplayString: (value) => ''),
  disableRowCheckboxWhen: (row) => row.metadata?['id'] == selfId,
  width: 60,
  enableContextMenu: false,
  enableSorting: false,
  enableColumnDrag: false,
  enableFilterMenuItem: false,
  enableEditingMode: false,
  suppressedAutoSize: true,
  enableDropToResize: false,
  enableRowChecked: true,
  titleRenderer: (rendererContext) {
    return Padding(
      padding: cellsPadding,
      child: Transform.scale(
        scale: 0.9,
        child: SignalBuilder(
          builder: (context, child) {
            final bool noRows = rendererContext.stateManager.rows.isEmpty;

            return material.Checkbox(
              tristate: true,

              value: checkValueSignal.value,

              checkColor: checkValueSignal.value == null ? Colors.black : null,

              fillColor: .resolveWith((states) {
                if (states.contains(WidgetState.selected) &&
                    checkValueSignal.value == null) {
                  return Colors.grey[60];
                }

                return null;
              }),

              onChanged: noRows || disabled != null && disabled(rendererContext)
                  ? null
                  : (value) {
                      final bool allSelected = value == null;

                      final bool allShouldBeChecked = allSelected
                          ? false
                          : true;

                      rendererContext.stateManager.toggleAllRowChecked(
                        allShouldBeChecked,
                        notify: false,
                      );

                      // 'toggleAllRowChecked' checks all rows even if they are disabled, so we need to manually uncheck them since they are not counted when we determine this checkbox value
                      if (allShouldBeChecked) {
                        rendererContext.stateManager.refRows
                            .firstWhereOrNull(
                              (row) => row.metadata?['id'] == selfId,
                            )
                            ?.setChecked(false);
                      }

                      rendererContext.stateManager.notifyListeners();

                      // Can only be either checked or not after toggling
                      checkValueSignal.value = allShouldBeChecked;
                    },
            );
          },
        ),
      ),
    );
  },
);
