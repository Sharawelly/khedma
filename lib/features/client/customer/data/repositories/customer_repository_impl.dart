import 'package:dartz/dartz.dart';

import '/core/error/exceptions.dart';
import '/core/error/failures.dart';
import '../../domain/entities/customer_entities.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/usecases/params/customer_params.dart';
import '../datasources/customer_remote_datasource.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl(this.remote);
  final CustomerRemoteDataSource remote;

  Future<Either<Failure, T>> _request<T>(Future<T> Function() request) async {
    try {
      return Right<Failure, T>(await request());
    } on AppException catch (error) {
      return Left<Failure, T>(error.toFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() =>
      _request<List<CategoryEntity>>(remote.getCategories);

  @override
  Future<Either<Failure, EntityPage<ServiceEntity>>> getServices(
    ServiceQuery query,
  ) => _request<EntityPage<ServiceEntity>>(() => remote.getServices(query));

  @override
  Future<Either<Failure, ServiceEntity>> getService(String id) =>
      _request<ServiceEntity>(() => remote.getService(id));

  @override
  Future<Either<Failure, EntityPage<ProviderSummaryEntity>>> getProviders(
    ProviderQuery query,
  ) => _request<EntityPage<ProviderSummaryEntity>>(
    () => remote.getProviders(query),
  );

  @override
  Future<Either<Failure, ProviderProfileEntity>> getProvider(String id) =>
      _request<ProviderProfileEntity>(() => remote.getProvider(id));

  @override
  Future<Either<Failure, EntityPage<ProviderReviewEntity>>> getProviderReviews(
    String providerId,
    int page,
  ) => _request<EntityPage<ProviderReviewEntity>>(
    () => remote.getProviderReviews(providerId, page),
  );

  @override
  Future<Either<Failure, CreatedBookingEntity>> createBooking(
    BookingDraft draft,
  ) => _request<CreatedBookingEntity>(() => remote.createBooking(draft));

  @override
  Future<Either<Failure, BookingEntity>> getBooking(String id) =>
      _request<BookingEntity>(() => remote.getBooking(id));

  @override
  Future<Either<Failure, EntityPage<BookingHistoryEntity>>> getBookingHistory(
    BookingHistoryQuery query,
  ) => _request<EntityPage<BookingHistoryEntity>>(
    () => remote.getBookingHistory(query),
  );

  @override
  Future<Either<Failure, Unit>> cancelBooking(String id, String reason) =>
      _request<Unit>(() async {
        await remote.cancelBooking(id, reason);
        return unit;
      });

  @override
  Future<Either<Failure, EtaEntity>> getEta(String id) =>
      _request<EtaEntity>(() => remote.getEta(id));

  @override
  Future<Either<Failure, bool>> toggleFavorite(String providerId) =>
      _request<bool>(() => remote.toggleFavorite(providerId));

  @override
  Future<Either<Failure, List<ProviderSummaryEntity>>> getFavorites() =>
      _request<List<ProviderSummaryEntity>>(remote.getFavorites);

  @override
  Future<Either<Failure, String>> createReview(ReviewParams params) =>
      _request<String>(() => remote.createReview(params));

  @override
  Future<Either<Failure, String>> updateReview(
    String id,
    ReviewParams params,
  ) => _request<String>(() => remote.updateReview(id, params));
}
