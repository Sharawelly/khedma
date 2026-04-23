import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/enums.dart';
import '../repositories/auth_repo.dart';

class GetUserCycleUseCase extends UseCase<UserCycle, NoParams> {
  final AuthRepository repository;

  GetUserCycleUseCase({required this.repository});

  @override
  Future<Either<Failure, UserCycle>> call(NoParams params) async {
    return await repository.getUserCycle(params: params);
  }
}
