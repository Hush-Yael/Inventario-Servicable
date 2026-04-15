import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/users/users_page.dart';

enum NavigationPages {
  home(FluentIcons.home, 'Inicio', Text('Index')),
  inventory(FluentIcons.grid_view_medium, 'Inventario', Text('Inventario')),
  users(FluentIcons.people, 'Usuarios', UsersPage()),
  settings(FluentIcons.settings, 'Configuración', Text('Configuración'));

  const NavigationPages(this.icon, this.label, this.view);

  final IconData icon;
  final String label;
  final Widget view;

  PaneItem get paneItem =>
      PaneItem(title: Text(label), icon: WindowsIcon(icon), body: view);
}

final navigationPages = NavigationPages.values
    .map((page) => page.paneItem)
    .toList();
