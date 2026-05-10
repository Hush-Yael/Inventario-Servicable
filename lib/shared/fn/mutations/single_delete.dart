import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/utils/fn.dart' as utils;
import 'package:servicable_stock/shared/fn/mutations/index.dart'
    show MutationCommonParams;
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:trina_grid/trina_grid.dart';

typedef SingleDeleteMutation =
    MutationResult<dynamic, Object?, TrinaColumnRendererContext, int>;

typedef SingleDeleteMutationSideEffect =
    void Function(
      TrinaColumnRendererContext columnCtx,
      MutationFunctionContext ctx,
    )?;

typedef SingleDeleteMutationCb = Future<int> Function(int id);

/// Handles a delete mutation for a single model object.
/// It checks delete permission before deleting.
/// On mutation it deletes the object from the rows list.
/// On error, it readds the deleted object to the rows list.
/// On success, it deletes the object from the query list.
SingleDeleteMutation createSingleDeleteMutation<TListData extends List>(
  MutationCommonParams<SingleDeleteMutationCb, SingleDeleteMutationSideEffect>
  params, {
  required bool isAdmin,
}) {
  return useMutation(
    (ctx, _) async {
      if (!isAdmin) {
        return Future.error(
          'No tienes permiso para eliminar $params.unauthPluralName',
        );
      }

      final id = ctx.row.$id!;

      /*  return await Future.delayed(const Duration(seconds: 1), () {
        return Random().nextBool() ? Future.error('error') : id;
      }); */

      return await params.cb(id);
    },

    mutationKey: params.mutationKey,

    onMutate: (colCtx, ctx) {
      final rows = params.getStateManager()!.refRows;
      final id = colCtx.row.$id!;

      params.onMutate?.call(colCtx, ctx);

      for (var i = 0; i < rows.length; i++) {
        final row = rows[i];

        if (row.$id == id) {
          rows.removeAt(i);
          return i - 1;
        }
      }

      return rows.length - 2;
    },

    onError: (error, columnCtx, beforeIndex, ctx) {
      utils.showMsg(
        context: params.context,
        message: error.toString(),
        severity: .error,
      );

      try {
        params.getStateManager()!.refRows.insert(
          beforeIndex! + 1,
          columnCtx.row,
        );
        params.onError?.call(columnCtx, ctx);
      } catch (e) {
        print(e);
        rethrow;
      }
    },

    onSuccess: (_, columnCtx, _, ctx) {
      utils.showMsg(
        context: params.context,
        message:
            '${params.successName.uppercaseFirst()} eliminad${params.successMsgVocal}',
        severity: .success,
      );

      ctx.client.setQueryData<TListData, dynamic>(params.queryKey, (objList) {
        final id = columnCtx.row.$id!;

        objList!.removeWhere((obj) => obj.id == id);

        return objList;
      });

      params.onSuccess?.call(columnCtx, ctx);
    },
  );
}
