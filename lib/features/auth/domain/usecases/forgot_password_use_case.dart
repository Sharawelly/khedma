import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/usecases/usecase.dart';
import '/features/auth/domain/repositories/auth_repo.dart';
import '/features/auth/domain/usecases/params/forgot_password_params.dart';
import '../../../../core/error/failures.dart';

class ForgotPasswordUseCase
    extends UseCase<BaseOneResponse, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPasswordUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(
    ForgotPasswordParams params,
  ) async {
    return await repository.forgotPassword(params);
  }
}
