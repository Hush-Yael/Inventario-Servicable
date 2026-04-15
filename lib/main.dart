import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/router/router.dart';
import 'package:servicable_stock/core/controllers/theme_controller.dart';
import 'package:servicable_stock/core/setup_page.dart';
import 'package:servicable_stock/core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SetupPage(app: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final ThemeController theme = ThemeController.instance.of(context);

    return SignalBuilder(
      builder: (context, child) {
        return FluentApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Servicable Stock',
          themeMode: theme.mode.value,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: AppRouter(
            authController: AuthState.instance.of(context),
          ).config,
        );
      },
    );
  }
}
