import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:servicable_stock/profile/profile_screen.dart';
import 'package:servicable_stock/stock/categories/categories_screen.dart';
import 'package:servicable_stock/stock/products/products_screen.dart';
import 'package:servicable_stock/stock/units/units_screen.dart';
import 'package:servicable_stock/users/users_screen.dart';

enum MainNavigationPages<View extends StatelessWidget Function()> {
  account(
    'Datos de la cuenta',
    path: '/profile',
    icon: FluentIcons.contact_info,
    view: ProfileScreen.new,
    isMain: false,
  ),

  users(
    'Usuarios',
    path: '/home',
    icon: FluentIcons.people,
    view: UsersScreen.new,
  ),

  categories(
    'Categorías',
    path: '/categories',
    icon: FluentIcons.app_icon_default_list,
    view: CategoriesScreen.new,
  ),

  products(
    'Productos',
    path: '/products',
    icon: FluentIcons.product_variant,
    view: ProductsScreen.new,
  ),

  units(
    'Unidades',
    path: '/units',
    icon: FluentIcons.product_list,
    view: UnitsScreen.new,
  );

  const MainNavigationPages(
    this.label, {
    required this.path,
    required this.icon,
    required this.view,
    this.isMain = true,
  });

  final IconData icon;
  final String label;
  final View view;
  final String path;
  final bool isMain;

  PaneItem get paneItem => PaneItem(
    title: Text(label),
    icon: WindowsIcon(icon),
    body: const SizedBox.shrink(),
  );

  GoRoute get route {
    return .new(path: path, name: name, builder: (context, state) => view());
  }
}
