import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:servicable_stock/navigation/navigation_pages.dart';
import 'package:servicable_stock/navigation/widgets/account.dart';
import 'package:servicable_stock/navigation/widgets/theme_selector.dart';

class NavigationScreen extends StatelessWidget {
  final GoRouterState state;
  final Widget currentView;

  const NavigationScreen({
    super.key,
    required this.state,
    required this.currentView,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = MainNavigationPages.values.firstWhere(
      (page) => page.path == state.topRoute!.path,
    );

    return NavigationView(
      paneBodyBuilder: (item, body) => currentView,
      pane: NavigationPane(
        indicator: const StickyNavigationIndicator(indicatorSize: 5),
        selected: currentIndex.index,
        size: const .new(openWidth: 250),
        onChanged: (index) =>
            GoRouter.of(context).go(MainNavigationPages.values[index].path),
        toggleButton: null,
        items: paneItems,
      ),
    );
  }

  List<NavigationPaneItem> get paneItems => [
    PaneItemWidgetAdapter(
      child: Padding(
        padding: const .only(top: 5.0),
        child: Column(
          spacing: 5,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [Image.asset('assets/logo.png', width: 140, fit: .cover)],
        ),
      ),
      applyPadding: false,
    ),

    PaneItemSeparator(),

    PaneItemWidgetAdapter(child: const Account(), applyPadding: false),

    PaneItemWidgetAdapter(child: const ThemeSelector(), applyPadding: false),

    PaneItemSeparator(),

    ...MainNavigationPages.values.map((page) => page.paneItem),
  ];
}
