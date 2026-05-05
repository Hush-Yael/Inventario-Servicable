import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/core/utils/fn.dart' as utils;
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/stock/products/product_types.dart';
import 'package:servicable_stock/stock/products/products_constants.dart';
import 'package:trina_grid/trina_grid.dart';

class DeleteBtn extends StatelessWidget {
  final TrinaColumnRendererContext columnCtx;
  final ProductsDeleteMutation deleteMutation;

  const DeleteBtn(this.columnCtx, this.deleteMutation, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        style: BtnStyles.dangerButtonStyle,
        icon: WindowsIcon(FluentIcons.delete),
        onPressed: () {
          final uCount = columnCtx.row.cellValue<int>(
            ProductTableColumns.units.name,
          );

          final usesDetailedUnits =
              columnCtx.row.metadata?[ProductMetaKeys.usesDetailedUnits.name] ==
              true;

          final title = 'Eliminar producto';

          cb() => deleteMutation.mutate(columnCtx);

          if (uCount == 0 || !usesDetailedUnits) {
            utils.confirmDeletion(
              context,
              title: title,
              msg: '¿Realmente quieres eliminar el producto?',
              onConfirmed: cb,
              cancelTxt: 'No, conservar',
            );
          } else {
            utils.confirmCascadeDeletion(
              context,
              title: title,
              msg:
                  '${uCount.multiPlural('\$ unidad será desasociada', {1: 'es', 2: 'n'})} (pero no se ${uCount.plural('eliminará', suffix: 'n', included: false)}).',
              onConfirmed: cb,
              cancelTxt: 'Conservar',
              confirmTxt: 'Eliminar',
            );
          }
        },
      ),
    );
  }
}
