// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:performa/config/routes/app_routes.dart';
// import 'package:performa/core/utils/log_utils.dart';

// import '/config/routes/navigator_observer.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await NotificationService.instance.setupFlutterNotifications();
//   await NotificationService.instance.showNotification(message);
// }

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// final AppNavigatorObserver routeObserver = AppNavigatorObserver();

// class NotificationService {
//   NotificationService._();
//   static final NotificationService instance = NotificationService._();

//   final _messaging = FirebaseMessaging.instance;
//   final _localNotifications = FlutterLocalNotificationsPlugin();
//   bool _isFlutterLocalNotificationsInitialized = false;

//   Future<void> initialize() async {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Request permission
//     await _requestPermission();

//     // Setup message handlers
//     await _setupMessageHandlers();

//     await setupFlutterNotifications();

//     // Get FCM token and log for debugging (may fail on emulator / no Play Services)
//     final token = await getFcmTokenSafe();
//     if (token != null && token.isNotEmpty) {
//       Log.d('[FCM Device Token] $token');
//     } else {
//       Log.d(
//         '[FCM Device Token] (empty or unavailable - e.g. emulator without Play Services)',
//       );
//     }
//   }

//   /// Returns FCM token or null if unavailable (e.g. SERVICE_NOT_AVAILABLE on emulator).
//   /// Use this instead of FirebaseMessaging.instance.getToken() to avoid unhandled exceptions.
//   Future<String?> getFcmTokenSafe() async {
//     try {
//       return await _messaging.getToken();
//     } catch (e, st) {
//       Log.e('FCM getToken failed: $e');
//       Log.d(st.toString());
//       return null;
//     }
//   }

//   Future<void> _requestPermission() async {
//     // ignore: unused_local_variable
//     final settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   Future<void> setupFlutterNotifications() async {
//     if (_isFlutterLocalNotificationsInitialized) {
//       return;
//     }

//     // android setup
//     const channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.high,
//     );

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);

//     const initializationSettingsAndroid = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );

//     // ios setup
//     // ignore: prefer_const_constructors
//     final initializationSettingsDarwin = DarwinInitializationSettings();

//     final initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );

//     // flutter notification setup
//     await _localNotifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse details) {
//         _onSelect();
//       },
//     );

//     _isFlutterLocalNotificationsInitialized = true;
//   }

//   Future<void> showNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       const notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel',
//           'High Importance Notifications',
//           channelDescription:
//               'This channel is used for important notifications.',
//           importance: Importance.high,
//           priority: Priority.high,
//           icon: '@mipmap/ic_launcher',
//         ),
//         iOS: DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       );
//       await _localNotifications.show(
//         notification.hashCode,
//         notification.title ?? '',
//         notification.body ?? '',
//         notificationDetails,
//         payload: json.encode(message.data),
//       );
//     }
//   }

//   Future<void> _setupMessageHandlers() async {
//     //foreground message
//     FirebaseMessaging.onMessage.listen((message) {
//       showNotification(message);
//     });

//     // background message
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

//     // opened app
//     final initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       _handleBackgroundMessage(initialMessage);
//     }
//   }

//   void _handleBackgroundMessage(RemoteMessage message) {
//     log(message.data.toString());
//     Log.e(message.data['message'].toString());
//     _onSelect();
//   }

//   bool _pendingNavigateToNotifications = false;
//   bool _appPastSplash = false;

//   /// Call from splash when leaving so we know app is ready for direct navigation.
//   void setAppPastSplash() {
//     _appPastSplash = true;
//   }

//   /// Call when user taps a notification. Navigation will happen after splash.
//   void setPendingNavigateToNotifications() {
//     _pendingNavigateToNotifications = true;
//   }

//   /// Returns true if a notification tap was pending. Call after splash has navigated.
//   bool consumePendingNavigateToNotifications() {
//     final value = _pendingNavigateToNotifications;
//     _pendingNavigateToNotifications = false;
//     return value;
//   }

//   void _onSelect() {
//     if (_appPastSplash) {
//       try {
//         Routes.router.go(Routes.notificationsRoute);
//       } catch (e) {
//         Log.e('Navigate to notifications: $e');
//         setPendingNavigateToNotifications();
//       }
//     } else {
//       setPendingNavigateToNotifications();
//     }
//   }
// }
