import '/core/base_classes/base_one_response.dart';
import '/features/auth/domain/entities/otp_entity.dart';

class RegisterOtpRespModel extends BaseOneResponse {
  const RegisterOtpRespModel({
    super.status,
    super.data,
    super.success,
    super.message,
  });

  factory RegisterOtpRespModel.fromJson(Map<String, dynamic> json) =>
      RegisterOtpRespModel(
        status: json["status"],
        data: json["result"] == null
            ? null
            : RegisterOtpModel.fromJson(json["result"]),
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "value": value,
    "key": key,
    "result": data?.toJson(),
  };
}

class RegisterOtpModel extends OtpEntity {
  const RegisterOtpModel({super.passwordResetId, super.otp});

  factory RegisterOtpModel.fromJson(Map<String, dynamic> json) {
    return RegisterOtpModel(
      passwordResetId: json['pending_user_id'],
      otp: json['otp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'pending_user_id': pendingUserId, 'otp': otp};
  }
}
