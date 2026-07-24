import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../entities/customer_entities.dart';
import '../usecases/params/customer_params.dart';

abstract class CustomerRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, EntityPage<ServiceEntity>>> getServices(
    ServiceQuery query,
  );
  Future<Either<Failure, ServiceEntity>> getService(String id);
  Future<Either<Failure, EntityPage<ProviderSummaryEntity>>> getProviders(
    ProviderQuery query,
  );
  Future<Either<Failure, ProviderProfileEntity>> getProvider(String id);
  Future<Either<Failure, EntityPage<ProviderReviewEntity>>> getProviderReviews(
    String providerId,
    int page,
  );
  Future<Either<Failure, CreatedBookingEntity>> createBooking(
    BookingDraft draft,
  );
  Future<Either<Failure, BookingEntity>> getBooking(String id);
  Future<Either<Failure, EntityPage<BookingHistoryEntity>>> getBookingHistory(
    BookingHistoryQuery query,
  );
  Future<Either<Failure, Unit>> cancelBooking(String id, String reason);
  Future<Either<Failure, EtaEntity>> getEta(String id);
  Future<Either<Failure, bool>> toggleFavorite(String providerId);
  Future<Either<Failure, List<ProviderSummaryEntity>>> getFavorites();
  Future<Either<Failure, String>> createReview(ReviewParams params);
  Future<Either<Failure, String>> updateReview(String id, ReviewParams params);
}
