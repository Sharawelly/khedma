import 'dart:io';

import 'package:equatable/equatable.dart';

class AuthParams extends Equatable {
  final int? countryId;
  final String? type; // individual | organization
  final String? phone;
  final String? name;
  final String? email;
  final int? governorateId;
  final String? address;
  final String? password;
  final String? passwordConfirmation;
  final String? gender;
  final int? activityTypeId;

  final int? verifiedAccount;
  final String? commercialRegistration;
  final String? taxNumber;
  final File? image;
  final String? deviceToken;
  final String? fcmDeviceToken;
  final String? deviceType;
  final String? deviceName;
  final String? invitationCode;
  final String? jobTitle;

  const AuthParams({
    this.countryId,
    this.type,
    this.phone,
    this.name,
    this.email,
    this.governorateId,
    this.address,
    this.password,
    this.passwordConfirmation,
    this.gender,
    this.activityTypeId,
    this.verifiedAccount,
    this.commercialRegistration,
    this.taxNumber,
    this.image,
    this.deviceToken,
    this.fcmDeviceToken,
    this.deviceType,
    this.deviceName,
    this.invitationCode,
    this.jobTitle,
  });

  @override
  List<Object?> get props => [
    countryId,
    type,
    phone,
    name,
    email,
    governorateId,
    address,
    password,
    passwordConfirmation,
    gender,
    activityTypeId,
    verifiedAccount,
    commercialRegistration,
    taxNumber,
    image,
    deviceToken,
    fcmDeviceToken,
    deviceType,
    deviceName,
    invitationCode,
    jobTitle,
  ];

  Map<String, dynamic> toJson() => {
    "country_id": countryId,
    "type": type,
    "phone": phone,
    "name": name,
    "email": email,
    "governorate_id": governorateId,
    "address": address,
    "password": password,
    "password_confirmation": passwordConfirmation,
    "gender": gender,
    "activity_type_id": activityTypeId,
    "verified_account": verifiedAccount,
    "commercial_registration": commercialRegistration,
    "tax_number": taxNumber,
    "device_token": fcmDeviceToken,
    "device_type": deviceType,
    "device_name": deviceName,
    "invitation_code": invitationCode,
    "job_title": jobTitle,
  };
}
