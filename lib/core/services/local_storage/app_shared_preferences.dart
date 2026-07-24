import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/auth/data/models/auth_resp_model.dart';
import '../../../features/auth/domain/entities/auth_entity.dart';
import '../../utils/enums.dart';
import '../../utils/extension.dart';

abstract class _AppSharedPreferencesKeys {
  static const authUserId = 'authUserId';
  static const userRole = 'userRole';
  static const user = 'user';
  static const appTheme = 'appTheme';
  static const languageCode = 'languageCode';
  static const userType = 'userType';
  static const userCycle = 'userCycle';
}

abstract class AppSharedPreferences {
  final SharedPreferences instance;

  const AppSharedPreferences(Object object, {required this.instance});

  //region:: auth user Id
  /// The KHDMA identity id, which is a string rather than the legacy int id.
  String? getAuthUserId();
  Future<bool> saveAuthUserId(String id);
  Future<bool> removeAuthUserId();

  //region:: user role
  /// "Customer" or "Provider", as reported by the server on login/refresh.
  String? getUserRole();
  Future<bool> saveUserRole(String role);
  Future<bool> removeUserRole();

  //region:: user
  UserEntity? getUser();
  Future<bool> saveUser(UserModel user);
  Future<bool> removeUser();

  //endregion

  //region:: Language Code
  LanguageCode getLanguageCode();
  Future<bool> saveLanguageCode(String value);
  Future<bool> removeLanguageCode();

  //endregion

  //region:: App Theme
  Themes getAppTheme();

  Future<bool> saveAppTheme(Themes theme);

  Future<bool> removeAppTheme();

  //endregion

  //region:: User Type
  UserType getUserType();

  Future<bool> saveUserType(UserType value);

  Future<bool> removeUserType();
  // User Cycle
  Future<bool> saveUserCycle(UserCycle value);
  UserCycle getUserCycle();
  Future<bool> removeUserCycle();

  Future<bool> clearAll();
}

class AppSharedPreferencesImpl extends AppSharedPreferences {
  AppSharedPreferencesImpl({required SharedPreferences instance})
    : super(Object(), instance: instance);

  //region:: auth user Id
  @override
  String? getAuthUserId() =>
      instance.getString(_AppSharedPreferencesKeys.authUserId);

  @override
  Future<bool> saveAuthUserId(String id) =>
      instance.setString(_AppSharedPreferencesKeys.authUserId, id);

  @override
  Future<bool> removeAuthUserId() =>
      instance.remove(_AppSharedPreferencesKeys.authUserId);

  //endregion

  //region:: user role
  @override
  String? getUserRole() =>
      instance.getString(_AppSharedPreferencesKeys.userRole);

  @override
  Future<bool> saveUserRole(String role) =>
      instance.setString(_AppSharedPreferencesKeys.userRole, role);

  @override
  Future<bool> removeUserRole() =>
      instance.remove(_AppSharedPreferencesKeys.userRole);

  //endregion

  //region:: Language Code
  @override
  LanguageCode getLanguageCode() {
    String value =
        instance.getString(_AppSharedPreferencesKeys.languageCode) ?? "ar";
    final lang = LanguageCodeExtension.fromString(value);
    log('getLanguageCode lang: $lang');
    return lang;
  }

  @override
  Future<bool> saveLanguageCode(String value) {
    final languageCode = LanguageCodeExtension.fromString(value);
    return instance.setString(
      _AppSharedPreferencesKeys.languageCode,
      languageCode.name,
    );
  }

  @override
  Future<bool> removeLanguageCode() =>
      instance.remove(_AppSharedPreferencesKeys.languageCode);

  //endregion

  //region:: App Theme
  @override
  Themes getAppTheme() {
    String value = instance.getString(_AppSharedPreferencesKeys.appTheme) ?? '';
    return ThemesExtension.fromString(value);
  }

  @override
  Future<bool> saveAppTheme(Themes theme) =>
      instance.setString(_AppSharedPreferencesKeys.appTheme, theme.name);

  @override
  Future<bool> removeAppTheme() =>
      instance.remove(_AppSharedPreferencesKeys.appTheme);

  //endregion

  //region:: User Type
  @override
  UserType getUserType() => UserTypeExtension.fromString(
    instance.getString(_AppSharedPreferencesKeys.userType) ?? '',
  );

  @override
  Future<bool> saveUserType(UserType value) =>
      instance.setString(_AppSharedPreferencesKeys.userType, value.name);

  @override
  Future<bool> removeUserType() =>
      instance.remove(_AppSharedPreferencesKeys.userType);

  @override
  UserCycle getUserCycle() => UserCycleExtension.fromString(
    instance.getString(_AppSharedPreferencesKeys.userCycle) ?? '',
  );

  @override
  Future<bool> saveUserCycle(UserCycle value) =>
      instance.setString(_AppSharedPreferencesKeys.userCycle, value.name);

  @override
  Future<bool> removeUserCycle() =>
      instance.remove(_AppSharedPreferencesKeys.userCycle);

  //User

  @override
  UserEntity? getUser() {
    String? userStr = instance.getString(_AppSharedPreferencesKeys.user);
    if (userStr == null || userStr.isEmpty) {
      return null;
    }
    try {
      return UserModel.fromJson(jsonDecode(userStr)) as UserEntity;
    } catch (e) {
      log('Error decoding user from SharedPreferences: $e');
      return null;
    }
  }

  @override
  Future<bool> saveUser(UserModel user) => instance.setString(
    _AppSharedPreferencesKeys.user,
    jsonEncode(user.toJson()),
  );

  @override
  Future<bool> removeUser() => instance.remove(_AppSharedPreferencesKeys.user);

  //endregion

  @override
  Future<bool> clearAll() => instance.clear();
}
