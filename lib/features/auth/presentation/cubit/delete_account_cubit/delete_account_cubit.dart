import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/base_classes/base_one_response.dart';
import '/core/usecases/usecase.dart';
import '../../../domain/usecases/delete_account_use_case.dart';
import '/core/error/failures.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final DeleteAccountUseCase deleteAccountUseCase;

  DeleteAccountCubit({required this.deleteAccountUseCase})
    : super(DeleteAccountInitial());

  Future<void> deleteAccount() async {
    emit(DeleteAccountIsLoading());
    try {
      final Either<Failure, BaseOneResponse> result =
          await deleteAccountUseCase(NoParams());
      result.fold(
        (failure) => emit(DeleteAccountError(failure.message ?? '')),
        (response) => emit(DeleteAccountSuccess(message: response.message)),
      );
    } catch (error) {
      emit(DeleteAccountError(error.toString()));
    }
  }
}
