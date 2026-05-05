import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/home/home_screen.dart';
import 'package:servicable_stock/stock/categories/categories_screen.dart';
import 'package:servicable_stock/stock/products/products_screen.dart';
import 'package:servicable_stock/users/users_screen.dart';

enum NavigationPages {
  home(FluentIcons.home, 'Inicio', HomeScreen()),
  users(FluentIcons.people, 'Usuarios', UsersScreen()),
  categories(
    FluentIcons.app_icon_default_list,
    'Categorías',
    CategoriesScreen(),
  ),
  products(FluentIcons.product_variant, 'Productos', ProductsScreen());

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
