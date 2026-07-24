// ignore_for_file: unnecessary_nullable_for_final_variable_declarations

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '/core/base_classes/api_error.dart';
import '../../injection_container.dart';
import '../config/app_config.dart';
import '../error/exceptions.dart';
import '../utils/extension.dart';
import '../utils/log_utils.dart';
import '../utils/values/strings.dart';
import 'status_code.dart';

abstract class ApiConstants {
  static const String baseUrl = AppConfig.baseUrl;

  // Auth
  static const String login = '/auth/login';
  static const String registerCustomer = '/auth/register/customer';
  static const String registerProvider = '/auth/register/provider';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Profile
  static const String profile = '/profile';
  static const String changePassword = '/profile/change-password';
  static const String profileAddresses = '/profile/addresses';
  static const String profileCertificates = '/profile/certificates';
  static const String profilePortfolio = '/profile/portfolio';
  static String profileAddress(String id) => '/profile/addresses/$id';
  static String profileCertificate(String id) => '/profile/certificates/$id';
  static String profilePortfolioImage(String id) => '/profile/portfolio/$id';

  // Catalog
  static const String publicCategories = '/categories/public';
  static const String publicServices = '/services/public';
  static const String publicProviders = '/providers/public';
  static String publicService(String id) => '/services/public/$id';
  static String publicProvider(String id) => '/providers/$id/public';

  // Booking
  static const String booking = '/Booking';
  static const String directBooking = '/Booking/direct';
  static const String bookingHistory = '/Booking/history';

  /// Price for a service without creating anything, so checkout can show the
  /// figures before the customer commits.
  static const String bookingQuote = '/Booking/quote';
  static String bookingDetails(String id) => '/Booking/$id';
  static String acceptBooking(String id) => '/Booking/$id/accept';
  static String rejectBooking(String id) => '/Booking/$id/reject';
  static String completeBooking(String id) => '/Booking/$id/complete';
  static String markBookingEnRoute(String id) => '/Booking/$id/mark-en-route';
  static String markBookingArrived(String id) => '/Booking/$id/mark-arrived';
  static String markBookingInProgress(String id) =>
      '/Booking/$id/mark-in-progress';
  static String retryBookingPayment(String id) => '/Booking/$id/retry-payment';
  static String bookingEta(String id) => '/bookings/$id/eta';
  static String bookingRoute(String id) => '/bookings/$id/route';

  // Provider
  static const String pendingJobs = '/provider/pending-jobs';
  static const String providerAvailability = '/provider/availability';
  static const String providerServices = '/provider/services';
  static const String providerEarnings = '/providers/earnings';
  static const String providerWallet = '/providers/wallet';
  static const String providerPayouts = '/providers/payouts';
  static const String updateLocation = '/location/update';

  // Chat
  static const String chatThreads = '/chat/threads';
  static String chatHistory(String bookingId) => '/chat/$bookingId/history';
  static String chatMessages(String bookingId) => '/chat/$bookingId/messages';
  static String chatAttachments(String bookingId) =>
      '/chat/$bookingId/attachments';
  static String markChatRead(String bookingId) => '/chat/$bookingId/read';

  // Notifications
  static const String notifications = '/Notifications';
  static const String readAllNotifications = '/Notifications/read-all';
  static String notification(String id) => '/Notifications/$id';
  static String readNotification(String id) => '/Notifications/$id/read';

  // Reviews
  static const String reviews = '/Reviews';
  static String review(String id) => '/Reviews/$id';
  static String replyToReview(String id) => '/Reviews/$id/reply';
  static String providerReviews(String providerId) =>
      '/Reviews/provider/$providerId';

  // Favorites
  static const String favorites = '/Favorites';
  static String favoriteProvider(String providerId) => '/Favorites/$providerId';
}

abstract class DioConsumer {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});

  Future<dynamic> post(
    String path, {
    FormData? formData,
    Object? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> put(
    String path, {
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
  });

  void updateCountryIdParameter(int countryId);

  void updateLanguageCodeHeader();
  void updateDeviceTokenHeader();
  void updateDeviceTypeHeader();
}

class DioConsumerImpl implements DioConsumer {
  final Dio client;

  DioConsumerImpl({required this.client}) {
    (client.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      // client.findProxy = (uri) {
      // Proxy all request to localhost:8888.
      // Be aware, the proxy should went through you running device,
      // not the host platform.
      //   return 'PROXY https://doctor-app-production.up.railway.app';
      // };

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    Map<String, String> header = {
      HttpHeaders.acceptHeader: 'application/json',
      // TODO: Remove this after testing
      // 'Cache-Control': 'no-cache',
      HttpHeaders.acceptLanguageHeader: sharedPreferences
          .getLanguageCode()
          .name,
      'lang': sharedPreferences.getLanguageCode().name,
      'device-token': '',
      'device-type': '',
    };

    client.options
      ..baseUrl = ApiConstants.baseUrl
      //..responseType = ResponseType.plain
      ..contentType = 'application/json'
      ..queryParameters = {
        // 'country_id': '${sharedPreferences.getCountryId() ?? 1}',
      }
      ..headers = header;
    client.interceptors.add(appInterceptors);
    if (kDebugMode) {
      client.interceptors.add(logInterceptor);
    }
  }

  Future<void> _handleAccessTokenHeader() async {
    //ToDo update access token
    final String? accessToken = await secureStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      client.options.headers[HttpHeaders.authorizationHeader] =
          'Bearer $accessToken';
    } else {
      client.options.headers.remove(HttpHeaders.authorizationHeader);
    }
  }

  @override
  void updateCountryIdParameter(int countryId) {
    // client.options.queryParameters['country_id'] = countryId.toString();
  }

  @override
  void updateLanguageCodeHeader() {
    final languageCode = sharedPreferences.getLanguageCode().name;
    client.options.headers[HttpHeaders.acceptLanguageHeader] = languageCode;
    client.options.headers['lang'] = languageCode;
    // client.options.headers['device-lang'] = languageCode;
  }

  @override
  void updateDeviceTokenHeader() {
    client.options.headers['device-token'] = tokenFCM;
    if (kDebugMode) {
      Log.d('[Device Token] ${tokenFCM.isNotEmpty ? tokenFCM : "(empty)"}');
    }
  }

  @override
  void updateDeviceTypeHeader() {
    client.options.headers['device-type'] = Platform.isAndroid
        ? 'android'
        : 'ios';
  }

  @override
  Future get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      Log.i('[GET][$path], params: ${queryParameters.toString()}');
      await _handleAccessTokenHeader();
      updateLanguageCodeHeader();
      final response = await client.get(path, queryParameters: queryParameters);
      Log.i('[GET][$path], response: ${response.data.toString()}');
      return response.data;
    } on SocketException {
      throw InternetConnectionException(message: Strings.noInternetConnection);
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future post(
    String path, {
    FormData? formData,
    Object? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Log.i(
        '[POST][$path], formData: ${formData?.toPrint}, body: ${body.toString()}, params: ${queryParameters.toString()}',
      );
      await _handleAccessTokenHeader();
      updateLanguageCodeHeader();
      final response = await client.post(
        path,
        queryParameters: queryParameters,
        data: formData ?? body,
      );
      Log.i('[POST][$path], response: ${response.data.toString()}');
      return response.data;
    } on SocketException {
      throw InternetConnectionException(message: Strings.noInternetConnection);
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future put(
    String path, {
    FormData? formData,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Log.i(
        '[PUT][$path], formData: ${formData?.toPrint}, body: ${body.toString()}, params: ${queryParameters.toString()}',
      );
      await _handleAccessTokenHeader();
      updateLanguageCodeHeader();
      final response = await client.put(
        path,
        queryParameters: queryParameters,
        data: formData ?? body,
      );
      Log.i('[PUT][$path], response: ${response.data.toString()}');
      return response.data;
    } on SocketException {
      throw InternetConnectionException(message: Strings.noInternetConnection);
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  @override
  Future delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) async {
    try {
      await _handleAccessTokenHeader();
      updateLanguageCodeHeader();
      final response = await client.delete(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      Log.i('[DELETE][$path], response: ${response.data.toString()}');
      return response.data;
    } on SocketException {
      throw InternetConnectionException(message: Strings.noInternetConnection);
    } on DioException catch (error) {
      _handleDioError(error);
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  void _handleDioError(DioException error) {
    if (error.response?.statusCode == StatusCode.unauthorized) {
      throw UnauthorizedException(
        message:
            error.response?.data['message'] ?? error.response?.data.toString(),
      );
    }

    if (error.response?.statusCode == StatusCode.badRequest) {
      final responseMessage = error.response?.data['message'];
      throw UnauthorizedException(
        message: sharedPreferences.getLanguageCode().name == 'ar'
            ? responseMessage ?? error.response?.data.toString()
            : responseMessage ?? error.response?.data.toString(),
      );
    }
    if (error.response?.statusCode == StatusCode.conflict) {
      throw ConflictException(
        message:
            error.response?.data['message'] ?? error.response?.data.toString(),
      );
    }
    if (error.response?.statusCode == StatusCode.unProcessableContent) {
      APIError apiError = APIError.fromJson(error.response?.data);
      String? message = apiError.getFirstError();
      throw ServerException(message: message);
    }

    if (error.response?.statusCode == StatusCode.updateRegisterApprovedUser) {
      throw UpdateRegisterApprovedUserException(
        message:
            error.response?.data['message'] ?? error.response?.data.toString(),
      );
    }
    if (error.type == DioExceptionType.unknown) {
      throw ServerException(message: "Unknown");
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      throw InternetConnectionException(message: Strings.noInternetConnection);
    }

    throw ServerException(
      message:
          error.response?.data['message'] ?? error.response?.data.toString(),
    );
  }
}
