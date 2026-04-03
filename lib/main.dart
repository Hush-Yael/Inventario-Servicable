import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:servicable_stock/auth/login_screen.dart';
import 'package:servicable_stock/controllers/theme_controller.dart';
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
    final ThemeController theme = ThemeController.provider.of(context);

    return SignalBuilder(
      builder: (context, child) {
        return FluentApp(
          debugShowCheckedModeBanner: false,
          title: 'Windows UI for Flutter',
          themeMode: theme.mode.value,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: LoginScreen(),
        );
      },
    );
  }
}
