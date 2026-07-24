import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/error/exceptions.dart';
import '/core/error/failures.dart';
import '/core/params/auth_params.dart';
import '/core/utils/enums.dart';
import '/injection_container.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/usecases/params/forgot_password_params.dart';
import '../../domain/usecases/params/reset_password_params.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_resp_model.dart';
import '../models/profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, AuthResponseEntity>> login(LoginParams params) async {
    return _authenticate(() => remote.login(params));
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> registerCustomer(
    RegisterCustomerParams params,
  ) async {
    return _authenticate(() => remote.registerCustomer(params));
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> registerProvider(
    RegisterProviderParams params,
  ) async {
    return _authenticate(() => remote.registerProvider(params));
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> refreshToken(
    RefreshTokenParams params,
  ) async {
    try {
      final authResponse = await remote.refreshToken(params);
      await _persistAuthResponse(authResponse);
      return Right<Failure, AuthResponseEntity>(authResponse);
    } on AppException catch (error) {
      return Left<Failure, AuthResponseEntity>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      final refreshToken = await secureStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await remote.logout(RefreshTokenParams(refreshToken: refreshToken));
      }
      await _clearSession();
      return const Right<Failure, Unit>(unit);
    } on AppException catch (error) {
      return Left<Failure, Unit>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final profile = await remote.getProfile();
      await _cacheProfile(profile);
      return Right<Failure, ProfileEntity>(profile);
    } on AppException catch (error) {
      return Left<Failure, ProfileEntity>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> deleteAccount() async {
    try {
      final response = await remote.deleteAccount();
      await _clearSession();
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> forgotPassword(
    ForgotPasswordParams params,
  ) async {
    try {
      final response = await remote.forgotPassword(params);
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> resetPassword(
    ResetPasswordParams params,
  ) async {
    try {
      final response = await remote.resetPassword(params);
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  Future<Either<Failure, AuthResponseEntity>> _authenticate(
    Future<AuthRespModel> Function() request,
  ) async {
    try {
      final authResponse = await request();
      await _persistAuthResponse(authResponse);
      try {
        await _cacheProfile(await remote.getProfile());
      } on AppException {
        await _clearSession();
        rethrow;
      }
      return Right<Failure, AuthResponseEntity>(authResponse);
    } on AppException catch (error) {
      return Left<Failure, AuthResponseEntity>(error.toFailure());
    }
  }

  Future<void> _persistAuthResponse(AuthRespModel response) async {
    final token = response.token;
    if (token == null) {
      throw ServerException(message: response.errorMessage);
    }
    await Future.wait<void>(<Future<void>>[
      secureStorage.saveAccessToken(token.accessToken),
      secureStorage.saveRefreshToken(token.refreshToken),
      secureStorage.saveTokenExpiresAt(token.expiresAt.toIso8601String()),
      sharedPreferences.saveAuthUserId(token.userId),
      sharedPreferences.saveUserRole(token.role),
      sharedPreferences.saveUserType(
        token.role == 'Provider' ? UserType.provider : UserType.user,
      ),
      sharedPreferences.saveUserCycle(UserCycle.auth),
    ]);
  }

  Future<void> _cacheProfile(ProfileModel profile) async {
    await sharedPreferences.saveUser(profile);
  }

  Future<void> _clearSession() async {
    final languageCode = sharedPreferences.getLanguageCode().name;
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
    await sharedPreferences.saveLanguageCode(languageCode);
  }
}
