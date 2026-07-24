import 'dart:convert';

import '/core/api/dio_consumer.dart';
import '/core/error/exceptions.dart';
import '/injection_container.dart';
import '../../domain/usecases/params/provider_params.dart';
import '../models/provider_models.dart';

abstract class ProviderRemoteDataSource {
  Future<List<PendingJobModel>> getPendingJobs();
  Future<AcceptedJobModel> acceptJob(String bookingId);
  Future<void> rejectJob(String bookingId);
  Future<void> completeJob(String bookingId);
  Future<void> markEnRoute(ProviderJobActionParams params);
  Future<void> markArrived(String bookingId);
  Future<void> markInProgress(String bookingId);
  Future<ProviderAvailabilityModel> updateAvailability(
    ProviderAvailabilityParams params,
  );
  Future<void> updateLocation(ProviderLocationParams params);
  Future<List<ProviderServiceModel>> getServices();
  Future<List<ProviderServiceModel>> updateServices(List<String> serviceIds);
  Future<ProviderEarningsModel> getEarnings(ProviderEarningsParams params);
  Future<ProviderWalletModel> getWallet();
  Future<PayoutModel> requestPayout(ProviderPayoutParams params);
  Future<void> replyToReview(ProviderReviewReplyParams params);
}

class ProviderRemoteDataSourceImpl implements ProviderRemoteDataSource {
  @override
  Future<List<PendingJobModel>> getPendingJobs() async {
    final data = _responseMap(
      await dioConsumer.get(ApiConstants.pendingJobs),
    )['data'];
    return (data as List<Object?>? ?? <Object?>[])
        .whereType<Map<String, dynamic>>()
        .map(PendingJobModel.fromJson)
        .toList();
  }

  @override
  Future<AcceptedJobModel> acceptJob(String bookingId) async {
    final data = _responseMap(
      await dioConsumer.post(ApiConstants.acceptBooking(bookingId)),
    )['data'];
    final acceptedJob = AcceptedJobModel.fromJson(data as Map<String, dynamic>);
    if (!acceptedJob.accepted) {
      throw const ServerException(message: 'provider_job_accept_failed');
    }
    return acceptedJob;
  }

  @override
  Future<void> rejectJob(String bookingId) async {
    _responseMap(await dioConsumer.post(ApiConstants.rejectBooking(bookingId)));
  }

  @override
  Future<void> completeJob(String bookingId) async {
    _responseMap(
      await dioConsumer.post(ApiConstants.completeBooking(bookingId)),
    );
  }

  @override
  Future<void> markEnRoute(ProviderJobActionParams params) async {
    _responseMap(
      await dioConsumer.post(
        ApiConstants.markBookingEnRoute(params.bookingId),
        queryParameters: params.eta == null
            ? null
            : <String, dynamic>{'eta': params.eta},
      ),
    );
  }

  @override
  Future<void> markArrived(String bookingId) async {
    _responseMap(
      await dioConsumer.post(ApiConstants.markBookingArrived(bookingId)),
    );
  }

  @override
  Future<void> markInProgress(String bookingId) async {
    _responseMap(
      await dioConsumer.post(ApiConstants.markBookingInProgress(bookingId)),
    );
  }

  @override
  Future<ProviderAvailabilityModel> updateAvailability(
    ProviderAvailabilityParams params,
  ) async {
    final data = _responseMap(
      await dioConsumer.put(
        ApiConstants.providerAvailability,
        body: params.toJson(),
      ),
    )['data'];
    return ProviderAvailabilityModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> updateLocation(ProviderLocationParams params) async {
    // Returns ApiResponse<bool>, not the point that was stored - the caller
    // already knows the coordinates it just sent.
    _responseMap(
      await dioConsumer.post(
        ApiConstants.updateLocation,
        body: params.toJson(),
      ),
    );
  }

  @override
  Future<List<ProviderServiceModel>> getServices() async =>
      _services(await dioConsumer.get(ApiConstants.providerServices));

  @override
  Future<List<ProviderServiceModel>> updateServices(
    List<String> serviceIds,
  ) async => _services(
    await dioConsumer.put(
      ApiConstants.providerServices,
      body: <String, dynamic>{'serviceIds': serviceIds},
    ),
  );

  List<ProviderServiceModel> _services(Object? response) {
    final data = _responseMap(response)['data'];
    return (data as List<Object?>? ?? <Object?>[])
        .whereType<Map<String, dynamic>>()
        .map(ProviderServiceModel.fromJson)
        .toList();
  }

  @override
  Future<ProviderEarningsModel> getEarnings(
    ProviderEarningsParams params,
  ) async {
    final data = _responseMap(
      await dioConsumer.get(
        ApiConstants.providerEarnings,
        queryParameters: params.toQuery(),
      ),
    )['data'];
    return ProviderEarningsModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<ProviderWalletModel> getWallet() async {
    final data = _responseMap(
      await dioConsumer.get(ApiConstants.providerWallet),
    )['data'];
    return ProviderWalletModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<PayoutModel> requestPayout(ProviderPayoutParams params) async {
    final data = _responseMap(
      await dioConsumer.post(
        ApiConstants.providerPayouts,
        body: params.toJson(),
      ),
    )['data'];
    return PayoutModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> replyToReview(ProviderReviewReplyParams params) async {
    _responseMap(
      await dioConsumer.post(
        ApiConstants.replyToReview(params.reviewId),
        body: jsonEncode(params.reply),
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
