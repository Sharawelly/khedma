part of 'delete_account_cubit.dart';

abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object?> get props => [];
}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountIsLoading extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {
  final String? message;

  const DeleteAccountSuccess({this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteAccountError extends DeleteAccountState {
  final String message;

  const DeleteAccountError(this.message);

  @override
  List<Object?> get props => [message];
}

