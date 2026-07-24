import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _AppSecureStorageKeys {
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String tokenExpiresAt = 'tokenExpiresAt';
  static const String deviceToken = 'deviceToken';
}

abstract class AppSecureStorage {
  final FlutterSecureStorage instance;

  const AppSecureStorage({required this.instance});

  //region:: AccessToken
  Future<String?> getAccessToken();

  Future<void> saveAccessToken(String? token);

  //endregion

  //region:: RefreshToken
  Future<String?> getRefreshToken();

  Future<void> saveRefreshToken(String? token);

  Future<void> removeRefreshToken();

  //endregion

  //region:: TokenExpiresAt
  Future<String?> getTokenExpiresAt();

  Future<void> saveTokenExpiresAt(String? expiresAt);

  Future<void> removeTokenExpiresAt();

  //endregion

  //region:: DeviceToken
  Future<String?> getDeviceToken();

  Future<void> saveDeviceToken(String token);

  Future<void> removeDeviceToken();

  //endregion

  Future<void> clearAll();
}

class AppSecureStorageImpl extends AppSecureStorage {
  AppSecureStorageImpl({required super.instance});

  //region:: AccessToken
  @override
  Future<String?> getAccessToken() =>
      instance.read(key: _AppSecureStorageKeys.accessToken);

  @override
  Future<void> saveAccessToken(String? token) =>
      instance.write(key: _AppSecureStorageKeys.accessToken, value: token);

  //endregion

  //region:: RefreshToken
  @override
  Future<String?> getRefreshToken() =>
      instance.read(key: _AppSecureStorageKeys.refreshToken);

  @override
  Future<void> saveRefreshToken(String? token) =>
      instance.write(key: _AppSecureStorageKeys.refreshToken, value: token);

  @override
  Future<void> removeRefreshToken() =>
      instance.delete(key: _AppSecureStorageKeys.refreshToken);

  //endregion

  //region:: TokenExpiresAt
  @override
  Future<String?> getTokenExpiresAt() =>
      instance.read(key: _AppSecureStorageKeys.tokenExpiresAt);

  @override
  Future<void> saveTokenExpiresAt(String? expiresAt) => instance.write(
    key: _AppSecureStorageKeys.tokenExpiresAt,
    value: expiresAt,
  );

  @override
  Future<void> removeTokenExpiresAt() =>
      instance.delete(key: _AppSecureStorageKeys.tokenExpiresAt);

  //endregion

  //region:: DeviceToken
  @override
  Future<String?> getDeviceToken() =>
      instance.read(key: _AppSecureStorageKeys.deviceToken);

  @override
  Future<void> saveDeviceToken(String token) =>
      instance.write(key: _AppSecureStorageKeys.deviceToken, value: token);

  @override
  Future<void> removeDeviceToken() =>
      instance.delete(key: _AppSecureStorageKeys.deviceToken);

  //endregion

  @override
  Future<void> clearAll() => instance.deleteAll();
}
