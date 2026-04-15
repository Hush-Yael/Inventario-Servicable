import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/auth_constants.dart';
import 'package:servicable_stock/core/theme.dart';
import 'package:servicable_stock/users/view_model/users_vm.dart';

class ChangeRoleBtn extends HookWidget {
  const ChangeRoleBtn({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = UsersVm.provider.of(context);

    final mutation = vm.createChangeRoleMutation(context);

    final noRowsSelected = vm.noRowsSelected;

    return SignalBuilder(
      builder: (context, child) => ComboBox<UserRole>(
        placeholder: Row(
          spacing: 8,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            mutation.isPending
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: ProgressRing(strokeWidth: 3),
                  )
                : const WindowsIcon(FluentIcons.player_settings, size: 16),

            const Text('Cambiar rol'),
          ],
        ),

        style: AppTheme.fixedTextHeightStyle,

        onChanged: noRowsSelected() || mutation.isPending
            ? null
            : (value) => value != null ? mutation.mutate(value) : null,

        items: List.generate(
          UserRole.values.length,
          (index) => ComboBoxItem(
            value: UserRole.values[index],
            child: Text(UserRole.values[index].label),
          ),
        ),
      ),
    );
  }
}
