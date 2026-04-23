import 'dart:io';

import 'package:equatable/equatable.dart';

class RegisterFormState extends Equatable {
  final String selectedUserType;
  final File? selectedImage;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool acceptTerms;
  final int? governmentId;
  final int? selectedActivityTypeId;
  final String? selectedGender;

  final String? commercialRegistration;
  final String? taxNumber;

  const RegisterFormState({
    this.selectedUserType = 'individual',
    this.selectedImage,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.acceptTerms = false,
    this.governmentId,
    this.selectedActivityTypeId,
    this.selectedGender,

    this.commercialRegistration,
    this.taxNumber,
  });

  RegisterFormState copyWith({
    String? selectedUserType,
    File? selectedImage,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? acceptTerms,
    int? governmentId,
    int? selectedActivityTypeId,
    String? selectedGender,

    String? commercialRegistration,
    String? taxNumber,
  }) {
    return RegisterFormState(
      selectedUserType: selectedUserType ?? this.selectedUserType,
      selectedImage: selectedImage ?? this.selectedImage,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      governmentId: governmentId ?? this.governmentId,
      selectedActivityTypeId:
          selectedActivityTypeId ?? this.selectedActivityTypeId,
      selectedGender: selectedGender ?? this.selectedGender,

      commercialRegistration:
          commercialRegistration ?? this.commercialRegistration,
      taxNumber: taxNumber ?? this.taxNumber,
    );
  }

  @override
  List<Object?> get props => [
    selectedUserType,
    selectedImage,
    obscurePassword,
    obscureConfirmPassword,
    acceptTerms,
    governmentId,
    selectedActivityTypeId,
    selectedGender,

    commercialRegistration,
    taxNumber,
  ];
}
