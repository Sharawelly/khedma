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
import 'package:khedma/features/chats/presentation/screen/chat_details_screen.dart';
import 'package:khedma/features/chats/presentation/widgets/chat_thread_card.dart';
import 'package:khedma/features/bookings/presentation/screens/booking_details_screen.dart';
import 'package:khedma/features/bookings/presentation/screens/provider_profile_screen.dart';
import 'package:khedma/features/bookings/presentation/widgets/booking_service_card.dart';
import 'package:khedma/features/home/presentation/screen/choose_date_time_screen.dart';
import 'package:khedma/features/home/presentation/screen/almost_done_screen.dart';
import 'package:khedma/features/home/presentation/screen/provider_found_screen.dart';
import 'package:khedma/features/home/presentation/screen/provider_tracking_screen.dart';
import 'package:khedma/features/home/presentation/screen/track_live_screen.dart';
import 'package:khedma/features/home/presentation/screen/confirm_location_screen.dart';
import 'package:khedma/features/home/presentation/screen/category_services_screen.dart';
import 'package:khedma/features/home/presentation/screen/home_screen.dart';
import 'package:khedma/features/home/presentation/screen/service_details_screen.dart';
import 'package:khedma/features/home/presentation/widgets/category_service_card.dart';
import 'package:khedma/core/utils/values/img_manager.dart';

import 'package:khedma/features/notifications/presentation/screens/notifications_screen.dart';

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
          return CreateAccountScreen(
            registrationRole: registrationRole,
          );
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
        name: homeRoute,
        path: homeRoute,
        builder: (BuildContext context, GoRouterState _) => const HomeScreen(),
      ),
      GoRoute(
        name: categoryServicesRoute,
        path: '$categoryServicesRoute/:categoryKey',
        builder: (BuildContext context, GoRouterState state) =>
            CategoryServicesScreen(
              categoryKey: state.pathParameters['categoryKey'] ?? 'cleaning',
            ),
      ),
      GoRoute(
        name: serviceDetailsRoute,
        path: serviceDetailsRoute,
        builder: (BuildContext context, GoRouterState state) {
          final CategoryServiceItemData item =
              state.extra is CategoryServiceItemData
              ? state.extra! as CategoryServiceItemData
              : const CategoryServiceItemData(
                  categoryTitleKey: 'home_category_cleaning',
                  titleKey: 'home_cleaning_service_deep_cleaning_title',
                  subtitleKey: 'home_cleaning_service_deep_cleaning_subtitle',
                  durationKey: 'home_duration_90_min',
                  imageUrl:
                      'https://images.unsplash.com/photo-1581578731548-c64695cc6952?auto=format&fit=crop&w=600&q=80',
                );
          return ServiceDetailsScreen(item: item);
        },
      ),
      GoRoute(
        name: confirmLocationRoute,
        path: confirmLocationRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const ConfirmLocationScreen(),
      ),
      GoRoute(
        name: chooseDateTimeRoute,
        path: chooseDateTimeRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const ChooseDateTimeScreen(),
      ),
      GoRoute(
        name: almostDoneRoute,
        path: almostDoneRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const AlmostDoneScreen(),
      ),
      GoRoute(
        name: providerTrackingRoute,
        path: providerTrackingRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const ProviderTrackingScreen(),
      ),
      GoRoute(
        name: providerFoundRoute,
        path: providerFoundRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const ProviderFoundScreen(),
      ),
      GoRoute(
        name: trackLiveRoute,
        path: trackLiveRoute,
        builder: (BuildContext context, GoRouterState state) =>
            const TrackLiveScreen(),
      ),
      GoRoute(
        name: bookingDetailsRoute,
        path: bookingDetailsRoute,
        builder: (BuildContext context, GoRouterState state) {
          final BookingServiceItemData booking =
              state.extra is BookingServiceItemData
              ? state.extra! as BookingServiceItemData
              : BookingServiceItemData(
                  serviceTitleKey: 'bookings_service_plumbing_title',
                  providerNameKey: 'bookings_provider_fixit',
                  dateTimeKey: 'bookings_time_1',
                  status: BookingStatus.active,
                  iconData: Icons.plumbing_rounded,
                  iconColor: colors.pathsInfoAccent,
                  serviceCategoryKey: 'bookings_category_plumbing',
                  serviceDescriptionKey: 'bookings_service_plumbing_description',
                  timeRangeKey: 'bookings_time_range_1',
                  locationAddressKey: 'bookings_location_address_1',
                  providerRatingText: '4.9',
                  paymentAmountKey: 'bookings_payment_amount_1',
                  paymentStatusKey: 'bookings_payment_status_paid',
                  paymentMethodKey: 'bookings_payment_method_1',
                  serviceImageUrl: ImageAssets.bookingsServiceFaucet,
                  locationImageUrl: ImageAssets.bookingsLocationMap,
                  providerImageUrl: ImageAssets.bookingsProviderAvatar,
                );
          return BookingDetailsScreen(booking: booking);
        },
      ),
      GoRoute(
        name: chatDetailsRoute,
        path: chatDetailsRoute,
        builder: (BuildContext context, GoRouterState state) {
          final ChatThreadData thread = state.extra is ChatThreadData
              ? state.extra! as ChatThreadData
              : const ChatThreadData(
                  nameKey: 'chat_thread_ahmed_plumber',
                  lastMessageKey: 'chat_thread_ahmed_last_message',
                  timeKey: 'chat_thread_time_2m',
                  roleKey: 'chat_thread_role_plumbing',
                  imageUrl:
                      'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?auto=format&fit=crop&w=300&q=80',
                  categoryKey: 'plumbing',
                );
          return ChatDetailsScreen(thread: thread);
        },
      ),
      GoRoute(
        name: providerProfileRoute,
        path: providerProfileRoute,
        builder: (BuildContext context, GoRouterState state) {
          final BookingServiceItemData booking =
              state.extra is BookingServiceItemData
              ? state.extra! as BookingServiceItemData
              : BookingServiceItemData(
                  serviceTitleKey: 'bookings_service_plumbing_title',
                  providerNameKey: 'bookings_provider_fixit',
                  dateTimeKey: 'bookings_time_1',
                  status: BookingStatus.active,
                  iconData: Icons.plumbing_rounded,
                  iconColor: colors.pathsInfoAccent,
                  serviceCategoryKey: 'bookings_category_plumbing',
                  serviceDescriptionKey: 'bookings_service_plumbing_description',
                  timeRangeKey: 'bookings_time_range_1',
                  locationAddressKey: 'bookings_location_address_1',
                  providerRatingText: '4.9',
                  paymentAmountKey: 'bookings_payment_amount_1',
                  paymentStatusKey: 'bookings_payment_status_paid',
                  paymentMethodKey: 'bookings_payment_method_1',
                  serviceImageUrl: ImageAssets.bookingsServiceFaucet,
                  locationImageUrl: ImageAssets.bookingsLocationMap,
                  providerImageUrl: ImageAssets.bookingsProviderAvatar,
                );
          return ProviderProfileScreen(booking: booking);
        },
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
