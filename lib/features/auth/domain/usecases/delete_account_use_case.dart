import 'package:dartz/dartz.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/usecases/usecase.dart';
import '/features/auth/domain/repositories/auth_repo.dart';
import '../../../../core/error/failures.dart';

class DeleteAccountUseCase extends UseCase<BaseOneResponse, NoParams> {
  final AuthRepository repository;

  DeleteAccountUseCase({required this.repository});

  @override
  Future<Either<Failure, BaseOneResponse>> call(NoParams params) async {
    return await repository.deleteAccount();
  }
}

