import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/stock/units/units_constants.dart';
import 'package:servicable_stock/stock/units/widgets/unit_tristate_option.dart';

class UnitsFilters extends StatelessWidget {
  const UnitsFilters({super.key});

  @override
  Widget build(BuildContext mainContext) {
    final controller = FlyoutController();

    return FlyoutTarget(
      controller: controller,

      child: Button(
        child: const Row(
          spacing: 7,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(FluentIcons.filter, size: 12), Text('Otros filtros')],
        ),
        onPressed: () {
          controller.showFlyout(
            placementMode: .bottomRight,
            builder: (context) => ProviderScopePortal(
              mainContext: mainContext,
              child: FlyoutContent(
                constraints: const .new(maxWidth: 300),
                child: Column(
                  spacing: 12,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: .stretch,
                  children: [
                    UnitTriStateFilter(
                      label: 'Asociados a productos',
                      column: UnitsTableColumns.product.name,
                    ),

                    UnitTriStateFilter(
                      label: 'Asociados a categorías',
                      column: UnitsTableColumns.category.name,
                    ),

                    UnitTriStateFilter(
                      label: 'Adquiridos',
                      column: UnitsTableColumns.soldTo.name,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
