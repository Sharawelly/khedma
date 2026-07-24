import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../entities/provider_entities.dart';
import '../repositories/provider_repository.dart';
import 'params/provider_params.dart';

class GetPendingJobs {
  const GetPendingJobs(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, List<PendingJobEntity>>> call() =>
      repository.getPendingJobs();
}

class AcceptProviderJob {
  const AcceptProviderJob(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, AcceptedJobEntity>> call(String bookingId) =>
      repository.acceptJob(bookingId);
}

class RejectProviderJob {
  const RejectProviderJob(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, Unit>> call(String bookingId) =>
      repository.rejectJob(bookingId);
}

class CompleteProviderJob {
  const CompleteProviderJob(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, Unit>> call(String bookingId) =>
      repository.completeJob(bookingId);
}

class MarkProviderJobEnRoute {
  const MarkProviderJobEnRoute(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, Unit>> call(ProviderJobActionParams params) =>
      repository.markEnRoute(params);
}

class MarkProviderJobArrived {
  const MarkProviderJobArrived(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, Unit>> call(String bookingId) =>
      repository.markArrived(bookingId);
}

class MarkProviderJobInProgress {
  const MarkProviderJobInProgress(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, Unit>> call(String bookingId) =>
      repository.markInProgress(bookingId);
}

class GetProviderServices {
  const GetProviderServices(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, List<ProviderServiceEntity>>> call() =>
      repository.getServices();
}

class UpdateProviderServices {
  const UpdateProviderServices(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, List<ProviderServiceEntity>>> call(
    List<String> serviceIds,
  ) => repository.updateServices(serviceIds);
}

class UpdateProviderAvailability {
  const UpdateProviderAvailability(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, ProviderAvailabilityEntity>> call(
    ProviderAvailabilityParams params,
  ) => repository.updateAvailability(params);
}

class GetProviderCurrentPosition {
  const GetProviderCurrentPosition(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, ProviderCoordinatesEntity>> call() =>
      repository.getCurrentPosition();
}

class WatchProviderPosition {
  const WatchProviderPosition(this.repository);
  final ProviderRepository repository;
  Stream<Either<Failure, ProviderCoordinatesEntity>> call() =>
      repository.watchPosition();
}

class PublishProviderLocation {
  const PublishProviderLocation(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, Unit>> call(ProviderLocationParams params) =>
      repository.updateLocation(params);
}

class GetProviderEarnings {
  const GetProviderEarnings(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, ProviderEarningsEntity>> call(
    ProviderEarningsParams params,
  ) => repository.getEarnings(params);
}

class GetProviderWallet {
  const GetProviderWallet(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, ProviderWalletEntity>> call() =>
      repository.getWallet();
}

class RequestProviderPayout {
  const RequestProviderPayout(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, PayoutEntity>> call(ProviderPayoutParams params) =>
      repository.requestPayout(params);
}

class ReplyToProviderReview {
  const ReplyToProviderReview(this.repository);
  final ProviderRepository repository;
  Future<Either<Failure, Unit>> call(ProviderReviewReplyParams params) =>
      repository.replyToReview(params);
}
