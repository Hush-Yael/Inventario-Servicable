import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/auth/auth_controller.dart';
import 'package:servicable_stock/navigation/widgets/pane_item_dropdown.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = AuthController.provider.of(context);

    return PaneItemDropdown(
      text: authController.user?.name ?? 'usuario desconocido',
      subtitle: Text(authController.user?.role.label ?? 'rol desconocido'),
      icon: FluentIcons.contact,
      items: [
        MenuFlyoutItem(
          text: const Text('Configuración'),
          leading: const WindowsIcon(FluentIcons.c_r_m_services, size: 14),
          onPressed: () {},
        ),
        MenuFlyoutItem(
          text: const Text('Cerrar sesión'),
          leading: const WindowsIcon(FluentIcons.sign_out, size: 14),
          onPressed: AuthController.provider.of(context).clearUser,
        ),
      ],
      placement: .rightCenter,
    );
  }
}
