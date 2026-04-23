import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/error/failures.dart';
import '../../../domain/usecases/forgot_password_use_case.dart';
import '../../../domain/usecases/params/forgot_password_params.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;

  ForgotPasswordCubit({required this.forgotPasswordUseCase})
    : super(ForgotPasswordInitial());

  Future<void> forgotPassword(ForgotPasswordParams params) async {
    emit(ForgotPasswordLoading());
    final Either<Failure, BaseOneResponse> result = await forgotPasswordUseCase(
      params,
    );
    result.fold(
      (Failure failure) => emit(ForgotPasswordError(failure.message ?? '')),
      (BaseOneResponse response) {
        final message =
            response.message ??
            'Password reset instructions sent to your email';
        emit(ForgotPasswordSuccess(message: message));
      },
    );
  }
}
