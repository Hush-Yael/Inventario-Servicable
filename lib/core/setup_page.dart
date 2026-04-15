import 'package:fluent_ui/fluent_ui.dart';
import 'package:disco/disco.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/shared_preferences.dart';
import 'package:servicable_stock/core/theme/theme_mode_state.dart';
import 'package:servicable_stock/core/db/db.dart';
import 'package:servicable_stock/core/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class SetupPage extends StatefulWidget {
  final Widget app;
  const SetupPage({super.key, required this.app});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late final initialization = Future(() async {
    await WindowManager.instance.ensureInitialized();
    await WindowManager.instance.setTitle("Sistema de inventario - Servicable");

    final prefs = await SharedPreferences.getInstance();
    return (preferences: prefs);
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else if (snapshot.hasError) {
          return Error(snapshot: snapshot);
        }

        final data = snapshot.data!;

        return QueryClientProvider(
          create: (context) => QueryClient(
            defaultQueryOptions: .new(
              refetchOnResume: .never,
              refetchOnReconnect: .never,
            ),
          ),
          child: ProviderScope(
            providers: [
              sharedPrefsInstance(data.preferences),
              ThemeModeState.instance,
              AppDatabase.instance,
              AuthState.instance,
            ],
            child: widget.app,
          ),
        );
      },
    );
  }
}

class Error extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const Error({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: Text('Error: ${snapshot.error}')),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      themeMode: .system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: ScaffoldPage(
        content: Center(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ProgressBar(),
              Text(
                'Iniciando, por favor espere...',
                style: TextStyle(fontSize: 16, fontWeight: .bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
