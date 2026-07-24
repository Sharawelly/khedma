import 'dart:io';

import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'email': email,
    'password': password,
  };

  LoginParams copyWith({String? email, String? password}) {
    return LoginParams(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => <Object?>[email, password];
}

sealed class RegisterParams extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final DateTime? dateOfBirth;
  final File? profilePicture;

  const RegisterParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.dateOfBirth,
    this.profilePicture,
  });

  @override
  List<Object?> get props => <Object?>[
    fullName,
    email,
    password,
    phoneNumber,
    dateOfBirth,
    profilePicture,
  ];
}

class RegisterCustomerParams extends RegisterParams {
  const RegisterCustomerParams({
    required super.fullName,
    required super.email,
    required super.password,
    required super.phoneNumber,
    super.dateOfBirth,
    super.profilePicture,
  });

  RegisterCustomerParams copyWith({
    String? fullName,
    String? email,
    String? password,
    String? phoneNumber,
    DateTime? dateOfBirth,
    File? profilePicture,
  }) {
    return RegisterCustomerParams(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}

class RegisterProviderParams extends RegisterParams {
  final double hourlyRate;
  final String serviceArea;
  final String jobTitle;
  final int experienceYears;
  final String description;
  final int availabilityStatus;
  final double? currentLatitude;
  final double? currentLongitude;
  final List<File> certificateImages;
  final List<File> portfolioImages;

  const RegisterProviderParams({
    required super.fullName,
    required super.email,
    required super.password,
    required super.phoneNumber,
    required this.hourlyRate,
    required this.serviceArea,
    required this.jobTitle,
    required this.experienceYears,
    required this.description,
    this.availabilityStatus = 1,
    this.currentLatitude,
    this.currentLongitude,
    this.certificateImages = const <File>[],
    this.portfolioImages = const <File>[],
    super.dateOfBirth,
    super.profilePicture,
  });

  @override
  List<Object?> get props => <Object?>[
    ...super.props,
    hourlyRate,
    serviceArea,
    jobTitle,
    experienceYears,
    description,
    availabilityStatus,
    currentLatitude,
    currentLongitude,
    certificateImages,
    portfolioImages,
  ];

  RegisterProviderParams copyWith({
    String? fullName,
    String? email,
    String? password,
    String? phoneNumber,
    double? hourlyRate,
    String? serviceArea,
    String? jobTitle,
    int? experienceYears,
    String? description,
    int? availabilityStatus,
    double? currentLatitude,
    double? currentLongitude,
    List<File>? certificateImages,
    List<File>? portfolioImages,
    DateTime? dateOfBirth,
    File? profilePicture,
  }) {
    return RegisterProviderParams(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      serviceArea: serviceArea ?? this.serviceArea,
      jobTitle: jobTitle ?? this.jobTitle,
      experienceYears: experienceYears ?? this.experienceYears,
      description: description ?? this.description,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      certificateImages: certificateImages ?? this.certificateImages,
      portfolioImages: portfolioImages ?? this.portfolioImages,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}

class RefreshTokenParams extends Equatable {
  final String refreshToken;

  const RefreshTokenParams({required this.refreshToken});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'refreshToken': refreshToken,
  };

  RefreshTokenParams copyWith({String? refreshToken}) {
    return RefreshTokenParams(refreshToken: refreshToken ?? this.refreshToken);
  }

  @override
  List<Object?> get props => <Object?>[refreshToken];
}
