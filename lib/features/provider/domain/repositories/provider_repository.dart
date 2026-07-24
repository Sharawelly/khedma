import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../entities/provider_entities.dart';
import '../usecases/params/provider_params.dart';

abstract class ProviderRepository {
  Future<Either<Failure, List<PendingJobEntity>>> getPendingJobs();
  Future<Either<Failure, AcceptedJobEntity>> acceptJob(String bookingId);
  Future<Either<Failure, Unit>> rejectJob(String bookingId);
  Future<Either<Failure, Unit>> completeJob(String bookingId);
  Future<Either<Failure, Unit>> markEnRoute(ProviderJobActionParams params);
  Future<Either<Failure, Unit>> markArrived(String bookingId);
  Future<Either<Failure, Unit>> markInProgress(String bookingId);
  Future<Either<Failure, ProviderAvailabilityEntity>> updateAvailability(
    ProviderAvailabilityParams params,
  );
  Future<Either<Failure, ProviderCoordinatesEntity>> getCurrentPosition();
  Stream<Either<Failure, ProviderCoordinatesEntity>> watchPosition();
  Future<Either<Failure, ProviderCoordinatesEntity>> updateLocation(
    ProviderLocationParams params,
  );
  Future<Either<Failure, ProviderEarningsEntity>> getEarnings(
    ProviderEarningsParams params,
  );
  Future<Either<Failure, ProviderWalletEntity>> getWallet();
  Future<Either<Failure, PayoutEntity>> requestPayout(
    ProviderPayoutParams params,
  );
  Future<Either<Failure, Unit>> replyToReview(ProviderReviewReplyParams params);
}
