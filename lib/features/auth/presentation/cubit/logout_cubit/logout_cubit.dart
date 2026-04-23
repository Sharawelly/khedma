import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/usecases/usecase.dart';
import '../../../domain/usecases/logout_use_case.dart';
import '/core/error/failures.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutCubit({required this.logoutUseCase}) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutIsLoading());
    try {
      final Either<Failure, BaseOneResponse> result = await logoutUseCase(
        NoParams(),
      );
      result.fold(
        (failure) => emit(LogoutError(failure.message ?? '')),
        (response) => emit(LogoutSuccess(message: response.message)),
      );
    } catch (error) {
      emit(LogoutError(error.toString()));
    }
  }
}
