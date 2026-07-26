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
        title: AccountInfo(authState: authState),
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

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key, required this.authState});

  final AuthState authState;

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  void initState() {
    super.initState();
    // Add listener to rebuild widget when notifier changes
    widget.authState.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    widget.authState.removeListener(() {});
    widget.authState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(widget.authState.user?.name ?? 'usuario desconocido'),

        Text(
          widget.authState.user?.role.label ?? 'rol desconocido',
          style: .new(
            fontSize: 12,
            color: context.theme.resources.textFillColorSecondary,
          ),
        ),
      ],
    );
  }
}
