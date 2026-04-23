// app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:khedma/config/routes/initial_deep_link.dart';
import 'package:khedma/config/routes/navigator_observer.dart';

import 'package:khedma/features/auth/presentation/cubit/login/login_cubit.dart';

import 'package:khedma/features/auth/presentation/screen/login_screen.dart';
import 'package:khedma/features/auth/presentation/screen/language_preference_screen.dart';
import 'package:khedma/features/auth/presentation/screen/create_account_screen.dart';
import 'package:khedma/core/navigation/main_navigation_screen.dart';
import 'package:khedma/features/home/presentation/screen/home_screen.dart';

import 'package:khedma/features/notifications/presentation/screens/notifications_screen.dart';

import 'package:khedma/injection_container.dart';

abstract class Routes {
  static const String initialRoute = appShellRoute;
  static const String splashSecondRoute = '/SplashSecondScreen';
  static const String onBoardingRoute = '/OnBoardingScreen';
  static const String onBoardingSecondRoute = '/OnBoardingSecondScreen';
  static const String onBoardingThirdRoute = '/OnBoardingThirdScreen';
  static const String onBoardingFourthRoute = '/OnBoardingFourthScreen';
  static const String onBoardingFifthRoute = '/OnBoardingFifthScreen';
  static const String onBoardingSixthRoute = '/OnBoardingSixthScreen';
  static const String countrySelectionRoute = '/CountrySelectionScreen';
  static const String loginScreenRoute = '/LoginScreen';
  static const String passwordResetRoute = '/PasswordResetScreen';
  static const String resetPasswordRoute = '/ResetPasswordScreen';
  static const String languagePreferenceRoute = '/LanguagePreferenceScreen';
  static const String createAccountRoute = '/CreateAccountScreen';
  static const String roleSelectionRoute = '/RoleSelectionScreen';
  static const String appShellRoute = '/AppShell';
  static const String blocksHistoryRoute = '/blocks/history';
  static const String blockDetailRoute = '/blocks/detail';
  static const String blockShowcaseRoute = '/blocks/showcase';
  static const String kitDetailsRoute = '/kits/details';
  static const String weeklyAssessmentRoute = '/kits/assessment';
  static const String assessmentResultsRoute = '/kits/assessment/results';
  static const String pathDetailsRoute = '/paths/details';
  static const String pathModuleDetailRoute = '/paths/module-detail';
  static const String pathDocumentViewerRoute = '/paths/document-viewer';
  static const String settingsRoute = '/settings';
  static const String notificationsRoute = '/notifications';
  static const String homeRoute = '/home';

  static final _sl = ServiceLocator.instance;

  static final router = GoRouter(
    observers: [AppNavigatorObserver()],
    initialLocation: initialDeepLinkPath ?? initialRoute,

    routes: <RouteBase>[
      GoRoute(
        name: loginScreenRoute,
        path: loginScreenRoute,
        builder: (_, _) => BlocProvider(
          create: (_) => _sl<LoginCubit>(),
          child: const LoginScreen(),
        ),
      ),

      GoRoute(
        name: languagePreferenceRoute,
        path: languagePreferenceRoute,
        builder: (_, _) => const LanguagePreferenceScreen(),
      ),

      GoRoute(
        name: createAccountRoute,
        path: createAccountRoute,
        builder: (_, _) => const CreateAccountScreen(),
      ),

      GoRoute(
        name: notificationsRoute,
        path: notificationsRoute,
        builder: (BuildContext context, GoRouterState _) =>
            const NotificationsScreen(),
      ),
      GoRoute(
        name: appShellRoute,
        path: appShellRoute,
        builder: (BuildContext context, GoRouterState _) =>
            const MainNavigationScreen(),
      ),
      GoRoute(
        name: homeRoute,
        path: homeRoute,
        builder: (BuildContext context, GoRouterState _) => const HomeScreen(),
      ),
    ],
  );

  static String get currentRoute => routesStack.last;
  static void pushRouteToRoutesStack(String route) {
    routesStack.add(route);
    ServiceLocator.injectRoutesStackSingleton(routesStack);
  }

  static void popRouteFromRoutesStack() {
    routesStack.removeLast();
    ServiceLocator.injectRoutesStackSingleton(routesStack);
  }
}
