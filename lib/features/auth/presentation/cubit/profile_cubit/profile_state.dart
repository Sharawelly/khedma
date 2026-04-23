part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileIsLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  final DateTime timestamp;
  
  ProfileLoaded({required this.user}) : timestamp = DateTime.now();
  
  @override
  List<Object> get props => [user, timestamp];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  
  @override
  List<Object> get props => [message];
}
