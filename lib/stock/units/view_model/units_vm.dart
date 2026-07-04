import 'package:disco/disco.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/utils/fn.dart' as utils;
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/shared/fn/mutations/index.dart';
import 'package:servicable_stock/stock/units/units_constants.dart';
import 'package:servicable_stock/stock/units/units_models.dart';
import 'package:servicable_stock/stock/units/units_repository.dart';
import 'package:servicable_stock/stock/units/units_types.dart';
import 'package:servicable_stock/stock/units/view_model/units_table_mixin.dart';
import 'package:servicable_stock/stock/units/view_model/units_update_mixin.dart';

class UnitsBaseVm with VmTrinaGridMixin {
  final bool isAdmin;
  UnitsBaseVm(this.repository, {required this.isAdmin});

  final UnitsRepository repository;

  MutationCommonParams<C, S>
  sharedMutParams<C extends Function, S extends Function>(
    BuildContext context, {
    required C cb,
    required String msgSuccessName,
    S? onSuccess,
  }) => .new(
    context,
    queryKey: kUnitsQueryKey,
    timestamped: false,
    getStateManager: getStateManager,
    successName: 'unidad',
    unauthPluralName: 'unidades',
    successMsgVocal: 'a',
    cb: cb,
    onSuccess: onSuccess,
  );
}

class UnitsVm extends UnitsBaseVm with TableMixin, UpdateMutationsMixin {
  UnitsVm(super.repository, {required super.isAdmin});

  static final instance = Provider((ctx) {
    final db = AppDatabase.instance.of(ctx);
    final isAdmin = utils.isAdmin(ctx);

    return UnitsVm(UnitsRepository(db, table: db.units), isAdmin: isAdmin);
  });

  UnitsDeleteMutation createDeleteMutation(BuildContext context) =>
      createSingleDeleteMutation(
        sharedMutParams(
          context,
          cb: repository.deleteUnit,
          msgSuccessName: 'unidad',
        ),
        isAdmin: isAdmin,
      );

  UnitsAddMutation createAddMutation(
    BuildContext context,
  ) => createSingleAddMutation(
    sharedMutParams(context, cb: repository.addUnit, msgSuccessName: 'unidad'),
    createRow: createRow,
    createNewObj: (variables, ctx) {
      final (:identifier, :details, :soldTo, :productId) = variables;
      final queryClient = ctx.client;

      final productOptions = queryClient.getQueryData<ProductForeignKeyOptions>(
        kUnitsProductOptionsQueryKey,
      );

      final productOption = productOptions?.firstWhere(
        (p) => p.id == productId,
      );

      return UnitWithDetails(
        id: -1,
        identifier: identifier,
        details: details,
        soldTo: soldTo,
        productId: productId,
        productName: productOption?.label,
        categoryName: productOption?.categoryName,
      );
    },
  );
}
