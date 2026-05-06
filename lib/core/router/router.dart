import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:servicable_stock/auth/auth_screen.dart';
import 'package:servicable_stock/auth/auth_state.dart';
import 'package:servicable_stock/core/db/reset_btn.dart';
import 'package:servicable_stock/core/router/not_found.dart';
import 'package:servicable_stock/navigation/navigation_pages.dart';
import 'package:servicable_stock/navigation/navigation_screen.dart';

const authPath = '/auth';

class AppRouter {
  final AuthState authState;

  AppRouter({required this.authState});

  late final config = GoRouter(
    initialLocation: MainNavigationPages.home.path,
    refreshListenable: authState,
    routes: appRoutes,
    errorBuilder: (context, state) => const NotFound(),
    redirect: handleRedirect,
  );

  FutureOr<String?> handleRedirect(BuildContext context, GoRouterState state) {
    final bool isAuthenticated = authState.isAuthenticated();

    // Redirect to login if not authenticated and not already on login
    if (!isAuthenticated && !state.matchedLocation.contains(authPath)) {
      return authPath;
    }

    // Redirect to home if authenticated and on login
    if (isAuthenticated && state.matchedLocation.contains(authPath)) {
      return MainNavigationPages.home.path;
    }

    return null; // No redirect
  }

  final List<RouteBase> appRoutes = [
    GoRoute(
      path: authPath,
      builder: (context, state) =>
          routeBuilder(context, state, const AuthScreen()),
    ),

    ShellRoute(
      builder: (context, state, currentView) {
        return routeBuilder(
          context,
          state,
          NavigationScreen(state: state, currentView: currentView),
        );
      },
      routes: MainNavigationPages.values.map((page) => page.route).toList(),
    ),
  ];
}

Widget routeBuilder(BuildContext context, GoRouterState? state, Widget view) =>
    kReleaseMode ? view : WithResetBtn(widget: view);
