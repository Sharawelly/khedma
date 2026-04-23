import 'package:khedma/config/routes/app_routes.dart';
import 'package:khedma/core/utils/log_utils.dart';
import 'package:khedma/injection_container.dart';
import 'package:flutter/material.dart';

class AppNavigatorObserver extends NavigatorObserver {
  String? currentRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      currentRoute = route.settings.name;
      Routes.pushRouteToRoutesStack(route.settings.name!);
    }
    Log.i(
      '@ROUTES: [push] current: ${route.settings.name}, previous: ${previousRoute?.settings.name}, routesStack: ${routesStack.toString()}',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name != null) {
      currentRoute = previousRoute?.settings.name;
      Routes.popRouteFromRoutesStack();
    }
    Log.i(
      '@ROUTES: [pop] current: ${route.settings.name}, previous: ${previousRoute?.settings.name}, routesStack: ${routesStack.toString()}',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute?.settings.name != null) {
      Routes.popRouteFromRoutesStack();
    }
    if (newRoute?.settings.name != null) {
      Routes.pushRouteToRoutesStack(newRoute!.settings.name!);
    }
    Log.i(
      '@ROUTES: [replace] current: ${newRoute?.settings.name}, previous: ${oldRoute?.settings.name}, routesStack: ${routesStack.toString()}',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (route.settings.name != null && routesStack.isNotEmpty) {
      final lastRoute = routesStack.last;
      routesStack
        ..clear()
        ..add(lastRoute);
    }
    Log.i(
      '@ROUTES: [remove] current: ${route.settings.name}, previous: ${previousRoute?.settings.name}, routesStack: ${routesStack.toString()}',
    );
  }
}
