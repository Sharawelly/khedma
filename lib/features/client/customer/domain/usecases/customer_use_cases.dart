import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '../entities/customer_entities.dart';
import '../payment/payment_gateway.dart';
import '../repositories/customer_repository.dart';
import 'params/customer_params.dart';

class GetCategories {
  const GetCategories(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, List<CategoryEntity>>> call() =>
      repository.getCategories();
}

class GetServices {
  const GetServices(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, EntityPage<ServiceEntity>>> call(ServiceQuery query) =>
      repository.getServices(query);
}

class GetService {
  const GetService(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, ServiceEntity>> call(String id) =>
      repository.getService(id);
}

class GetProviders {
  const GetProviders(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, EntityPage<ProviderSummaryEntity>>> call(
    ProviderQuery query,
  ) => repository.getProviders(query);
}

class GetProvider {
  const GetProvider(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, ProviderProfileEntity>> call(String id) =>
      repository.getProvider(id);
}

class GetProviderReviews {
  const GetProviderReviews(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, EntityPage<ProviderReviewEntity>>> call(
    String providerId,
    int page,
  ) => repository.getProviderReviews(providerId, page);
}

class CreateBooking {
  const CreateBooking(this.repository, this.paymentGateway);
  final CustomerRepository repository;
  final PaymentGateway paymentGateway;

  Future<Either<Failure, CreatedBookingEntity>> call(BookingDraft draft) async {
    await paymentGateway.prepare(draft);
    return repository.createBooking(draft);
  }
}

class GetBooking {
  const GetBooking(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, BookingEntity>> call(String id) =>
      repository.getBooking(id);
}

class GetBookingHistory {
  const GetBookingHistory(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, EntityPage<BookingHistoryEntity>>> call(
    BookingHistoryQuery query,
  ) => repository.getBookingHistory(query);
}

class CancelBooking {
  const CancelBooking(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, Unit>> call(String id, String reason) =>
      repository.cancelBooking(id, reason);
}

class GetBookingEta {
  const GetBookingEta(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, EtaEntity>> call(String id) => repository.getEta(id);
}

class ToggleFavorite {
  const ToggleFavorite(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, bool>> call(String providerId) =>
      repository.toggleFavorite(providerId);
}

class GetFavorites {
  const GetFavorites(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, List<ProviderSummaryEntity>>> call() =>
      repository.getFavorites();
}

class CreateReview {
  const CreateReview(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, String>> call(ReviewParams params) =>
      repository.createReview(params);
}

class UpdateReview {
  const UpdateReview(this.repository);
  final CustomerRepository repository;
  Future<Either<Failure, String>> call(String id, ReviewParams params) =>
      repository.updateReview(id, params);
}
