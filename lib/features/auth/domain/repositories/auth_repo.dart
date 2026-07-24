import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/error/failures.dart';
import '/core/params/auth_params.dart';
import '../entities/auth_entity.dart';
import '../entities/profile_entity.dart';
import '../usecases/params/forgot_password_params.dart';
import '../usecases/params/reset_password_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponseEntity>> login(LoginParams params);
  Future<Either<Failure, AuthResponseEntity>> registerCustomer(
    RegisterCustomerParams params,
  );
  Future<Either<Failure, AuthResponseEntity>> registerProvider(
    RegisterProviderParams params,
  );
  Future<Either<Failure, AuthResponseEntity>> refreshToken(
    RefreshTokenParams params,
  );
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, BaseOneResponse>> deleteAccount();
  Future<Either<Failure, BaseOneResponse>> forgotPassword(
    ForgotPasswordParams params,
  );
  Future<Either<Failure, BaseOneResponse>> resetPassword(
    ResetPasswordParams params,
  );
}
