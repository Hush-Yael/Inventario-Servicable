import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/core/theme.dart';
import 'package:servicable_stock/users/users_types.dart';
import 'package:servicable_stock/users/view_model/users_vm.dart';

class DeleteBtn extends HookWidget {
  const DeleteBtn({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = UsersVm.provider.of(context);

    final mutation = vm.createDeleteMutation(context);

    final noRowsSelected = vm.noRowsSelected;

    return SignalBuilder(
      builder: (context, child) {
        return Button(
          style: BtnStyles.dangerButtonStyle,
          onPressed: noRowsSelected() || mutation.isPending
              ? null
              : () => handler(context, mutation),
          child: Row(
            spacing: 6,
            children: [
              mutation.isPending
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: ProgressRing(
                        strokeWidth: 3,
                        backgroundColor: BtnStyles
                            .dangerButtonStyle
                            .foregroundColor
                            ?.resolve({})
                            ?.withAlpha(90),
                        activeColor: BtnStyles.dangerButtonStyle.foregroundColor
                            ?.resolve({}),
                      ),
                    )
                  : WindowsIcon(FluentIcons.delete),
              const Text('Eliminar'),
            ],
          ),
        );
      },
    );
  }

  void handler(BuildContext context, DeleteMutation mutation) async {
    final users = UsersVm.provider.of(context).selectedRows;

    if (users.isEmpty) return;

    await showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text(
          'Eliminar usuarios',
          style: AppTheme.dialogTitleStyle,
        ),
        content: Text(
          '¿Realmente quieres eliminar los ${users.length} usuarios seleccionados?',
        ),
        actions: [
          Button(
            onPressed: () => Navigator.pop(context, 'No'),
            style: ButtonStyle(padding: .all(.all(8))),
            child: const Text('No, cancelar'),
          ),
          Button(
            style: BtnStyles.dangerButtonStyle.copyWith(padding: .all(.all(8))),
            onPressed: () {
              mutation.mutate(null);
              Navigator.pop(context, 'Si');
            },
            child: const Text('Sí, eliminar'),
          ),
        ],
      ),
    );
  }
}
