import 'package:dio/dio.dart';

import '/core/api/dio_consumer.dart';
import '/core/base_classes/base_one_response.dart';
import '/core/error/exceptions.dart';
import '/core/params/auth_params.dart';

import '/features/auth/data/models/auth_resp_model.dart';
import '/features/auth/data/models/forgot_password_resp_model.dart';

import '/features/auth/domain/usecases/params/forgot_password_params.dart';
import '/features/auth/domain/usecases/params/reset_password_params.dart';
import '../../../../injection_container.dart';
import '../models/countries_resp_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthRespModel> loginWithPassword({required AuthParams params});
  Future<AuthRespModel> registerWithPassword({required AuthParams params});
  Future<AuthRespModel> getProfile();
  Future<BaseOneResponse> logout();
  Future<BaseOneResponse> deleteAccount();
  Future<ForgotPasswordRespModel> forgotPassword({
    required ForgotPasswordParams params,
  });
  Future<BaseOneResponse> resetPassword({required ResetPasswordParams params});

  Future<CountriesRespModel> getAllCountries();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<CountriesRespModel> getAllCountries() async {
    try {
      final dynamic response = await dioConsumer.get('/countries');
      if (response['success'] == true) {
        return CountriesRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<AuthRespModel> loginWithPassword({required AuthParams params}) async {
    try {
      final String currentLang = sharedPreferences.getLanguageCode().name;
      final body = <String, dynamic>{'current_lang': currentLang};
      final String? code = params.invitationCode?.trim();
      if (code != null && code.isNotEmpty) {
        body['invitation_code'] = code;
      } else {
        body['phone'] = params.phone;
        body['password'] = params.password;
      }
      if (params.fcmDeviceToken != null && params.fcmDeviceToken!.isNotEmpty) {
        body['device_token'] = params.fcmDeviceToken;
      }
      if (params.deviceType != null) {
        body['device_type'] = params.deviceType;
      }
      if (params.deviceName != null) {
        body['device_name'] = params.deviceName;
      }
      final dynamic response = await dioConsumer.post(
        ApiConstants.login,
        body: body,
      );
      if (response['success'] == true) {
        return AuthRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<AuthRespModel> registerWithPassword({
    required AuthParams params,
  }) async {
    try {
      final FormData formData = FormData();
      final String currentLang = sharedPreferences.getLanguageCode().name;

      if (params.image != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              params.image!.path,
              filename: params.image!.path.split(RegExp(r'[/\\]')).last,
            ),
          ),
        );
      }

      if (params.countryId != null) {
        formData.fields.add(
          MapEntry('country_id', params.countryId.toString()),
        );
      }
      if (params.type != null) {
        formData.fields.add(MapEntry('type', params.type!));
      }
      if (params.phone != null) {
        formData.fields.add(MapEntry('phone', params.phone!));
      }
      if (params.name != null) {
        formData.fields.add(MapEntry('name', params.name!));
      }
      if (params.email != null) {
        formData.fields.add(MapEntry('email', params.email!));
      }
      if (params.governorateId != null) {
        formData.fields.add(
          MapEntry('governorate_id', params.governorateId.toString()),
        );
      }
      if (params.address != null) {
        formData.fields.add(MapEntry('address', params.address!));
      }
      if (params.password != null) {
        formData.fields.add(MapEntry('password', params.password!));
      }
      if (params.passwordConfirmation != null) {
        formData.fields.add(
          MapEntry('password_confirmation', params.passwordConfirmation!),
        );
      }
      if (params.gender != null) {
        formData.fields.add(MapEntry('gender', params.gender!));
      }
      if (params.activityTypeId != null) {
        formData.fields.add(
          MapEntry('activity_type_id', params.activityTypeId.toString()),
        );
      }
      if (params.verifiedAccount != null) {
        formData.fields.add(
          MapEntry('verified_account', params.verifiedAccount.toString()),
        );
      }
      if (params.commercialRegistration != null) {
        formData.fields.add(
          MapEntry('commercial_registration', params.commercialRegistration!),
        );
      }
      if (params.taxNumber != null) {
        formData.fields.add(MapEntry('tax_number', params.taxNumber!));
      }
      if (params.jobTitle != null) {
        formData.fields.add(MapEntry('job_title', params.jobTitle!));
      }
      // Always send device fields as text (string)
      final deviceToken =
          (params.fcmDeviceToken?.isNotEmpty == true
                  ? params.fcmDeviceToken
                  : params.deviceToken)
              ?.toString() ??
          '';
      final deviceType = (params.deviceType ?? '').toString();
      final deviceName = (params.deviceName ?? '').toString();
      formData.fields.add(MapEntry('device_token', deviceToken));
      formData.fields.add(MapEntry('device_type', deviceType));
      formData.fields.add(MapEntry('device_name', deviceName));
      formData.fields.add(MapEntry('current_lang', currentLang));

      final dynamic response = await dioConsumer.post(
        '/register',
        formData: formData,
      );
      if (response['success'] == true) {
        return AuthRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<AuthRespModel> getProfile() async {
    try {
      final dynamic response = await dioConsumer.get('/profile');
      if (response['success'] == true) {
        return AuthRespModel.fromJson(response);
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> logout() async {
    try {
      final dynamic response = await dioConsumer.post('/logout');
      if (response['success'] == true) {
        return BaseOneResponse(
          success: response['success'] as bool?,
          message: response['message'] as String?,
          data: response['data'],
        );
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> deleteAccount() async {
    try {
      final dynamic response = await dioConsumer.delete(
        '/profile/delete-account',
      );
      if (response['success'] == true) {
        return BaseOneResponse(
          success: response['success'] as bool?,
          message: response['message'] as String?,
          data: response['data'],
        );
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<ForgotPasswordRespModel> forgotPassword({
    required ForgotPasswordParams params,
  }) async {
    try {
      final dynamic response = await dioConsumer.post(
        ApiConstants.forgotPassword,
        body: params.toJson(),
      );
      if (response['success'] == true) {
        return ForgotPasswordRespModel.fromJson(
          response as Map<String, dynamic>,
        );
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<BaseOneResponse> resetPassword({
    required ResetPasswordParams params,
  }) async {
    try {
      final dynamic response = await dioConsumer.post(
        ApiConstants.resetPassword,
        body: params.toJson(),
      );
      if (response['success'] == true) {
        return BaseOneResponse(
          success: response['success'] as bool?,
          message: response['message'] as String?,
          data: response['data'],
        );
      }
      throw ServerException(message: response['message'] ?? '');
    } catch (error) {
      rethrow;
    }
  }
}
