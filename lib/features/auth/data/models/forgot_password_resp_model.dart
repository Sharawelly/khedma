import '/core/base_classes/base_one_response.dart';

class ForgotPasswordDataModel {
  final String? message;

  const ForgotPasswordDataModel({this.message});

  factory ForgotPasswordDataModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordDataModel(message: json['message'] as String?);

  Map<String, dynamic> toJson() => {'message': message};
}

class ForgotPasswordRespModel extends BaseOneResponse {
  const ForgotPasswordRespModel({
    super.success,
    super.message,
    super.data,
  });

  factory ForgotPasswordRespModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordRespModel(
        success: json['success'] as bool?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : ForgotPasswordDataModel.fromJson(
                json['data'] as Map<String, dynamic>,
              ),
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': (data as ForgotPasswordDataModel?)?.toJson(),
      };
}
