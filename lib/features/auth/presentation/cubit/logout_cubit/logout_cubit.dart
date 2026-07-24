import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/logout_use_case.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutCubit({required this.logoutUseCase}) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutIsLoading());
    final logoutResult = await logoutUseCase();
    logoutResult.fold(
      (failure) => emit(LogoutError(failure.message ?? '')),
      (_) => emit(const LogoutSuccess()),
    );
  }
}
