import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/error/failures.dart';
import '/features/auth/domain/usecases/params/reset_password_params.dart';
import '/features/auth/domain/usecases/reset_password_use_case.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase resetPasswordUseCase;

  ResetPasswordCubit({required this.resetPasswordUseCase})
      : super(ResetPasswordInitial());

  Future<void> resetPassword(ResetPasswordParams params) async {
    emit(ResetPasswordLoading());
    final Either<Failure, BaseOneResponse> result =
        await resetPasswordUseCase(params);
    result.fold(
      (Failure failure) =>
          emit(ResetPasswordError(failure.message ?? '')),
      (BaseOneResponse response) {
        final message =
            response.message ?? 'Password reset successful';
        emit(ResetPasswordSuccess(message: message));
      },
    );
  }
}
