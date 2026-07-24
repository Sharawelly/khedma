import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/core/params/auth_params.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repo.dart';

class RegisterCustomerUseCase {
  final AuthRepository repository;

  RegisterCustomerUseCase({required this.repository});

  Future<Either<Failure, AuthResponseEntity>> call(
    RegisterCustomerParams params,
  ) {
    return repository.registerCustomer(params);
  }
}
