import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '/injection_container.dart';
import 'dio_consumer.dart';

class AppInterceptors extends Interceptor {
  static const String _retryKey = 'authRetryAttempted';
  Future<_RefreshedSession?>? _activeRefresh;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.contentType = options.data is FormData
        ? Headers.multipartFormDataContentType
        : Headers.jsonContentType;
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    debugPrint(
      'ERROR[${error.response?.statusCode}] => PATH: '
      '${error.requestOptions.path} => RESPONSE: ${error.response}',
    );
    if (_isRefreshFailure(error)) {
      await _expireSession();
      handler.resolve(error.response!);
      return;
    }
    if (_shouldExposeAuthFailure(error)) {
      handler.resolve(error.response!);
      return;
    }
    if (error.response?.statusCode != 401) {
      handler.next(error);
      return;
    }
    if (!_canRefresh(error.requestOptions)) {
      await _expireSession();
      handler.next(error);
      return;
    }
    final refreshedSession = await _refreshSession();
    if (refreshedSession == null) {
      await _expireSession();
      handler.next(error);
      return;
    }
    await _retry(error, refreshedSession, handler);
  }

  bool _shouldExposeAuthFailure(DioException error) {
    final response = error.response;
    if (response == null || response.data is! Map<String, dynamic>) {
      return false;
    }
    final path = error.requestOptions.path;
    final isCredentialRequest =
        path == ApiConstants.login ||
        path == ApiConstants.registerCustomer ||
        path == ApiConstants.registerProvider;
    return isCredentialRequest &&
        (response.data as Map<String, dynamic>)['isSuccess'] == false;
  }

  bool _isRefreshFailure(DioException error) {
    return error.requestOptions.path == ApiConstants.refreshToken &&
        error.response != null &&
        error.response!.data is Map<String, dynamic>;
  }

  bool _canRefresh(RequestOptions request) {
    return request.path != ApiConstants.refreshToken &&
        request.extra[_retryKey] != true;
  }

  Future<_RefreshedSession?> _refreshSession() async {
    final inFlightRefresh = _activeRefresh;
    if (inFlightRefresh != null) {
      return inFlightRefresh;
    }
    final refresh = _requestRefreshedSession();
    _activeRefresh = refresh;
    try {
      return await refresh;
    } finally {
      if (identical(_activeRefresh, refresh)) {
        _activeRefresh = null;
      }
    }
  }

  Future<_RefreshedSession?> _requestRefreshedSession() async {
    final storedRefreshToken = await secureStorage.getRefreshToken();
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      return null;
    }
    final refreshClient = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    try {
      final response = await refreshClient.post<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        data: <String, dynamic>{'refreshToken': storedRefreshToken},
      );
      return _parseAndPersistSession(response.data);
    } on DioException {
      return null;
    }
  }

  Future<_RefreshedSession?> _parseAndPersistSession(
    Map<String, dynamic>? response,
  ) async {
    if (response == null || response['isSuccess'] != true) {
      return null;
    }
    final token = response['token'];
    if (token is! Map<String, dynamic>) {
      return null;
    }
    final session = _RefreshedSession.fromJson(token);
    if (session == null) {
      return null;
    }
    await Future.wait<void>(<Future<void>>[
      secureStorage.saveAccessToken(session.accessToken),
      secureStorage.saveRefreshToken(session.refreshToken),
      secureStorage.saveTokenExpiresAt(session.expiresAt),
      sharedPreferences.saveAuthUserId(session.userId),
      sharedPreferences.saveUserRole(session.role),
    ]);
    return session;
  }

  Future<void> _retry(
    DioException originalError,
    _RefreshedSession session,
    ErrorInterceptorHandler handler,
  ) async {
    final request = originalError.requestOptions;
    request.extra[_retryKey] = true;
    request.headers['Authorization'] = 'Bearer ${session.accessToken}';
    if (request.path == ApiConstants.logout) {
      request.data = <String, dynamic>{'refreshToken': session.refreshToken};
    }
    try {
      final response = await Dio().fetch<dynamic>(request);
      handler.resolve(response);
    } on DioException catch (retryError) {
      if (retryError.response?.statusCode == 401) {
        await _expireSession();
      }
      handler.next(retryError);
    }
  }

  Future<void> _expireSession() async {
    await Future.wait<void>(<Future<void>>[
      secureStorage.saveAccessToken(null),
      secureStorage.removeRefreshToken(),
      secureStorage.removeTokenExpiresAt(),
      sharedPreferences.removeAuthUserId(),
      sharedPreferences.removeUserRole(),
      sharedPreferences.removeUser(),
      sharedPreferences.removeUserType(),
      sharedPreferences.removeUserCycle(),
    ]);
    eventBus.emitUnauthorized();
  }
}

class _RefreshedSession {
  final String accessToken;
  final String refreshToken;
  final String expiresAt;
  final String role;
  final String userId;

  const _RefreshedSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.role,
    required this.userId,
  });

  static _RefreshedSession? fromJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'];
    final refreshToken = json['refreshToken'];
    final expiresAt = json['expiresAt'];
    final role = json['role'];
    final userId = json['userId'];
    if (accessToken is! String ||
        accessToken.isEmpty ||
        refreshToken is! String ||
        refreshToken.isEmpty ||
        expiresAt is! String ||
        DateTime.tryParse(expiresAt) == null ||
        role is! String ||
        (role != 'Customer' && role != 'Provider') ||
        userId is! String ||
        userId.isEmpty) {
      return null;
    }
    return _RefreshedSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      role: role,
      userId: userId,
    );
  }
}
