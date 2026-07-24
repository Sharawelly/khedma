import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/params/auth_params.dart';
import '../../../domain/entities/auth_entity.dart';
import '../../../domain/usecases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(LoginInitial());

  Future<void> login(LoginParams params) async {
    emit(LoginIsLoading());
    final loginResult = await loginUseCase(params);
    loginResult.fold(
      (failure) => emit(LoginError(failure.message ?? '')),
      (response) => emit(LoginLoaded(response: response)),
    );
  }
}
