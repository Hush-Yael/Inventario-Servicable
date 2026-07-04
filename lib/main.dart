import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/db/auto_login.dart';
import 'package:servicable_stock/core/router/router.dart';
import 'package:servicable_stock/core/theme/theme_mode_state.dart';
import 'package:servicable_stock/core/setup_page.dart';
import 'package:servicable_stock/core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SetupPage(app: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeModeState themeMode = ThemeModeState.instance.of(context);

    // auto login as admin in debug mode
    if (kDebugMode) autoLogin(context);

    return SignalBuilder(
      builder: (context, child) {
        return FluentApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Servicable Stock',
          themeMode: themeMode.state.value,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: AppRouter(
            authState: AuthState.instance.of(context),
          ).config,
        );
      },
    );
  }
}
