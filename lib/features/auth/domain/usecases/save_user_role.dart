import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '/core/utils/enums.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repo.dart';

class SaveUserCycleUseCase extends UseCase<bool, SaveUserCycleParams> {
  final AuthRepository repository;

  SaveUserCycleUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(SaveUserCycleParams params) async {
    return await repository.saveUserCycle(params: params);
  }
}

class SaveUserCycleParams extends Equatable {
  final UserCycle type;

  const SaveUserCycleParams({required this.type});

  @override
  List<Object?> get props => <Object?>[type];
}
