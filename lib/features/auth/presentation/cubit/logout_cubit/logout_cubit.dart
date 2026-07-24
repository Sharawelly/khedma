import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/realtime/realtime_service.dart';
import '../../../domain/usecases/logout_use_case.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;
  final RealtimeService realtimeService;

  LogoutCubit({required this.logoutUseCase, required this.realtimeService})
    : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutIsLoading());
    final logoutResult = await logoutUseCase();
    await logoutResult.fold<Future<void>>(
      (failure) async => emit(LogoutError(failure.message ?? '')),
      (_) async {
        await realtimeService.disconnect();
        emit(const LogoutSuccess());
      },
    );
  }
}
