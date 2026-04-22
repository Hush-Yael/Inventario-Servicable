import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:trina_grid/trina_grid.dart';

TrinaGrid tableLoader(
  QueryResult query, {
  required TrinaGridConfiguration config,
  required List<TrinaColumn> columns,
}) => TrinaGrid(
  // Prevent rerendering the loader when it is retrying, but don't show it when it succeeds or not
  key: query.failureCount == 0 && query.isFetching ? UniqueKey() : null,

  rows: const [],

  mode: .readOnly,

  configuration: config,

  onLoaded: (event) => event.stateManager.setShowLoading(
    true,
    customLoadingWidget: const _Loader(),
  ),

  columns: columns,
);

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.brightness == Brightness.dark
            ? Colors.black.withAlpha(90)
            : Colors.black.withAlpha(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 14,
          children: [
            const ProgressRing(),

            Text('Cargando...', style: context.theme.typography.subtitle),
          ],
        ),
      ),
    );
  }
}
