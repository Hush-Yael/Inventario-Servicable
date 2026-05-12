import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/navigation/navigation_pages.dart';
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
        items: getPaneItems(context),
      ),
    );
  }

  List<NavigationPaneItem> getPaneItems(BuildContext context) {
    final authState = AuthState.instance.of(context);

    return [
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

      PaneItemWidgetAdapter(child: const ThemeSelector(), applyPadding: false),

      PaneItemExpander(
        title: Column(
          crossAxisAlignment: .start,
          children: [
            Text(authState.user?.name ?? 'usuario desconocido'),

            Text(
              authState.user?.role.label ?? 'rol desconocido',
              style: .new(
                fontSize: 12,
                color: context.theme.resources.textFillColorSecondary,
              ),
            ),
          ],
        ),
        icon: const WindowsIcon(FluentIcons.contact),
        items: [
          MainNavigationPages.account.paneItem,

          PaneItemAction(
            title: const Text('Cerrar sesión'),
            icon: const WindowsIcon(FluentIcons.sign_out),
            onTap: authState.clearUser,
          ),
        ],
      ),

      PaneItemSeparator(),

      ...MainNavigationPages.values
          .where((page) => page.isMain)
          .map((page) => page.paneItem),
    ];
  }
}
