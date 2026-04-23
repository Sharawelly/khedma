import 'package:equatable/equatable.dart';

import 'activity_type_entity.dart';

class UserEntity extends Equatable {
  final int? id;
  final String? name;
  final String? code;
  final String? email;
  final String? phone;
  final String? image;
  final String? address;
  final String? gender;
  final String? commercialRegistration;
  final String? taxNumber;
  final bool? isActive;
  final CountryEntity? country;
  final GovernorateEntity? governorate;
  final String? type;
  final ActivityTypeEntity? activityType;
  final dynamic verifiedAccount;
  final String? trustStatus; // 'active', 'inactive', 'pending'
  final String? createdAt;
  final String? updatedAt;

  const UserEntity({
    this.id,
    this.name,
    this.code,
    this.email,
    this.phone,
    this.image,
    this.address,
    this.gender,
    this.commercialRegistration,
    this.taxNumber,
    this.isActive,
    this.country,
    this.governorate,
    this.type,
    this.activityType,
    this.verifiedAccount,
    this.trustStatus,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    email,
    phone,
    image,
    address,
    gender,
    commercialRegistration,
    taxNumber,
    isActive,
    country,
    governorate,
    type,
    activityType,
    verifiedAccount,
    trustStatus,
    createdAt,
    updatedAt,
  ];
}

class GovernorateEntity extends Equatable {
  final int? id;
  final String? nameEn;
  final String? nameAr;

  const GovernorateEntity({this.id, this.nameEn, this.nameAr});

  @override
  List<Object?> get props => [id, nameEn, nameAr];
}

class CountryEntity extends Equatable {
  final int? id;
  final String? code;
  final String? nameEn;
  final String? nameAr;

  const CountryEntity({this.id, this.code, this.nameEn, this.nameAr});

  @override
  List<Object?> get props => [id, code, nameEn, nameAr];
}

class AuthEntity extends Equatable {
  final UserEntity? user;
  final String? token;

  const AuthEntity({this.user, this.token});

  @override
  List<Object?> get props => [user, token];
}
