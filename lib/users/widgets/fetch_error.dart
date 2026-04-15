import 'package:fluent_ui/fluent_ui.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:servicable_stock/users/users_types.dart';

class FetchError extends StatelessWidget {
  final UsersQuery query;
  const FetchError(this.query, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: .circular(10),
        border: .all(color: context.theme.resources.cardStrokeColorDefault),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          spacing: 10,
          children: [
            Icon(
              FluentIcons.alert_solid,
              color: AppTheme.errorColor(context),
              size: 40,
            ),

            Text(
              'Error al obtener los usuarios',
              style: TextStyle(
                fontWeight: .bold,
                color: AppTheme.errorColor(context),
                fontSize: context.theme.typography.title?.fontSize,
              ),
            ),

            Text(
              'Error ${query.error.toString()}',
              style: context.theme.typography.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
