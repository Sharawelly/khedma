import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/core/utils/enums.dart';
import '../repositories/auth_repo.dart';

class SaveUserTypeUseCase extends UseCase<bool, SaveUserTypeParams> {
  final AuthRepository repository;

  SaveUserTypeUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(SaveUserTypeParams params) async {
    return await repository.saveUserType(params: params);
  }
}

class SaveUserTypeParams extends Equatable {
  final UserType type;

  const SaveUserTypeParams({required this.type});

  @override
  List<Object?> get props => <Object?>[type];
}
