import '../../domain/entities/auth_entity.dart';
import 'profile_model.dart';

class AuthTokenModel extends AuthTokenEntity {
  const AuthTokenModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAt,
    required super.role,
    required super.userName,
    required super.userId,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      role: json['role'] as String,
      userName: json['userName'] as String,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'expiresAt': expiresAt.toUtc().toIso8601String(),
    'role': role,
    'userName': userName,
    'userId': userId,
  };
}

class AuthRespModel extends AuthResponseEntity {
  const AuthRespModel({
    required super.isSuccess,
    super.errorMessage,
    super.token,
  });

  factory AuthRespModel.fromJson(Map<String, dynamic> json) {
    final tokenJson = json['token'];
    return AuthRespModel(
      isSuccess: json['isSuccess'] as bool,
      errorMessage: json['errorMessage'] as String?,
      token: tokenJson is Map<String, dynamic>
          ? AuthTokenModel.fromJson(tokenJson)
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'isSuccess': isSuccess,
    'errorMessage': errorMessage,
    'token': (token as AuthTokenModel?)?.toJson(),
  };
}

typedef UserModel = ProfileModel;
