part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => <Object?>[];
}

class LoginInitial extends LoginState {}

class LoginIsLoading extends LoginState {}

class LoginLoaded extends LoginState {
  final AuthResponseEntity response;

  const LoginLoaded({required this.response});

  @override
  List<Object?> get props => <Object?>[response];
}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object?> get props => <Object?>[message];
}
