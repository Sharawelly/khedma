import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../repositories/auth_repo.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<Either<Failure, Unit>> call() {
    return repository.logout();
  }
}
