import 'dart:io';

import 'package:dio/dio.dart';

import '/core/api/dio_consumer.dart';
import '/core/base_classes/base_one_response.dart';
import '/core/error/exceptions.dart';
import '/core/params/auth_params.dart';
import '/injection_container.dart';
import '../../domain/usecases/params/forgot_password_params.dart';
import '../../domain/usecases/params/reset_password_params.dart';
import '../models/auth_resp_model.dart';
import '../models/forgot_password_resp_model.dart';
import '../models/profile_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthRespModel> login(LoginParams params);
  Future<AuthRespModel> registerCustomer(RegisterCustomerParams params);
  Future<AuthRespModel> registerProvider(RegisterProviderParams params);
  Future<AuthRespModel> refreshToken(RefreshTokenParams params);
  Future<void> logout(RefreshTokenParams params);
  Future<ProfileModel> getProfile();
  Future<BaseOneResponse> deleteAccount();
  Future<ForgotPasswordRespModel> forgotPassword(ForgotPasswordParams params);
  Future<BaseOneResponse> resetPassword(ResetPasswordParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthRespModel> login(LoginParams params) async {
    final response = await dioConsumer.post(
      ApiConstants.login,
      body: params.toJson(),
    );
    return _parseSessionResponse(response);
  }

  @override
  Future<AuthRespModel> registerCustomer(RegisterCustomerParams params) async {
    final formData = await _customerFormData(params);
    final response = await dioConsumer.post(
      ApiConstants.registerCustomer,
      formData: formData,
    );
    return _parseSessionResponse(response);
  }

  @override
  Future<AuthRespModel> registerProvider(RegisterProviderParams params) async {
    final formData = await _providerFormData(params);
    final response = await dioConsumer.post(
      ApiConstants.registerProvider,
      formData: formData,
    );
    return _parseSessionResponse(response);
  }

  @override
  Future<AuthRespModel> refreshToken(RefreshTokenParams params) async {
    final response = await dioConsumer.post(
      ApiConstants.refreshToken,
      body: params.toJson(),
    );
    return _parseSessionResponse(response);
  }

  @override
  Future<void> logout(RefreshTokenParams params) async {
    // The backend responds with a plain `{ "message": "..." }` body on success,
    // so there is nothing to parse. A non-2xx status throws via the interceptors.
    await dioConsumer.post(ApiConstants.logout, body: params.toJson());
  }

  @override
  Future<ProfileModel> getProfile() async {
    final response = await dioConsumer.get(ApiConstants.profile);
    if (response is! Map<String, dynamic>) {
      throw const ServerException();
    }
    final responseMap = response;
    if (responseMap['success'] != true) {
      throw ServerException(message: responseMap['message'] as String?);
    }
    try {
      return ProfileModel.fromJson(responseMap['data'] as Map<String, dynamic>);
    } on FormatException {
      throw ServerException(message: responseMap['message'] as String?);
    } on TypeError {
      throw ServerException(message: responseMap['message'] as String?);
    }
  }

  @override
  Future<BaseOneResponse> deleteAccount() async {
    final response = await dioConsumer.delete('/profile/delete-account');
    return _parseStandardResponse(response);
  }

  @override
  Future<ForgotPasswordRespModel> forgotPassword(
    ForgotPasswordParams params,
  ) async {
    final response = await dioConsumer.post(
      ApiConstants.forgotPassword,
      body: params.toJson(),
    );
    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw ServerException(message: responseMap['message'] as String?);
    }
    return ForgotPasswordRespModel.fromJson(responseMap);
  }

  @override
  Future<BaseOneResponse> resetPassword(ResetPasswordParams params) async {
    final response = await dioConsumer.post(
      ApiConstants.resetPassword,
      body: params.toJson(),
    );
    return _parseStandardResponse(response);
  }

  AuthRespModel _parseAuthResponse(Object? response) {
    if (response is! Map<String, dynamic>) {
      throw const ServerException();
    }
    final responseMap = response;
    late final AuthRespModel authResponse;
    try {
      authResponse = AuthRespModel.fromJson(responseMap);
    } on FormatException {
      throw ServerException(message: responseMap['errorMessage'] as String?);
    } on TypeError {
      throw ServerException(message: responseMap['errorMessage'] as String?);
    }
    if (!authResponse.isSuccess) {
      throw ServerException(message: authResponse.errorMessage);
    }
    return authResponse;
  }

  AuthRespModel _parseSessionResponse(Object? response) {
    final authResponse = _parseAuthResponse(response);
    final token = authResponse.token;
    if (token == null ||
        token.accessToken.isEmpty ||
        token.refreshToken.isEmpty ||
        token.userId.isEmpty ||
        (token.role != 'Customer' && token.role != 'Provider')) {
      throw ServerException(message: authResponse.errorMessage);
    }
    return authResponse;
  }

  BaseOneResponse _parseStandardResponse(Object? response) {
    final responseMap = response as Map<String, dynamic>;
    if (responseMap['success'] != true) {
      throw ServerException(message: responseMap['message'] as String?);
    }
    return BaseOneResponse(
      success: true,
      message: responseMap['message'] as String?,
      statusCode: responseMap['statusCode'] as int?,
      data: responseMap['data'],
    );
  }

  Future<FormData> _customerFormData(RegisterParams params) async {
    final formData = FormData.fromMap(<String, dynamic>{
      'fullName': params.fullName,
      'email': params.email,
      'password': params.password,
      'phoneNumber': params.phoneNumber,
      if (params.dateOfBirth != null)
        'dateOfBirth': params.dateOfBirth!.toIso8601String(),
    });
    if (params.profilePicture != null) {
      formData.files.add(
        MapEntry(
          'profilePicture',
          await _multipartFile(params.profilePicture!.path),
        ),
      );
    }
    return formData;
  }

  Future<FormData> _providerFormData(RegisterProviderParams params) async {
    final formData = await _customerFormData(params);
    formData.fields.addAll(<MapEntry<String, String>>[
      MapEntry<String, String>('hourlyRate', params.hourlyRate.toString()),
      MapEntry<String, String>('serviceArea', params.serviceArea),
      MapEntry<String, String>('jobTitle', params.jobTitle),
      MapEntry<String, String>(
        'experienceYears',
        params.experienceYears.toString(),
      ),
      MapEntry<String, String>('description', params.description),
      MapEntry<String, String>(
        'availabilityStatus',
        params.availabilityStatus.toString(),
      ),
      if (params.currentLatitude != null)
        MapEntry<String, String>(
          'currentLatitude',
          params.currentLatitude.toString(),
        ),
      if (params.currentLongitude != null)
        MapEntry<String, String>(
          'currentLongitude',
          params.currentLongitude.toString(),
        ),
    ]);
    await _addFiles(formData, 'certificateImages', params.certificateImages);
    await _addFiles(formData, 'portfolioImages', params.portfolioImages);
    return formData;
  }

  Future<void> _addFiles(
    FormData formData,
    String fieldName,
    List<File> files,
  ) async {
    for (final file in files) {
      formData.files.add(
        MapEntry<String, MultipartFile>(
          fieldName,
          await _multipartFile(file.path),
        ),
      );
    }
  }

  Future<MultipartFile> _multipartFile(String path) {
    return MultipartFile.fromFile(
      path,
      filename: path.split(RegExp(r'[/\\]')).last,
    );
  }
}
