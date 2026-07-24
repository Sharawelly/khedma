import 'package:flutter_test/flutter_test.dart';
import 'package:khedma/features/auth/data/models/auth_resp_model.dart';
import 'package:khedma/features/client/customer/data/models/customer_models.dart';
import 'package:khedma/features/provider/data/models/provider_models.dart';

void main() {
  group('paged response contract', () {
    test('reads the array from data and pagination from the top level', () {
      final page = ModelPage<CategoryModel>.fromJson(<String, dynamic>{
        'success': true,
        'data': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'category-guid',
            'nameEn': 'Cleaning',
            'nameAr': 'تنظيف',
            'iconUrl': null,
            'serviceCount': 4,
          },
        ],
        'page': 2,
        'pageSize': 20,
        'totalCount': 45,
        'totalPages': 3,
        'hasNextPage': true,
        'hasPreviousPage': true,
      }, CategoryModel.fromJson);

      expect(page.items.single.id, 'category-guid');
      expect(page.pagination.page, 2);
      expect(page.pagination.totalPages, 3);
      expect(page.pagination.hasNextPage, isTrue);
    });
  });

  group('auth response contract', () {
    test('round-trips the auth-specific token envelope', () {
      final json = <String, dynamic>{
        'isSuccess': true,
        'errorMessage': null,
        'token': <String, dynamic>{
          'accessToken': 'access-token',
          'refreshToken': 'refresh-token',
          'expiresAt': '2026-07-24T12:30:00.000Z',
          'role': 'Customer',
          'userName': 'customer@example.com',
          'userId': 'identity-guid',
        },
      };

      final response = AuthRespModel.fromJson(json);

      expect(response.isSuccess, isTrue);
      expect(response.token?.userId, 'identity-guid');
      expect(response.toJson(), json);
    });
  });

  group('model type contracts', () {
    test('preserves payout string and availability integer statuses', () {
      final payout = PayoutModel.fromJson(<String, dynamic>{
        'id': 'payout-guid',
        'amount': 125.5,
        'status': 'Pending',
        'requestedAt': '2026-07-24T10:00:00.000Z',
        'paidAt': null,
        'reference': null,
      });
      final availability = ProviderAvailabilityModel.fromJson(<String, dynamic>{
        'status': 1,
        'latitude': 30.0444,
        'longitude': 31.2357,
      });

      expect(payout.status, isA<String>());
      expect(payout.toJson()['status'], 'Pending');
      expect(availability.status, isA<int>());
      expect(availability.toJson()['status'], 1);
    });

    test('round-trips pending job bookingType as a string', () {
      final json = <String, dynamic>{
        'bookingId': 'booking-guid',
        'serviceNameEn': 'Cleaning',
        'serviceNameAr': 'تنظيف',
        'categoryNameEn': 'Home',
        'categoryNameAr': 'المنزل',
        'customerFirstName': 'Mona',
        'customerAvatarUrl': null,
        'distanceKm': 2.5,
        'providerEarning': 95.0,
        'currency': 'EGP',
        'estimatedDurationMin': 30,
        'estimatedDurationMax': 60,
        'bookingType': 'Scheduled',
        'scheduledTime': '2026-07-25T10:00:00.000Z',
        'expiresAt': '2026-07-24T10:05:00.000Z',
        'secondsRemaining': 300,
      };

      final job = PendingJobModel.fromJson(json);

      expect(job.bookingType, isA<String>());
      expect(job.toJson()['bookingType'], 'Scheduled');
    });
  });
}
