import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final DateTime? dateOfBirth;
  final String? profilePicture;
  final String? role;
  final double? rating;
  final int? reviewCount;
  final String? serviceArea;
  final double? hourlyRate;
  final String? jobTitle;
  final int? experienceYears;
  final String? description;
  final int? numberOfJobsDone;
  final int? state;
  final int? availabilityStatus;
  final double? currentLatitude;
  final double? currentLongitude;

  const ProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.dateOfBirth,
    this.profilePicture,
    this.role,
    this.rating,
    this.reviewCount,
    this.serviceArea,
    this.hourlyRate,
    this.jobTitle,
    this.experienceYears,
    this.description,
    this.numberOfJobsDone,
    this.state,
    this.availabilityStatus,
    this.currentLatitude,
    this.currentLongitude,
  });

  String get name => fullName;

  @override
  List<Object?> get props => <Object?>[
    id,
    fullName,
    email,
    phoneNumber,
    dateOfBirth,
    profilePicture,
    role,
    rating,
    reviewCount,
    serviceArea,
    hourlyRate,
    jobTitle,
    experienceYears,
    description,
    numberOfJobsDone,
    state,
    availabilityStatus,
    currentLatitude,
    currentLongitude,
  ];
}
