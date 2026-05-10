import 'package:fluent_ui/fluent_ui.dart';
import 'package:trina_grid/trina_grid.dart';

export 'single_delete.dart';
export 'single_update.dart';
export 'single_add.dart';

class MutationCommonParams<
  Callback extends Function,
  SideEffect extends Function?
> {
  final BuildContext context;
  final List<String> queryKey;
  final List<String>? mutationKey;
  final TrinaGridStateManager? Function() getStateManager;

  /// Name to be shown in the success message
  final String successName;

  /// Plural form of the object name, shown in the unauthorized error message
  final String unauthPluralName;

  /// Suffix added to the performed action word next to the object name in the success message
  final String successMsgVocal;

  /// Whether the mutation should update the 'updatedAt' field
  final bool timestamped;

  /// The async function that performs the mutation on the db
  final Callback cb;

  /// Do something before the mutation resolves
  final SideEffect? onMutate;

  /// Do something when the mutation fails
  final SideEffect? onError;

  /// Do something when the mutation succeeds
  final SideEffect? onSuccess;

  const MutationCommonParams(
    this.context, {
    required this.queryKey,
    required this.timestamped,
    required this.cb,
    required this.getStateManager,
    required this.successName,
    required this.unauthPluralName,
    this.successMsgVocal = 'o',
    this.mutationKey,
    this.onMutate,
    this.onError,
    this.onSuccess,
  });
}
