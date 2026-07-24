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
import 'package:khedma/features/auth/presentation/screen/role_selection_screen.dart';
import 'package:khedma/core/navigation/main_navigation_screen.dart';
import 'package:khedma/features/provider/shell/provider_main_navigation_screen.dart';
import 'package:khedma/features/provider/home/presentation/screen/provider_incoming_request_screen.dart';
import 'package:khedma/features/provider/home/presentation/screen/provider_job_details_screen.dart';
import 'package:khedma/features/provider/home/presentation/screen/provider_track_live_screen.dart';
import 'package:khedma/features/provider/profile/presentation/screen/provider_earnings_screen.dart';
import 'package:khedma/features/provider/profile/presentation/screen/provider_reviews_screen.dart';
import 'package:khedma/features/shared/chat/domain/entities/chat_entities.dart';
import 'package:khedma/features/provider/chats/presentation/screen/provider_chat_details_screen.dart';
import 'package:khedma/features/client/bookings/presentation/screens/booking_details_screen.dart';
import 'package:khedma/features/client/bookings/presentation/screens/provider_profile_screen.dart';
import 'package:khedma/features/client/customer/domain/usecases/params/customer_params.dart';
import 'package:khedma/features/client/home/presentation/screen/choose_date_time_screen.dart';
import 'package:khedma/features/client/home/presentation/screen/almost_done_screen.dart';
import 'package:khedma/features/client/home/presentation/screen/provider_found_screen.dart';
import 'package:khedma/features/client/home/presentation/screen/provider_tracking_screen.dart';
import 'package:khedma/features/client/home/presentation/screen/track_live_screen.dart';
import 'package:khedma/features/client/home/presentation/screen/confirm_location_screen.dart';
import 'package:khedma/features/client/home/presentation/screen/category_services_screen.dart';
import 'package:khedma/features/client/home/presentation/screen/home_screen.dart';
import 'package:khedma/features/client/home/presentation/screen/service_details_screen.dart';

import 'package:khedma/features/client/notifications/presentation/screens/notifications_screen.dart';

import 'package:khedma/injection_container.dart';

abstract class Routes {
  static const String initialRoute = roleSelectionRoute;
  static const String splashSecondRoute = '/SplashSecondScreen';
  static const String onBoardingRoute = '/OnBoardingScreen';
  static const String onBoardingSecondRoute = '/OnBoardingSecondScreen';
  static const String onBoardingThirdRoute = '/OnBoardingThirdScreen';
  static const String onBoardingFourthRoute = '/OnBoardingFourthScreen';
  static const String onBoardingFifthRoute = '/OnBoardingFifthScreen';
  static const String onBoardingSixthRoute = '/OnBoardingSixthScreen';
  static const String loginScreenRoute = '/LoginScreen';
  static const String passwordResetRoute = '/PasswordResetScreen';
  static const String resetPasswordRoute = '/ResetPasswordScreen';
  static const String languagePreferenceRoute = '/LanguagePreferenceScreen';
  static const String createAccountRoute = '/CreateAccountScreen';
  static const String roleSelectionRoute = '/RoleSelectionScreen';
  static const String appShellRoute = '/AppShell';
  static const String providerAppShellRoute = '/ProviderAppShell';
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
  static const String categoryServicesRoute = '/category-services';
  static const String serviceDetailsRoute = '/service-details';
  static const String confirmLocationRoute = '/confirm-location';
  static const String chooseDateTimeRoute = '/choose-date-time';
  static const String almostDoneRoute = '/almost-done';
  static const String providerTrackingRoute = '/provider-tracking';
  static const String providerFoundRoute = '/provider-found';
  static const String trackLiveRoute = '/track-live';
  static const String chatDetailsRoute = '/chat-details';
  static const String bookingDetailsRoute = '/booking-details';
  static const String providerProfileRoute = '/provider-profile';
  static const String providerReviewsRoute = '/provider-reviews';
  static const String providerEarningsRoute = '/provider-earnings';
  static const String providerIncomingRequestRoute =
      '/provider-incoming-request';
  static const String providerJobDetailsRoute = '/provider-job-details';
  static const String providerTrackLiveRoute = '/provider-track-live';

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
        name: roleSelectionRoute,
        path: roleSelectionRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const RoleSelectionScreen(),
      ),

      GoRoute(
        name: createAccountRoute,
        path: createAccountRoute,
        builder: (BuildContext context, GoRouterState state) {
          String? registrationRole;
          if (state.extra is Map) {
            final Object? v =
                (state.extra! as Map<dynamic, dynamic>)['registration_role'];
            if (v is String) {
              registrationRole = v;
            }
          }
          return CreateAccountScreen(registrationRole: registrationRole);
        },
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
        name: providerAppShellRoute,
        path: providerAppShellRoute,
        builder: (BuildContext context, GoRouterState _) =>
            const ProviderMainNavigationScreen(),
      ),
      GoRoute(
        name: homeRoute,
        path: homeRoute,
        builder: (BuildContext context, GoRouterState _) => const HomeScreen(),
      ),
      GoRoute(
        name: categoryServicesRoute,
        path: '$categoryServicesRoute/:categoryKey',
        builder: (BuildContext context, GoRouterState state) {
          return CategoryServicesScreen(
            categoryId: state.pathParameters['categoryKey'] ?? '',
            categoryName: state.extra is String ? state.extra! as String : '',
          );
        },
      ),
      GoRoute(
        name: serviceDetailsRoute,
        path: serviceDetailsRoute,
        builder: (BuildContext context, GoRouterState state) =>
            ServiceDetailsScreen(serviceId: state.extra as String),
      ),
      GoRoute(
        name: confirmLocationRoute,
        path: confirmLocationRoute,
        builder: (BuildContext context, GoRouterState state) =>
            ConfirmLocationScreen(draft: state.extra as BookingDraft),
      ),
      GoRoute(
        name: chooseDateTimeRoute,
        path: chooseDateTimeRoute,
        builder: (BuildContext context, GoRouterState state) =>
            ChooseDateTimeScreen(draft: state.extra as BookingDraft),
      ),
      GoRoute(
        name: almostDoneRoute,
        path: almostDoneRoute,
        builder: (BuildContext context, GoRouterState state) =>
            AlmostDoneScreen(draft: state.extra as BookingDraft),
      ),
      GoRoute(
        name: providerTrackingRoute,
        path: providerTrackingRoute,
        builder: (BuildContext context, GoRouterState state) =>
            ProviderTrackingScreen(bookingId: state.extra as String),
      ),
      GoRoute(
        name: providerFoundRoute,
        path: providerFoundRoute,
        builder: (BuildContext context, GoRouterState state) =>
            ProviderFoundScreen(bookingId: state.extra as String),
      ),
      GoRoute(
        name: trackLiveRoute,
        path: trackLiveRoute,
        builder: (BuildContext context, GoRouterState state) =>
            TrackLiveScreen(bookingId: state.extra as String),
      ),
      GoRoute(
        name: bookingDetailsRoute,
        path: bookingDetailsRoute,
        builder: (BuildContext context, GoRouterState state) =>
            BookingDetailsScreen(bookingId: state.extra as String),
      ),
      GoRoute(
        name: chatDetailsRoute,
        path: chatDetailsRoute,
        builder: (BuildContext context, GoRouterState state) {
          final ChatThreadEntity thread = state.extra as ChatThreadEntity;
          return ProviderChatDetailsScreen(thread: thread);
        },
      ),
      GoRoute(
        name: providerProfileRoute,
        path: providerProfileRoute,
        builder: (BuildContext context, GoRouterState state) {
          if (state.extra is Map<String, String>) {
            final extra = state.extra! as Map<String, String>;
            return ProviderProfileScreen(
              providerId: extra['providerId'] ?? '',
              serviceId: extra['serviceId'],
            );
          }
          return ProviderProfileScreen(providerId: state.extra as String);
        },
      ),
      GoRoute(
        name: providerReviewsRoute,
        path: providerReviewsRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const ProviderReviewsScreen(),
      ),
      GoRoute(
        name: providerEarningsRoute,
        path: providerEarningsRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const ProviderEarningsScreen(),
      ),
      GoRoute(
        name: providerIncomingRequestRoute,
        path: providerIncomingRequestRoute,
        builder: (BuildContext context, GoRouterState state) =>
            ProviderIncomingRequestScreen(bookingId: state.extra as String),
      ),
      GoRoute(
        name: providerJobDetailsRoute,
        path: providerJobDetailsRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const ProviderJobDetailsScreen(),
      ),
      GoRoute(
        name: providerTrackLiveRoute,
        path: providerTrackLiveRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const ProviderTrackLiveScreen(),
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
