import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/params/auth_params.dart';
import '/core/usecases/usecase.dart';
import '/features/auth/domain/repositories/auth_repo.dart';
import '../../../../core/error/failures.dart';

class RegisterUseCase extends UseCase<BaseOneResponse, AuthParams> {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(AuthParams params) async {
    return await repository.registerWithPassword(params);
  }
}
