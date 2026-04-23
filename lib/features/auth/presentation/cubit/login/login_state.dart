part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginIsLoading extends LoginState {}

class LoginLoaded extends LoginState {
  final BaseOneResponse response;

  const LoginLoaded({required this.response});
}

class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
}
