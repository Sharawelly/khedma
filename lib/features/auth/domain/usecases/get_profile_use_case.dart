import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/usecases/usecase.dart';
import '/features/auth/domain/repositories/auth_repo.dart';
import '../../../../core/error/failures.dart';

class GetProfileUseCase extends UseCase<BaseOneResponse, NoParams> {
  final AuthRepository repository;

  GetProfileUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(NoParams params) async {
    return await repository.getProfile();
  }
}
