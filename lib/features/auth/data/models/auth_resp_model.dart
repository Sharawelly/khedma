import '/core/base_classes/base_one_response.dart';
import '/features/auth/domain/entities/activity_type_entity.dart';
import '/features/auth/domain/entities/auth_entity.dart' as auth_entity;

class AuthRespModel extends BaseOneResponse {
  const AuthRespModel({super.status, super.data, super.success, super.message});

  factory AuthRespModel.fromJson(Map<String, dynamic> json) => AuthRespModel(
    success: json["success"] as bool?,
    message: json["message"] as String?,
    data: json["data"] == null ? null : AuthModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class UserModel extends auth_entity.UserEntity {
  const UserModel({
    super.id,
    super.name,
    super.code,
    super.email,
    super.phone,
    super.image,
    super.address,
    super.gender,
    super.commercialRegistration,
    super.taxNumber,
    super.isActive,
    super.country,
    super.governorate,
    super.type,
    super.activityType,
    super.verifiedAccount,
    super.trustStatus,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      address: json['address'] as String?,
      gender: json['gender'] as String?,
      commercialRegistration: json['commercial_registration'] as String?,
      taxNumber: json['tax_number'] as String?,
      isActive: json['is_active'] as bool?,
      country: json['country'] != null
          ? UserCountryModel.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      governorate: json['governorate'] != null
          ? UserGovernorateModel.fromJson(
              json['governorate'] as Map<String, dynamic>,
            )
          : null,
      type: json['type'] as String?,
      activityType: json['activity_type'] != null
          ? UserActivityTypeModel.fromJson(
              json['activity_type'] as Map<String, dynamic>,
            )
          : null,
      verifiedAccount: json['verified_account'] == null
          ? null
          : (json['verified_account'] is int
                ? json['verified_account'] as int
                : int.tryParse(json['verified_account'].toString())),
      trustStatus: json['trust_status']?.toString().replaceAll("'", "").trim(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'email': email,
      'phone': phone,
      'image': image,
      'address': address,
      'gender': gender,
      'commercial_registration': commercialRegistration,
      'tax_number': taxNumber,
      'is_active': isActive,
      'country': country != null
          ? (country as UserCountryModel).toJson()
          : null,
      'governorate': governorate != null
          ? (governorate as UserGovernorateModel).toJson()
          : null,
      'type': type,
      'activity_type': activityType != null
          ? (activityType as UserActivityTypeModel).toJson()
          : null,
      'verified_account': verifiedAccount,
      'trust_status': trustStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class UserCountryModel extends auth_entity.CountryEntity {
  const UserCountryModel({super.id, super.code, super.nameEn, super.nameAr});

  factory UserCountryModel.fromJson(Map<String, dynamic> json) {
    return UserCountryModel(
      id: json['id'] as int?,
      code: json['code'] as String?,
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'code': code, 'name_en': nameEn, 'name_ar': nameAr};
  }
}

class UserGovernorateModel extends auth_entity.GovernorateEntity {
  const UserGovernorateModel({super.id, super.nameEn, super.nameAr});

  factory UserGovernorateModel.fromJson(Map<String, dynamic> json) {
    return UserGovernorateModel(
      id: json['id'] as int?,
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name_en': nameEn, 'name_ar': nameAr};
  }
}

class UserActivityTypeModel extends ActivityTypeEntity {
  const UserActivityTypeModel({super.id, super.nameAr, super.nameEn});

  factory UserActivityTypeModel.fromJson(Map<String, dynamic> json) {
    return UserActivityTypeModel(
      id: json['id'] as int?,
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name_en': nameEn, 'name_ar': nameAr};
  }
}

class AuthModel {
  final UserModel user;
  final String token;

  const AuthModel({required this.user, required this.token});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user: UserModel.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token};
  }
}
