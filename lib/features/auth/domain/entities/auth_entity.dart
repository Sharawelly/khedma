import 'package:equatable/equatable.dart';

import 'profile_entity.dart';

class AuthTokenEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String role;
  final String userName;
  final String userId;

  const AuthTokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.role,
    required this.userName,
    required this.userId,
  });

  @override
  List<Object?> get props => <Object?>[
    accessToken,
    refreshToken,
    expiresAt,
    role,
    userName,
    userId,
  ];
}

class AuthResponseEntity extends Equatable {
  final bool isSuccess;
  final String? errorMessage;
  final AuthTokenEntity? token;

  const AuthResponseEntity({
    required this.isSuccess,
    this.errorMessage,
    this.token,
  });

  @override
  List<Object?> get props => <Object?>[isSuccess, errorMessage, token];
}

typedef UserEntity = ProfileEntity;
