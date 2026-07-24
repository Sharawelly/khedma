import 'dart:convert';

import '/core/api/dio_consumer.dart';
import '/core/error/exceptions.dart';
import '/injection_container.dart';
import '../../domain/usecases/params/customer_params.dart';
import '../models/customer_models.dart';

abstract class CustomerRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<ModelPage<ServiceModel>> getServices(ServiceQuery query);
  Future<ServiceModel> getService(String id);
  Future<ModelPage<ProviderSummaryModel>> getProviders(ProviderQuery query);
  Future<ProviderProfileModel> getProvider(String id);
  Future<ModelPage<ProviderReviewModel>> getProviderReviews(
    String providerId,
    int page,
  );
  Future<PriceBreakdownModel> getQuote(String serviceId);
  Future<CreatedBookingModel> createBooking(BookingDraft draft);
  Future<BookingModel> getBooking(String id);
  Future<ModelPage<BookingHistoryModel>> getBookingHistory(
    BookingHistoryQuery query,
  );
  Future<void> cancelBooking(String id, String reason);
  Future<EtaModel> getEta(String id);
  Future<BookingRouteModel> getRoute(String id);
  Future<bool> toggleFavorite(String providerId);
  Future<List<ProviderSummaryModel>> getFavorites();
  Future<String> createReview(ReviewParams params);
  Future<void> updateReview(String id, ReviewParams params);
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  @override
  Future<List<CategoryModel>> getCategories() async {
    final map = _responseMap(
      await dioConsumer.get(ApiConstants.publicCategories),
    );
    return (map['data'] as List<Object?>? ?? <Object?>[])
        .whereType<Map<String, dynamic>>()
        .map(CategoryModel.fromJson)
        .toList();
  }

  @override
  Future<ModelPage<ServiceModel>> getServices(ServiceQuery query) async {
    return ModelPage<ServiceModel>.fromJson(
      _responseMap(
        await dioConsumer.get(
          ApiConstants.publicServices,
          queryParameters: query.toJson(),
        ),
      ),
      ServiceModel.fromJson,
    );
  }

  @override
  Future<ServiceModel> getService(String id) async {
    final data = _responseMap(
      await dioConsumer.get(ApiConstants.publicService(id)),
    )['data'];
    return ServiceModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<ModelPage<ProviderSummaryModel>> getProviders(
    ProviderQuery query,
  ) async {
    return ModelPage<ProviderSummaryModel>.fromJson(
      _responseMap(
        await dioConsumer.get(
          ApiConstants.publicProviders,
          queryParameters: query.toJson(),
        ),
      ),
      ProviderSummaryModel.fromJson,
    );
  }

  @override
  Future<ProviderProfileModel> getProvider(String id) async {
    final data = _responseMap(
      await dioConsumer.get(ApiConstants.publicProvider(id)),
    )['data'];
    return ProviderProfileModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<ModelPage<ProviderReviewModel>> getProviderReviews(
    String providerId,
    int page,
  ) async {
    return ModelPage<ProviderReviewModel>.fromJson(
      _responseMap(
        await dioConsumer.get(
          ApiConstants.providerReviews(providerId),
          queryParameters: <String, dynamic>{'page': page},
        ),
      ),
      ProviderReviewModel.fromJson,
    );
  }

  @override
  Future<CreatedBookingModel> createBooking(BookingDraft draft) async {
    final path = draft.providerId == null
        ? ApiConstants.booking
        : ApiConstants.directBooking;
    final data = _responseMap(
      await dioConsumer.post(path, body: draft.toJson()),
    )['data'];
    return CreatedBookingModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<PriceBreakdownModel> getQuote(String serviceId) async {
    final data = _responseMap(
      await dioConsumer.get(
        ApiConstants.bookingQuote,
        queryParameters: <String, dynamic>{'serviceId': serviceId},
      ),
    )['data'];
    return PriceBreakdownModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<BookingModel> getBooking(String id) async {
    final data = _responseMap(
      await dioConsumer.get(ApiConstants.bookingDetails(id)),
    )['data'];
    return BookingModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<ModelPage<BookingHistoryModel>> getBookingHistory(
    BookingHistoryQuery query,
  ) async {
    return ModelPage<BookingHistoryModel>.fromJson(
      _responseMap(
        await dioConsumer.get(
          ApiConstants.bookingHistory,
          queryParameters: query.toJson(),
        ),
      ),
      BookingHistoryModel.fromJson,
    );
  }

  @override
  Future<void> cancelBooking(String id, String reason) async {
    _responseMap(
      await dioConsumer.delete(
        ApiConstants.bookingDetails(id),
        data: jsonEncode(reason),
      ),
    );
  }

  @override
  Future<EtaModel> getEta(String id) async {
    final data = _responseMap(
      await dioConsumer.get(ApiConstants.bookingEta(id)),
    )['data'];
    return EtaModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<BookingRouteModel> getRoute(String id) async {
    final data = _responseMap(
      await dioConsumer.get(ApiConstants.bookingRoute(id)),
    )['data'];
    return BookingRouteModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<bool> toggleFavorite(String providerId) async {
    final data = _responseMap(
      await dioConsumer.post(ApiConstants.favoriteProvider(providerId)),
    )['data'];
    return data as bool;
  }

  @override
  Future<List<ProviderSummaryModel>> getFavorites() async {
    final data = _responseMap(
      await dioConsumer.get(ApiConstants.favorites),
    )['data'];
    return (data as List<Object?>? ?? <Object?>[])
        .whereType<Map<String, dynamic>>()
        .map(ProviderSummaryModel.fromJson)
        .toList();
  }

  @override
  Future<String> createReview(ReviewParams params) async {
    final data = _responseMap(
      await dioConsumer.post(ApiConstants.reviews, body: params.toJson()),
    )['data'];
    return data as String;
  }

  @override
  Future<void> updateReview(String id, ReviewParams params) async {
    // The update endpoint answers with a plain `data: true`, not the review id.
    _responseMap(
      await dioConsumer.put(
        ApiConstants.review(id),
        body: params.toUpdateJson(),
      ),
    );
  }

  Map<String, dynamic> _responseMap(Object? response) {
    if (response is! Map<String, dynamic> || response['success'] != true) {
      throw ServerException(
        message: response is Map<String, dynamic>
            ? response['message'] as String?
            : null,
      );
    }
    return response;
  }
}
