import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/shared/widgets/table_fetch_error.dart';
import 'package:servicable_stock/shared/widgets/table_loader.dart';
import 'package:trina_grid/trina_grid.dart';

class QueryTable<T> extends HookWidget {
  final QueryResult<T, dynamic> query;
  final String errorMsg;
  final TrinaGridConfiguration config;
  final List<TrinaColumn> loaderColumns;
  final Widget Function(T? data, TrinaGridConfiguration config) renderGrid;

  const QueryTable(
    this.query, {
    super.key,
    required this.errorMsg,
    required this.loaderColumns,
    required this.config,
    required this.renderGrid,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isError) {
      return TableFetchError(query, 'Error al obtener las categorías');
    }

    if (query.isLoading) {
      return tableLoader(query, config: config, columns: loaderColumns);
    }

    return renderGrid(query.data, config);
  }
}
