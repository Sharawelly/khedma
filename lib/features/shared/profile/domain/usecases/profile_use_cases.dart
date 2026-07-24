import 'dart:io';

import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../entities/profile_image_entity.dart';
import '../entities/saved_address_entity.dart';
import '../repositories/profile_repository.dart';
import 'params/profile_params.dart';

class UpdateProfile {
  const UpdateProfile(this.repository);
  final ProfileRepository repository;
  Future<Either<Failure, Unit>> call(UpdateProfileParams params) =>
      repository.updateProfile(params);
}

class ChangePassword {
  const ChangePassword(this.repository);
  final ProfileRepository repository;
  Future<Either<Failure, Unit>> call(ChangePasswordParams params) =>
      repository.changePassword(params);
}

class GetAddresses {
  const GetAddresses(this.repository);
  final ProfileRepository repository;
  Future<Either<Failure, List<SavedAddressEntity>>> call() =>
      repository.getAddresses();
}

class AddAddress {
  const AddAddress(this.repository);
  final ProfileRepository repository;
  Future<Either<Failure, Unit>> call(AddAddressParams params) =>
      repository.addAddress(params);
}

class DeleteAddress {
  const DeleteAddress(this.repository);
  final ProfileRepository repository;
  Future<Either<Failure, Unit>> call(String id) => repository.deleteAddress(id);
}

class GetCertificates {
  const GetCertificates(this.repository);
  final ProfileRepository repository;
  Future<Either<Failure, List<ProfileImageEntity>>> call() =>
      repository.getCertificates();
}

class AddCertificates {
  const AddCertificates(this.repository);
  final ProfileRepository repository;
  Future<Either<Failure, Unit>> call(List<File> files) =>
      repository.addCertificates(files);
}

class DeleteCertificate {
  const DeleteCertificate(this.repository);
  final ProfileRepository repository;
  Future<Either<Failure, Unit>> call(String id) =>
      repository.deleteCertificate(id);
}

class GetPortfolio {
  const GetPortfolio(this.repository);
  final ProfileRepository repository;
  Future<Either<Failure, List<ProfileImageEntity>>> call() =>
      repository.getPortfolio();
}

class AddPortfolio {
  const AddPortfolio(this.repository);
  final ProfileRepository repository;
  Future<Either<Failure, Unit>> call(List<File> files) =>
      repository.addPortfolio(files);
}

class DeletePortfolioImage {
  const DeletePortfolioImage(this.repository);
  final ProfileRepository repository;
  Future<Either<Failure, Unit>> call(String id) =>
      repository.deletePortfolioImage(id);
}
