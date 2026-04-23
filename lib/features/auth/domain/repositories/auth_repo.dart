import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/params/auth_params.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/core/utils/enums.dart';
import '../usecases/params/forgot_password_params.dart';
import '../usecases/params/reset_password_params.dart';
import '../usecases/save_user_role.dart';
import '../usecases/save_user_type_usecase.dart';

abstract class AuthRepository {
  Future<Either<Failure, BaseOneResponse>> loginWithPassword(AuthParams params);
  Future<Either<Failure, BaseOneResponse>> registerWithPassword(
    AuthParams params,
  );
  Future<Either<Failure, BaseOneResponse>> logout();
  Future<Either<Failure, BaseOneResponse>> deleteAccount();
  Future<Either<Failure, BaseOneResponse>> forgotPassword(
    ForgotPasswordParams params,
  );
  Future<Either<Failure, BaseOneResponse>> resetPassword(
    ResetPasswordParams params,
  );
  Future<Either<Failure, BaseOneResponse>> getProfile();

  Future<Either<Failure, UserType>> getUserType({required NoParams params});

  Future<Either<Failure, bool>> saveUserType({
    required SaveUserTypeParams params,
  });

  Future<Either<Failure, bool>> saveUserCycle({
    required SaveUserCycleParams params,
  });
  Future<Either<Failure, UserCycle>> getUserCycle({required NoParams params});
}
