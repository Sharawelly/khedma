import 'package:flutter_test/flutter_test.dart';
import 'package:khedma/core/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('defaults to the Android emulator route to a local backend', () {
      // 10.0.2.2 is how the Android emulator reaches the host's localhost.
      expect(AppConfig.baseUrl, 'http://10.0.2.2:5283/api');
    });

    test('origin drops the /api path so host-rooted assets resolve', () {
      expect(AppConfig.origin, 'http://10.0.2.2:5283');
    });

    test('origin never carries a trailing slash', () {
      expect(AppConfig.origin.endsWith('/'), isFalse);
    });
  });
}
