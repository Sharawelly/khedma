part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterIsLoading extends RegisterState {}

class RegisterLoaded extends RegisterState {
  final BaseOneResponse response;

  const RegisterLoaded({required this.response});
}

class RegisterError extends RegisterState {
  final String message;
  const RegisterError(this.message);
}
