import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/shared/shared_models.dart';
import 'package:servicable_stock/shared/shared_types.dart';
import 'package:servicable_stock/shared/widgets/form/field.dart';

class ForeignKeyField extends HookWidget {
  final List<String> queryKey;
  final Future<TableForeignKeyOptions> Function([QueryFunctionContext? ctx])
  fetchOptions;
  final String label;
  final String pluralLabel;
  final String pluralLabelVocal;
  final String field;
  final Computed<bool> enabled;
  final boxKey = GlobalKey<AutoSuggestBoxState>();

  ForeignKeyField({
    super.key,
    required this.queryKey,
    required this.fetchOptions,
    required this.pluralLabel,
    required this.label,
    required this.field,
    required this.enabled,
    this.pluralLabelVocal = 'o',
  });

  @override
  Widget build(BuildContext context) {
    final queryClient = useQueryClient();

    final categories = Resource(
      () => queryClient.ensureQueryData(queryKey, fetchOptions),
    );

    return SignalBuilder(
      builder: (context, child) => categories.state.when(
        error: (error, trace) => errorWidget(error, trace, context),
        loading: loader,
        ready: builder,
      ),
    );
  }

  Widget loader() => Align(
    alignment: .center,
    child: Column(
      spacing: 20,
      crossAxisAlignment: .stretch,
      children: [
        Text('Cargando $pluralLabel...'),
        const ProgressBar(strokeWidth: 6),
      ],
    ),
  );

  Widget builder(TableForeignKeyOptions options) {
    int? selected;
    int? prevSelected;
    String? prevSelectedText;

    final menuShown = Signal(boxKey.currentState?.isOverlayVisible ?? false);
    bool menuManuallyToggled = false;

    return Field<int>(
      field,
      label: label.uppercaseFirst(),
      initialValue: options.first.id,
      childBuilder: (field) {
        return Row(
          crossAxisAlignment: .start,
          spacing: 6,
          children: [
            Expanded(
              child: SignalBuilder(
                builder: (context, child) =>
                    AutoSuggestBox<TableForeignKeyOption>.form(
                      key: boxKey,
                      autovalidateMode: .onUserInteraction,
                      validator: (text) {
                        if (selected == null) {
                          if (text != null && text.isNotEmpty) {
                            return 'Seleccione una opción válida';
                          }

                          return 'Este campo es requerido';
                        }

                        return null;
                      },
                      maxPopupHeight: 300,
                      items: options.map((opt) {
                        final label = opt.label;

                        return AutoSuggestBoxItem(
                          value: opt,
                          label: label,
                          child: Tooltip(
                            message: label,
                            child: Text(
                              opt.label,
                              maxLines: 1,
                              overflow: .ellipsis,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (text, reason) {
                        final sameOptionText =
                            text.trim().toLowerCase() == prevSelectedText;

                        if (reason == TextChangedReason.userInput &&
                            sameOptionText) {
                          selected = prevSelected;
                          return field.didChange(prevSelected);
                        }

                        if (reason == TextChangedReason.cleared ||
                            (reason == TextChangedReason.userInput &&
                                !sameOptionText)) {
                          selected = null;
                          return field.didChange(null);
                        }
                      },
                      onSelected: !enabled.value
                          ? null
                          : (v) {
                              final id = v.value!.id;

                              field.didChange(id);
                              prevSelected = id;
                              prevSelectedText = v.label.toLowerCase();
                              selected = id;
                            },
                      onOverlayVisibilityChanged: (open) {
                        !menuManuallyToggled
                            ? menuShown.value = open
                            : menuManuallyToggled = false;
                      },
                    ),
              ),
            ),

            SizedBox(
              height: 30,
              width: 28,
              child: SignalBuilder(
                builder: (context, child) => ToggleButton(
                  checked: menuShown.value,
                  onChanged: (open) {
                    menuManuallyToggled = true;
                    menuShown.value = open;
                    open
                        ? boxKey.currentState?.showOverlay()
                        : boxKey.currentState?.dismissOverlay();
                  },
                  child: Transform.translate(
                    offset: const Offset(-3, 0),
                    child: const WindowsIcon(FluentIcons.more_vertical),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget errorWidget(Object error, StackTrace? trace, BuildContext context) {
    final errorColor = AppTheme.errorColor(context);

    return Tooltip(
      message: error.toString(),
      child: Column(
        spacing: 5,
        children: [
          Row(
            spacing: 10,
            children: [
              WindowsIcon(FluentIcons.incident_triangle, color: errorColor),

              Text(
                'Error al obtener l${pluralLabelVocal}s $pluralLabel',
                style: .new(color: errorColor),
              ),
            ],
          ),

          Container(
            decoration: BoxDecoration(color: errorColor.withAlpha(20)),
            height: 30,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
