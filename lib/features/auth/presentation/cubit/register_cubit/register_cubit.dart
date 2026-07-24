import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/params/auth_params.dart';
import '/core/realtime/realtime_service.dart';
import '../../../domain/entities/auth_entity.dart';
import '../../../domain/usecases/register_customer_use_case.dart';
import '../../../domain/usecases/register_provider_use_case.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterCustomerUseCase registerCustomerUseCase;
  final RegisterProviderUseCase registerProviderUseCase;
  final RealtimeService realtimeService;

  RegisterCubit({
    required this.registerCustomerUseCase,
    required this.registerProviderUseCase,
    required this.realtimeService,
  }) : super(RegisterInitial());

  Future<void> register(RegisterParams params) async {
    emit(RegisterIsLoading());
    final registerResult = switch (params) {
      RegisterCustomerParams() => registerCustomerUseCase(params),
      RegisterProviderParams() => registerProviderUseCase(params),
    };
    final response = await registerResult;
    response.fold((failure) => emit(RegisterError(failure.message ?? '')), (
      authResponse,
    ) {
      unawaited(realtimeService.connect());
      emit(RegisterLoaded(response: authResponse));
    });
  }
}
