import 'dart:io';

import 'package:dartz/dartz.dart';

import '/core/error/exceptions.dart';
import '/core/error/failures.dart';
import '../../domain/entities/profile_image_entity.dart';
import '../../domain/entities/saved_address_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/params/profile_params.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this.remote);

  final ProfileRemoteDataSource remote;

  @override
  Future<Either<Failure, Unit>> updateProfile(UpdateProfileParams params) {
    return _command(() => remote.updateProfile(params));
  }

  @override
  Future<Either<Failure, Unit>> changePassword(ChangePasswordParams params) {
    return _command(() => remote.changePassword(params));
  }

  @override
  Future<Either<Failure, List<SavedAddressEntity>>> getAddresses() {
    return _request(() => remote.getAddresses());
  }

  @override
  Future<Either<Failure, Unit>> addAddress(AddAddressParams params) {
    return _command(() => remote.addAddress(params));
  }

  @override
  Future<Either<Failure, Unit>> deleteAddress(String id) {
    return _command(() => remote.deleteAddress(id));
  }

  @override
  Future<Either<Failure, List<ProfileImageEntity>>> getCertificates() {
    return _request(() => remote.getCertificates());
  }

  @override
  Future<Either<Failure, Unit>> addCertificates(List<File> files) {
    return _command(() => remote.addCertificates(files));
  }

  @override
  Future<Either<Failure, Unit>> deleteCertificate(String id) {
    return _command(() => remote.deleteCertificate(id));
  }

  @override
  Future<Either<Failure, List<ProfileImageEntity>>> getPortfolio() {
    return _request(() => remote.getPortfolio());
  }

  @override
  Future<Either<Failure, Unit>> addPortfolio(List<File> files) {
    return _command(() => remote.addPortfolio(files));
  }

  @override
  Future<Either<Failure, Unit>> deletePortfolioImage(String id) {
    return _command(() => remote.deletePortfolioImage(id));
  }

  Future<Either<Failure, T>> _request<T>(Future<T> Function() request) async {
    try {
      return Right<Failure, T>(await request());
    } on AppException catch (error) {
      return Left<Failure, T>(error.toFailure());
    } catch (_) {
      // A payload shaped differently from what the model expects throws
      // TypeError, which is not an AppException. Without this it escapes as an
      // unhandled async error and takes the screen down instead of surfacing.
      return Left<Failure, T>(const ServerFailure());
    }
  }

  Future<Either<Failure, Unit>> _command(
    Future<void> Function() request,
  ) async {
    try {
      await request();
      return const Right<Failure, Unit>(unit);
    } on AppException catch (error) {
      return Left<Failure, Unit>(error.toFailure());
    }
  }
}
