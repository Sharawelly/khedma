// ignore_for_file: unnecessary_nullable_for_final_variable_declarations

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '/core/base_classes/api_error.dart';
import '../../injection_container.dart';
import '../error/exceptions.dart';
import '../utils/extension.dart';
import '../utils/log_utils.dart';
import '../utils/values/strings.dart';
import 'status_code.dart';

abstract class ApiConstants {
  static const String dev = 'https://api.world-apm.com/api';
  static const String live = 'https://api.world-apm.com/api';
  static const String baseUrl = dev;

  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String login = '/login';
  static const String getArticles = '/articles';
  static String getArticleDetails(int id) => '/articles/$id';
  static const String messagesUnreadCount = '/messages/unread-count';
  static const String getBreedTypes = '/breed-types';
  static String getCategoryFilters(int categoryId) =>
      '/categories/$categoryId/filters';
  static const String changeLanguage = '/change_language';

  /// Learning blocks dashboard (Performa Me).
  static const String blocksDashboard = '/blocks/dashboard';
}

abstract class DioConsumer {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});

  Future<dynamic> post(
    String path, {
    FormData? formData,
    Map<String, dynamic>? body,
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
    Map<String, dynamic>? body,
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
