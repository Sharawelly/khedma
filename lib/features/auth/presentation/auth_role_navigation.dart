import '/config/routes/app_routes.dart';

abstract final class AuthRoleNavigation {
  static String? routeForRole(String role) {
    return switch (role) {
      'Customer' => Routes.appShellRoute,
      'Provider' => Routes.providerAppShellRoute,
      _ => null,
    };
  }
}
