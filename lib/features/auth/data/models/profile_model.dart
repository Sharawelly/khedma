import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    super.dateOfBirth,
    super.profilePictureUrl,
    super.role,
    super.rating,
    super.reviewCount,
    super.serviceArea,
    super.hourlyRate,
    super.jobTitle,
    super.experienceYears,
    super.description,
    super.numberOfJobsDone,
    super.state,
    super.availabilityStatus,
    super.workingLatitude,
    super.workingLongitude,
    super.currentLatitude,
    super.currentLongitude,
    super.emailConfirmed,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: _dateTime(json['dateOfBirth']),
      profilePictureUrl: json['profilePictureUrl'] as String?,
      role: json['role'] as String?,
      rating: _double(json['rating']),
      reviewCount: _int(json['reviewCount']),
      serviceArea: json['serviceArea'] as String?,
      hourlyRate: _double(json['hourlyRate']),
      jobTitle: json['jobTitle'] as String?,
      experienceYears: _int(json['experienceYears']),
      description: json['description'] as String?,
      numberOfJobsDone: _int(json['numberOfJobsDone']),
      state: json['state'] as String?,
      availabilityStatus: json['availabilityStatus'] as String?,
      workingLatitude: _double(json['workingLatitude']),
      workingLongitude: _double(json['workingLongitude']),
      currentLatitude: _double(json['currentLatitude']),
      currentLongitude: _double(json['currentLongitude']),
      emailConfirmed: json['emailConfirmed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'dateOfBirth': dateOfBirth?.toUtc().toIso8601String(),
    'profilePictureUrl': profilePictureUrl,
    'role': role,
    'rating': rating,
    'reviewCount': reviewCount,
    'serviceArea': serviceArea,
    'hourlyRate': hourlyRate,
    'jobTitle': jobTitle,
    'experienceYears': experienceYears,
    'description': description,
    'numberOfJobsDone': numberOfJobsDone,
    'state': state,
    'availabilityStatus': availabilityStatus,
    'workingLatitude': workingLatitude,
    'workingLongitude': workingLongitude,
    'currentLatitude': currentLatitude,
    'currentLongitude': currentLongitude,
    'emailConfirmed': emailConfirmed,
  };

  static DateTime? _dateTime(Object? rawValue) {
    return rawValue is String && rawValue.isNotEmpty
        ? DateTime.parse(rawValue)
        : null;
  }

  static double? _double(Object? rawValue) {
    return rawValue is num ? rawValue.toDouble() : null;
  }

  static int? _int(Object? rawValue) {
    return rawValue is num ? rawValue.toInt() : null;
  }
}
