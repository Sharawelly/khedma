import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/core/params/auth_params.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repo.dart';

class RegisterProviderUseCase {
  final AuthRepository repository;

  RegisterProviderUseCase({required this.repository});

  Future<Either<Failure, AuthResponseEntity>> call(
    RegisterProviderParams params,
  ) {
    return repository.registerProvider(params);
  }
}
