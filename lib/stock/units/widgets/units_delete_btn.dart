import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/stock/units/units_types.dart';
import 'package:trina_grid/trina_grid.dart';

class DeleteBtn extends StatelessWidget {
  final TrinaColumnRendererContext columnCtx;
  final UnitsDeleteMutation deleteMutation;

  const DeleteBtn(this.columnCtx, this.deleteMutation, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        style: BtnStyles.dangerButtonStyle,
        icon: const WindowsIcon(FluentIcons.delete),
        onPressed: () {
          confirmDeletion(
            context,
            title: 'Eliminar unidad',
            msg: '¿Realmente quieres eliminar esta unidad?',
            onConfirmed: () => deleteMutation.mutate(columnCtx),
            cancelTxt: 'No, conservar',
          );
        },
      ),
    );
  }
}
