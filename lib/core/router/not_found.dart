import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:servicable_stock/core/router/routes.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          spacing: 30,
          children: [
            Column(
              spacing: 5,
              children: [
                Text('404', style: FluentTheme.of(context).typography.title),

                Text(
                  'Ruta no encontrada',
                  style: FluentTheme.of(context).typography.title,
                ),

                const Text('Parece que la página que buscas no existe'),
              ],
            ),

            FilledButton(
              child: const SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: .center,
                  spacing: 7,
                  children: [Icon(FluentIcons.home), Text('Ir al inicio')],
                ),
              ),
              onPressed: () => context.go(AppRoutes.navigation.path),
            ),
          ],
        ),
      ),
    );
  }
}
