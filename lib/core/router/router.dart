import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:servicable_stock/auth/auth_controller.dart';
import 'package:servicable_stock/core/router/not_found.dart';
import 'package:servicable_stock/core/router/routes.dart';

class AppRouter {
  final AuthController authController;

  AppRouter({required this.authController});

  late final config = GoRouter(
    initialLocation: AppRoutes.navigation.path,
    refreshListenable: authController,
    routes: routesList,
    errorBuilder: (context, state) => const NotFound(),
    redirect: handleRedirect,
  );

  FutureOr<String?> handleRedirect(BuildContext context, GoRouterState state) {
    final bool isAuthenticated = authController.isAuthenticated();

    // Redirect to login if not authenticated and not already on login
    if (!isAuthenticated &&
        !state.matchedLocation.contains(AppRoutes.auth.path)) {
      return AppRoutes.auth.path;
    }
    // Redirect to home if authenticated and on login
    if (isAuthenticated &&
        state.matchedLocation.contains(AppRoutes.auth.path)) {
      return AppRoutes.navigation.path;
    }

    return null; // No redirect
  }

  final List<RouteBase> routesList = [
    AppRoutes.auth.route,
    AppRoutes.navigation.route,
  ];
}
