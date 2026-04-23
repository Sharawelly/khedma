import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '/injection_container.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Content-Type'] = 'application/json';

    const conversationsListPath = '/conversations';
    final isGetConversationsList =
        options.method == 'GET' &&
        (options.path == conversationsListPath ||
            options.path == 'conversations');

    if (isGetConversationsList) {
      // Match Postman exactly for this endpoint to avoid server 500.
      // Server may do ->id on null when extra headers (lang, country-id, etc.) are present.
      options.headers['Cache-Control'] = 'no-cache';
      options.headers['Accept'] = 'application/json';
      // Remove headers that Postman does not send; backend may use them and hit null.
      options.headers.remove('accept-language');
      options.headers.remove('lang');
      options.headers.remove('device-token');
      options.headers.remove('device-type');
      options.headers.remove('country-id');
    } else {
      final countryId = sharedPreferences.getUser()?.country?.id;
      if (countryId != null) {
        options.headers['country-id'] = countryId.toString();
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // debugPrint(
    //     'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      eventBus.emitUnauthorized(); // 🔥 Trigger navigation to Login
    }
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} => RESPONSE: ${err.response?.toString()}',
    );
    super.onError(err, handler);
  }
}
