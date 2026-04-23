import '/core/base_classes/base_one_response.dart';
import '../../domain/entities/otp_entity.dart';

class LoginOtpRespModel extends BaseOneResponse {
  const LoginOtpRespModel({
    super.status,
    super.data,
    super.success,
    super.message,
  });

  factory LoginOtpRespModel.fromJson(Map<String, dynamic> json) =>
      LoginOtpRespModel(
        status: json["status"],
        data: json["result"] == null
            ? null
            : LoginOtpModel.fromJson(json["result"]),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "value": value,
    "key": key,
    "data": data?.toJson(),
  };
}

class LoginOtpModel extends OtpEntity {
  const LoginOtpModel({super.passwordResetId, super.otp});

  factory LoginOtpModel.fromJson(Map<String, dynamic> json) {
    return LoginOtpModel(
      passwordResetId: json['password_reset_id'],
      otp: json['otp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'password_reset_id': passwordResetId, 'otp': otp};
  }
}
