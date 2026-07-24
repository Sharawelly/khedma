import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/auth_repo.dart';

class GetProfileUseCase {
  final AuthRepository repository;

  GetProfileUseCase({required this.repository});

  Future<Either<Failure, ProfileEntity>> call() {
    return repository.getProfile();
  }
}
