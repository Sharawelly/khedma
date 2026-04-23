import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/params/auth_params.dart';
import '../../../domain/usecases/login_with_password_use_case.dart';
import '/core/error/failures.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginWithPasswordUseCase loginWithPasswordUseCase;

  LoginCubit({required this.loginWithPasswordUseCase}) : super(LoginInitial());

  Future<void> login(AuthParams params) async {
    emit(LoginIsLoading());
    try {
      final Either<Failure, BaseOneResponse> eitherResult =
          await loginWithPasswordUseCase(params);
      eitherResult.fold(
        (Failure failure) {
          emit(LoginError(failure.message ?? ''));
        },
        (BaseOneResponse response) {
          emit(LoginLoaded(response: response));
        },
      );
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
