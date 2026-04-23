import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/params/auth_params.dart';
import '/features/auth/domain/usecases/register_with_password_use_case.dart';
import '../../../../../core/error/failures.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterWithPasswordUseCase registerWithPasswordUseCase;

  RegisterCubit({required this.registerWithPasswordUseCase})
    : super(RegisterInitial());

  Future<void> register(AuthParams params) async {
    emit(RegisterIsLoading());
    try {
      final Either<Failure, BaseOneResponse> eitherResult =
          await registerWithPasswordUseCase(params);
      eitherResult.fold(
        (Failure failure) {
          emit(RegisterError(failure.message ?? ''));
        },
        (BaseOneResponse response) {
          emit(RegisterLoaded(response: response));
        },
      );
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
