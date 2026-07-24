import 'dart:io';

import 'package:dio/dio.dart';

import '/core/api/dio_consumer.dart';
import '/core/error/exceptions.dart';
import '/injection_container.dart';
import '../../domain/usecases/params/profile_params.dart';
import '../models/profile_image_model.dart';
import '../models/saved_address_model.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateProfile(UpdateProfileParams params);
  Future<void> changePassword(ChangePasswordParams params);
  Future<List<SavedAddressModel>> getAddresses();
  Future<void> addAddress(AddAddressParams params);
  Future<void> deleteAddress(String id);
  Future<List<ProfileImageModel>> getCertificates();
  Future<void> addCertificates(List<File> files);
  Future<void> deleteCertificate(String id);
  Future<List<ProfileImageModel>> getPortfolio();
  Future<void> addPortfolio(List<File> files);
  Future<void> deletePortfolioImage(String id);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<void> updateProfile(UpdateProfileParams params) async {
    final response = await dioConsumer.put(
      ApiConstants.profile,
      formData: await _profileFormData(params),
    );
    _ensureSuccess(response);
  }

  @override
  Future<void> changePassword(ChangePasswordParams params) async {
    _ensureSuccess(
      await dioConsumer.put(ApiConstants.changePassword, body: params.toJson()),
    );
  }

  @override
  Future<List<SavedAddressModel>> getAddresses() async {
    final response = await dioConsumer.get(ApiConstants.profileAddresses);
    return _list(
      response,
    ).map((json) => SavedAddressModel.fromJson(json)).toList();
  }

  @override
  Future<void> addAddress(AddAddressParams params) async {
    final response = await dioConsumer.post(
      ApiConstants.profileAddresses,
      body: params.toJson(),
    );
    _ensureSuccess(response);
  }

  @override
  Future<void> deleteAddress(String id) async {
    _ensureSuccess(await dioConsumer.delete(ApiConstants.profileAddress(id)));
  }

  @override
  Future<List<ProfileImageModel>> getCertificates() {
    return _getImages(ApiConstants.profileCertificates);
  }

  @override
  Future<void> addCertificates(List<File> files) {
    return _addImages(ApiConstants.profileCertificates, files);
  }

  @override
  Future<void> deleteCertificate(String id) async {
    _ensureSuccess(
      await dioConsumer.delete(ApiConstants.profileCertificate(id)),
    );
  }

  @override
  Future<List<ProfileImageModel>> getPortfolio() {
    return _getImages(ApiConstants.profilePortfolio);
  }

  @override
  Future<void> addPortfolio(List<File> files) {
    return _addImages(ApiConstants.profilePortfolio, files);
  }

  @override
  Future<void> deletePortfolioImage(String id) async {
    _ensureSuccess(
      await dioConsumer.delete(ApiConstants.profilePortfolioImage(id)),
    );
  }

  Future<List<ProfileImageModel>> _getImages(String path) async {
    final response = await dioConsumer.get(path);
    return _list(
      response,
    ).map((json) => ProfileImageModel.fromJson(json)).toList();
  }

  Future<void> _addImages(String path, List<File> files) async {
    final formData = FormData();
    for (final file in files) {
      formData.files.add(
        MapEntry<String, MultipartFile>(
          'images',
          await MultipartFile.fromFile(file.path),
        ),
      );
    }
    _ensureSuccess(await dioConsumer.post(path, formData: formData));
  }

  Future<FormData> _profileFormData(UpdateProfileParams params) async {
    final formData = FormData.fromMap(<String, dynamic>{
      if (params.fullName != null) 'fullName': params.fullName,
      if (params.email != null) 'email': params.email,
      if (params.phoneNumber != null) 'phoneNumber': params.phoneNumber,
      if (params.dateOfBirth != null)
        'dateOfBirth': params.dateOfBirth!.toIso8601String(),
      if (params.serviceArea != null) 'serviceArea': params.serviceArea,
      if (params.hourlyRate != null) 'hourlyRate': params.hourlyRate,
      if (params.jobTitle != null) 'jobTitle': params.jobTitle,
      if (params.experienceYears != null)
        'experienceYears': params.experienceYears,
      if (params.description != null) 'description': params.description,
      if (params.availabilityStatus != null)
        'availabilityStatus': params.availabilityStatus,
      if (params.currentLatitude != null)
        'currentLatitude': params.currentLatitude,
      if (params.currentLongitude != null)
        'currentLongitude': params.currentLongitude,
    });
    if (params.profilePicture != null) {
      formData.files.add(
        MapEntry<String, MultipartFile>(
          'profilePicture',
          await MultipartFile.fromFile(params.profilePicture!.path),
        ),
      );
    }
    return formData;
  }

  List<Map<String, dynamic>> _list(Object? response) {
    final responseMap = _responseMap(response);
    final payload = responseMap['data'];
    if (payload is! List) {
      throw ServerException(message: responseMap['message'] as String?);
    }
    return payload.cast<Map<String, dynamic>>();
  }

  Map<String, dynamic> _responseMap(Object? response) {
    if (response is! Map<String, dynamic>) {
      throw const ServerException();
    }
    _ensureSuccess(response);
    return response;
  }

  void _ensureSuccess(Object? response) {
    if (response is! Map<String, dynamic> || response['success'] != true) {
      throw ServerException(
        message: response is Map<String, dynamic>
            ? response['message'] as String?
            : null,
      );
    }
  }
}
