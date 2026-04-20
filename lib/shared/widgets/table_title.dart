import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:intl/intl.dart';
import 'package:servicable_stock/core/theme/theme.dart';

/// Shows a title with total count or a refresh indicator
class TableTitle<T extends QueryResult<List, dynamic>> extends StatelessWidget {
  final T query;
  final String text;
  final TextStyle? style;

  const TableTitle({
    super.key,
    required this.query,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        Text(text, style: style),
        getAdjacent(context),
      ],
    );
  }

  Widget getAdjacent(BuildContext context) {
    // refresh indicator
    if (query.isRefetching) {
      return Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 20,
          height: 20,
          child: ProgressRing(
            strokeWidth: 4,
            backgroundColor: context.theme.accentColor.withAlpha(80),
          ),
        ),
      );
    }

    if (query.data == null) return const SizedBox.shrink();

    // total count
    return InfoBadge.informational(
      source: Text(
        NumberFormat.compact(
          locale: Localizations.localeOf(context).languageCode,
        ).format(query.data?.length),
      ),
    );
  }
}
