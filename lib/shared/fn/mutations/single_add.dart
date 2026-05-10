import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/shared/fn/mutations/index.dart';
import 'package:trina_grid/trina_grid.dart';

typedef SingleAddMutation<Variables, NewObj extends Object> =
    MutationResult<int, Object?, Variables, ({TrinaRow row, NewObj newObj})>;

typedef SingleAddMutationCb<Variables, AddedObj extends dynamic> =
    Future<AddedObj> Function(Variables variables);

typedef SingleAddMutationSideEffect<Variables, NewObj extends Object> =
    void Function(Variables variables, ({TrinaRow row, NewObj newObj}) record);

/// Handles the addition of a single model object.
/// It checks add permission before adding.
/// On mutation it create a new row using a new object and adds it to the rows list.
/// On error, the new row is removed from the rows list.
/// On success, the new object is added to the query list.
SingleAddMutation<Variables, NewObj>
createSingleAddMutation<Variables, NewObj extends Object>(
  MutationCommonParams<
    SingleAddMutationCb<Variables, NewObj>,
    SingleAddMutationSideEffect
  >
  params, {
  required NewObj Function(Variables variables, MutationFunctionContext ctx)
  createNewObj,
  required TrinaRow Function(int rowsLength, NewObj newObj) createRow,
}) => useMutation(
  (Variables variables, _) async {
    if (!hasPerm(params.context, .operator)) {
      return Future.error(
        'No tienes permiso para añadir ${params.unauthPluralName}',
      );
    }

    /* return await Future.delayed(const Duration(seconds: 2), () {
      return Future.error('error');
      return 11;
    }); */

    final newObj = await params.cb(variables);
    return (newObj as dynamic).id;
  },

  mutationKey: params.mutationKey,

  onMutate: (variables, ctx) {
    try {
      final state = params.getStateManager()!;

      final newObj = createNewObj(variables, ctx);

      final newRow = createRow(state.refRows.length, newObj);

      state.insertRows(state.refRows.length, [newRow]);

      final record = (row: newRow, newObj: newObj);

      params.onMutate?.call(variables, record);

      return record;
    } catch (e) {
      print(e);
      rethrow;
    }
  },

  onSuccess: (addedId, variables, returned, ctx) {
    showMsg(
      context: params.context,
      message:
          '${params.successName.uppercaseFirst()} añadid${params.successMsgVocal}',
      severity: .success,
    );

    returned!.row.$id = addedId;

    ctx.client.setQueryData<List, dynamic>(params.queryKey, (list) {
      list!.add(
        Function.apply((returned.newObj as dynamic).copyWith, null, {
          #id: addedId,
        }),
      );
      return list;
    });

    params.onSuccess?.call(variables, returned);
  },

  onError: (error, variables, returned, ctx) {
    showMsg(
      context: params.context,
      message: error.toString(),
      severity: .error,
    );

    final state = params.getStateManager()!;

    state.refRows.remove(returned!.row);

    params.onError?.call(variables, returned);

    state.notifyListeners();
  },
);
