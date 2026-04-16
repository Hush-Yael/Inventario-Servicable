import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/navigation/navigation_pages.dart';
import 'package:servicable_stock/navigation/widgets/account.dart';
import 'package:servicable_stock/navigation/widgets/theme_selector.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paneIndex = Signal(NavigationPages.home);

    return SignalBuilder(
      builder: (context, child) {
        return NavigationView(
          pane: NavigationPane(
            indicator: const StickyNavigationIndicator(indicatorSize: 5),
            selected: paneIndex.value.index,
            onChanged: (index) =>
                paneIndex.value = NavigationPages.values[index],
            size: const .new(openWidth: 250),
            toggleButton: null,
            items: paneItems,
          ),
        );
      },
    );
  }

  List<NavigationPaneItem> get paneItems => [
    PaneItemWidgetAdapter(child: const Account(), applyPadding: false),

    PaneItemWidgetAdapter(child: const ThemeSelector(), applyPadding: false),

    PaneItemSeparator(),

    ...navigationPages,
  ];
}
