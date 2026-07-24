part of 'profile_management_cubit.dart';

sealed class ProfileManagementState extends Equatable {
  const ProfileManagementState();

  @override
  List<Object?> get props => <Object?>[];
}

class ProfileManagementInitial extends ProfileManagementState {
  const ProfileManagementInitial();
}

class ProfileManagementLoading extends ProfileManagementState {
  const ProfileManagementLoading();
}

class ProfileManagementFailure extends ProfileManagementState {
  const ProfileManagementFailure(this.message);
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

class ProfileSaved extends ProfileManagementState {
  const ProfileSaved();
}

class PasswordSaved extends ProfileManagementState {
  const PasswordSaved();
}

class ProfileAddressesSuccess extends ProfileManagementState {
  const ProfileAddressesSuccess(this.addresses);
  final List<SavedAddressEntity> addresses;

  @override
  List<Object?> get props => <Object?>[addresses];
}

class ProfileMediaSuccess extends ProfileManagementState {
  const ProfileMediaSuccess(this.certificates, this.portfolio);
  final List<ProfileImageEntity> certificates;
  final List<ProfileImageEntity> portfolio;

  @override
  List<Object?> get props => <Object?>[certificates, portfolio];
}
