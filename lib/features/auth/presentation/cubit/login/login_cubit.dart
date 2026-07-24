import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/params/auth_params.dart';
import '/core/realtime/realtime_service.dart';
import '../../../domain/entities/auth_entity.dart';
import '../../../domain/usecases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final RealtimeService realtimeService;

  LoginCubit({required this.loginUseCase, required this.realtimeService})
    : super(LoginInitial());

  Future<void> login(LoginParams params) async {
    emit(LoginIsLoading());
    final loginResult = await loginUseCase(params);
    loginResult.fold((failure) => emit(LoginError(failure.message ?? '')), (
      response,
    ) {
      unawaited(realtimeService.connect());
      emit(LoginLoaded(response: response));
    });
  }
}
