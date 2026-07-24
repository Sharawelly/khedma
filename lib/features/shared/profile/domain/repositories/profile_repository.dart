import 'dart:io';

import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../entities/profile_image_entity.dart';
import '../entities/saved_address_entity.dart';
import '../usecases/params/profile_params.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Unit>> updateProfile(UpdateProfileParams params);
  Future<Either<Failure, Unit>> changePassword(ChangePasswordParams params);
  Future<Either<Failure, List<SavedAddressEntity>>> getAddresses();
  Future<Either<Failure, Unit>> addAddress(AddAddressParams params);
  Future<Either<Failure, Unit>> deleteAddress(String id);
  Future<Either<Failure, List<ProfileImageEntity>>> getCertificates();
  Future<Either<Failure, Unit>> addCertificates(List<File> files);
  Future<Either<Failure, Unit>> deleteCertificate(String id);
  Future<Either<Failure, List<ProfileImageEntity>>> getPortfolio();
  Future<Either<Failure, Unit>> addPortfolio(List<File> files);
  Future<Either<Failure, Unit>> deletePortfolioImage(String id);
}
