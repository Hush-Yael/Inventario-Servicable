import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/utils/fn.dart';
import 'package:servicable_stock/core/utils/table_utils.dart';
import 'package:servicable_stock/shared/fn/mutations/index.dart'
    show MutationCommonParams;
import 'package:trina_grid/trina_grid.dart';

typedef SingleUpdateMutation =
    MutationResult<dynamic, Object?, TrinaGridOnChangedEvent, DateTime?>;

typedef SingleUpdateMutationCb =
    Future<int> Function(
      int id,
      dynamic newValue, [
      MutationFunctionContext? ctx,
    ]);

typedef SingleUpdateMutationSideEffect =
    void Function(TrinaGridOnChangedEvent event, MutationFunctionContext ctx)?;

/// Handles an update mutation for a single model object.
/// It checks update permission before updating.
/// On mutation it updates the date fields if [params.timestamped] is true.
/// On error, it reverts the changes.
/// On success, it updates the query data changing the [params.propName] property with the new value and 'updatedAt' field if [params.timestamped] is true.
/// [propName] is the name of the property to update.
SingleUpdateMutation createSingleUpdateMutation(
  MutationCommonParams<SingleUpdateMutationCb, SingleUpdateMutationSideEffect>
  params, {
  required String propName,
}) {
  return useMutation(
    (event, ctx) async {
      if (!hasPerm(params.context, .operator)) {
        return Future.error(
          'No tienes permiso para editar $params.objPluralName',
        );
      }

      final int id = event.row.$id!;
      final newValue = event.value;

      // return await Future.error('error');
      return await params.cb(id, newValue, ctx);
    },

    mutationKey: params.mutationKey,

    onMutate: (event, ctx) {
      params.getStateManager()?.setEditing(
        false,
      ); // important! prevents crashing

      if (params.timestamped) {
        final field = 'updatedAt';

        final previousUpdatedAt = event.row.cellValue<DateTime>(field);

        event.row.cells[field] = TrinaCell(value: DateTime.now());

        return previousUpdatedAt;
      }

      params.onMutate?.call(event, ctx);

      return null;
    },

    onError: (error, event, previousUpdatedAt, ctx) {
      showMutationResultMsg(
        context: params.context,
        message: error.toString(),
        severity: .error,
      );

      try {
        event.cell.value = event.oldValue;

        if (params.timestamped) {
          final createdAt = event.row.cellValue<DateTime>('createdAt');

          event.row.cells['updatedAt'] = getUpdatedAtCell(
            createdAt,
            previousUpdatedAt!,
          );
        }

        params.onError?.call(event, ctx);
      } catch (e) {
        print(e);
      }
    },

    onSuccess: (_, event, _, ctx) {
      showMutationResultMsg(
        context: params.context,
        message:
            '${params.objName.uppercaseFirst()} actualizad${params.successMsgVocal}',
        severity: .success,
      );

      if (params.timestamped) {
        ctx.client.setQueryData<List, dynamic>(params.queryKey, (objList) {
          final int id = event.row.$id!;

          for (var i = 0; i < objList!.length; i++) {
            final obj = objList[i];

            if (obj.id == id) {
              objList[i] = Function.apply(obj.copyWith, null, {
                Symbol(propName): event.value,
                if (params.timestamped)
                  #updatedAt: event.row.cellValue<DateTime>('updatedAt'),
              });

              return objList;
            }
          }

          return objList;
        });
      }

      params.onSuccess?.call(event, ctx);
    },
  );
}
