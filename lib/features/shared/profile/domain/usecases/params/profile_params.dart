import 'dart:io';

class UpdateProfileParams {
  const UpdateProfileParams({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.profilePicture,
    this.serviceArea,
    this.hourlyRate,
    this.jobTitle,
    this.experienceYears,
    this.description,
    this.availabilityStatus,
    this.currentLatitude,
    this.currentLongitude,
  });

  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final File? profilePicture;
  final String? serviceArea;
  final double? hourlyRate;
  final String? jobTitle;
  final int? experienceYears;
  final String? description;
  final String? availabilityStatus;
  final double? currentLatitude;
  final double? currentLongitude;
}

class ChangePasswordParams {
  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;

  // The server binds this to ChangePasswordDto.OldPassword; sending
  // "currentPassword" leaves it empty and the change silently fails.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'oldPassword': currentPassword,
    'newPassword': newPassword,
  };
}

class AddAddressParams {
  const AddAddressParams({
    required this.label,
    required this.addressLine,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final String addressLine;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'label': label,
    'addresssLine': addressLine,
    'latitude': latitude,
    'longitude': longitude,
  };
}
