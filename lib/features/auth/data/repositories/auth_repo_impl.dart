import 'package:dartz/dartz.dart';

import '/core/base_classes/base_list_response.dart';
import '/core/base_classes/base_one_response.dart';
import '/core/params/auth_params.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/log_utils.dart' as log;
import '../../../../injection_container.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/usecases/params/forgot_password_params.dart';
import '../../domain/usecases/params/reset_password_params.dart';
import '../../domain/usecases/save_user_role.dart';
import '../../domain/usecases/save_user_type_usecase.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_resp_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl({required this.remote});

  /// Impl

  @override
  Future<Either<Failure, UserType>> getUserType({
    required NoParams params,
  }) async {
    try {
      UserType userType = sharedPreferences.getUserType();
      return Right<Failure, UserType>(userType);
    } on AppException catch (error) {
      log.Log.e(
        '[getUserType] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, UserType>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveUserType({
    required SaveUserTypeParams params,
  }) async {
    try {
      bool result = await sharedPreferences.saveUserType(params.type);
      return Right<Failure, bool>(result);
    } on AppException catch (error) {
      log.Log.e(
        '[saveUserType] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, bool>(error.toFailure());
    }
  }

  // USer Cycle Repo -----------------------------------------------------
  @override
  Future<Either<Failure, bool>> saveUserCycle({
    required SaveUserCycleParams params,
  }) async {
    try {
      bool result = await sharedPreferences.saveUserCycle(params.type);
      return Right<Failure, bool>(result);
    } on AppException catch (error) {
      log.Log.e(
        '[saveUserRole] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, bool>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, UserCycle>> getUserCycle({
    required NoParams params,
  }) async {
    try {
      UserCycle userCycle = sharedPreferences.getUserCycle();
      return Right<Failure, UserCycle>(userCycle);
    } on AppException catch (error) {
      log.Log.e(
        '[getUserRole] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, UserCycle>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> loginWithPassword(
    AuthParams params,
  ) async {
    try {
      final BaseOneResponse response = await remote.loginWithPassword(
        params: params,
      );
      final authModel = response.data as AuthModel;

      // Clear old user data first to prevent stale data issues
      await sharedPreferences.removeUserId();
      await sharedPreferences.removeUser();
      await sharedPreferences.removeUserType();
      await sharedPreferences.removeUserCycle();

      // Save new user data
      await sharedPreferences.saveUserId(authModel.user.id ?? 0);
      await sharedPreferences.saveUser(authModel.user);
      await secureStorage.saveAccessToken(authModel.token);

      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      log.Log.e(
        '[loginWithPassword] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> registerWithPassword(
    AuthParams params,
  ) async {
    try {
      final BaseOneResponse response = await remote.registerWithPassword(
        params: params,
      );
      final authModel = response.data as AuthModel;

      // Clear old user data first to prevent stale data issues
      await sharedPreferences.removeUserId();
      await sharedPreferences.removeUser();
      await sharedPreferences.removeUserType();
      await sharedPreferences.removeUserCycle();

      // Save new user data
      await sharedPreferences.saveUserId(authModel.user.id ?? 0);
      await sharedPreferences.saveUser(authModel.user);
      await secureStorage.saveAccessToken(authModel.token);

      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      log.Log.e(
        '[registerWithPassword] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> logout() async {
    try {
      final BaseOneResponse response = await remote.logout();

      // Preserve language preference across logout
      final savedLangCode = sharedPreferences.getLanguageCode();

      // Clear ALL SharedPreferences to ensure no stale user data remains
      await sharedPreferences.clearAll();

      // Restore language preference
      await sharedPreferences.saveLanguageCode(savedLangCode.name);

      // Clear secure storage (token)
      await secureStorage.saveAccessToken(null);

      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      log.Log.e(
        '[logout] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> deleteAccount() async {
    try {
      final BaseOneResponse response = await remote.deleteAccount();

      // Preserve language preference across account deletion
      final savedLangCode = sharedPreferences.getLanguageCode();

      // Clear ALL SharedPreferences to ensure no stale user data remains
      await sharedPreferences.clearAll();

      // Restore language preference
      await sharedPreferences.saveLanguageCode(savedLangCode.name);

      // Clear secure storage (token)
      await secureStorage.saveAccessToken(null);

      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      log.Log.e(
        '[deleteAccount] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> forgotPassword(
    ForgotPasswordParams params,
  ) async {
    try {
      final BaseOneResponse response = await remote.forgotPassword(
        params: params,
      );
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      log.Log.e(
        '[forgotPassword] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> resetPassword(
    ResetPasswordParams params,
  ) async {
    try {
      final BaseOneResponse response = await remote.resetPassword(
        params: params,
      );
      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      log.Log.e(
        '[resetPassword] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, BaseOneResponse>> getProfile() async {
    try {
      final BaseOneResponse response = await remote.getProfile();
      final authModel = response.data as AuthModel;
      await sharedPreferences.saveUserId(authModel.user.id ?? 0);
      await sharedPreferences.saveUser(authModel.user);

      return Right<Failure, BaseOneResponse>(response);
    } on AppException catch (error) {
      log.Log.e(
        '[getProfile] [${error.runtimeType.toString()}] ---- ${error.message}',
      );
      return Left<Failure, BaseOneResponse>(error.toFailure());
    }
  }
}
