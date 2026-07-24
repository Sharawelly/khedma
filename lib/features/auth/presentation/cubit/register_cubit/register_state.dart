part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => <Object?>[];
}

class RegisterInitial extends RegisterState {}

class RegisterIsLoading extends RegisterState {}

class RegisterLoaded extends RegisterState {
  final AuthResponseEntity response;

  const RegisterLoaded({required this.response});

  @override
  List<Object?> get props => <Object?>[response];
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError(this.message);

  @override
  List<Object?> get props => <Object?>[message];
}
