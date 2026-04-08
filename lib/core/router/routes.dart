import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:servicable_stock/auth/auth_screen.dart';
import 'package:servicable_stock/core/db/reset_btn.dart';
import 'package:servicable_stock/navigation_page.dart';

enum AppRoutes {
  auth('/auth', AuthScreen()),
  navigation('/', NavigationPage());

  const AppRoutes(this.path, this.view);

  final String path;
  final Widget view;

  GoRoute get route => GoRoute(
    path: path,
    builder: (context, state) =>
        kReleaseMode ? view : WithResetBtn(widget: view),
  );
}
