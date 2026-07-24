part of 'auto_login_cubit.dart';

abstract class AutoLoginState extends Equatable {
  const AutoLoginState();

  @override
  List<Object?> get props => <Object?>[];
}

class AutoLoginInitial extends AutoLoginState {}

class AutoLoginLoading extends AutoLoginState {}

class AutoLoginUnauthenticated extends AutoLoginState {}

class AutoLoginAuthenticated extends AutoLoginState {
  final String destination;

  const AutoLoginAuthenticated({required this.destination});

  @override
  List<Object?> get props => <Object?>[destination];
}
