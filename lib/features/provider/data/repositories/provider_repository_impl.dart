import 'package:dartz/dartz.dart';

import '/core/error/exceptions.dart';
import '/core/error/failures.dart';
import '../../domain/entities/provider_entities.dart';
import '../../domain/repositories/provider_repository.dart';
import '../../domain/usecases/params/provider_params.dart';
import '../datasources/provider_location_datasource.dart';
import '../datasources/provider_remote_datasource.dart';

class ProviderRepositoryImpl implements ProviderRepository {
  const ProviderRepositoryImpl(this.remote, this.location);

  final ProviderRemoteDataSource remote;
  final ProviderLocationDataSource location;

  Future<Either<Failure, T>> _request<T>(Future<T> Function() request) async {
    try {
      return Right<Failure, T>(await request());
    } on AppException catch (error) {
      return Left<Failure, T>(error.toFailure());
    } catch (_) {
      // A payload that does not match what the model expects throws TypeError,
      // which is not an AppException. Without this it escapes as an unhandled
      // async error: the caller never completes, so the UI hangs on a spinner
      // or a background tick dies silently instead of reporting anything.
      // No message: the cubit's fallback renders 'provider_request_failed'
      // rather than leaking a Dart type error to the provider.
      return Left<Failure, T>(const ServerFailure());
    }
  }

  Future<Either<Failure, Unit>> _command(Future<void> Function() request) =>
      _request<Unit>(() async {
        await request();
        return unit;
      });

  @override
  Future<Either<Failure, List<PendingJobEntity>>> getPendingJobs() =>
      _request<List<PendingJobEntity>>(remote.getPendingJobs);

  @override
  Future<Either<Failure, AcceptedJobEntity>> acceptJob(String bookingId) =>
      _request<AcceptedJobEntity>(() => remote.acceptJob(bookingId));

  @override
  Future<Either<Failure, Unit>> rejectJob(String bookingId) =>
      _command(() => remote.rejectJob(bookingId));

  @override
  Future<Either<Failure, Unit>> completeJob(String bookingId) =>
      _command(() => remote.completeJob(bookingId));

  @override
  Future<Either<Failure, Unit>> markEnRoute(ProviderJobActionParams params) =>
      _command(() => remote.markEnRoute(params));

  @override
  Future<Either<Failure, Unit>> markArrived(String bookingId) =>
      _command(() => remote.markArrived(bookingId));

  @override
  Future<Either<Failure, Unit>> markInProgress(String bookingId) =>
      _command(() => remote.markInProgress(bookingId));

  @override
  Future<Either<Failure, ProviderAvailabilityEntity>> updateAvailability(
    ProviderAvailabilityParams params,
  ) => _request<ProviderAvailabilityEntity>(
    () => remote.updateAvailability(params),
  );

  @override
  Future<Either<Failure, ProviderCoordinatesEntity>> getCurrentPosition() =>
      _request<ProviderCoordinatesEntity>(location.getCurrentPosition);

  @override
  Stream<Either<Failure, ProviderCoordinatesEntity>> watchPosition() async* {
    try {
      await for (final coordinates in location.watchPosition()) {
        yield Right<Failure, ProviderCoordinatesEntity>(coordinates);
      }
    } on AppException catch (error) {
      yield Left<Failure, ProviderCoordinatesEntity>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateLocation(
    ProviderLocationParams params,
  ) => _command(() => remote.updateLocation(params));

  @override
  Future<Either<Failure, List<ProviderServiceEntity>>> getServices() =>
      _request<List<ProviderServiceEntity>>(remote.getServices);

  @override
  Future<Either<Failure, List<ProviderServiceEntity>>> updateServices(
    List<String> serviceIds,
  ) => _request<List<ProviderServiceEntity>>(
    () => remote.updateServices(serviceIds),
  );

  @override
  Future<Either<Failure, ProviderEarningsEntity>> getEarnings(
    ProviderEarningsParams params,
  ) => _request<ProviderEarningsEntity>(() => remote.getEarnings(params));

  @override
  Future<Either<Failure, ProviderWalletEntity>> getWallet() =>
      _request<ProviderWalletEntity>(remote.getWallet);

  @override
  Future<Either<Failure, PayoutEntity>> requestPayout(
    ProviderPayoutParams params,
  ) => _request<PayoutEntity>(() => remote.requestPayout(params));

  @override
  Future<Either<Failure, Unit>> replyToReview(
    ProviderReviewReplyParams params,
  ) => _command(() => remote.replyToReview(params));
}
