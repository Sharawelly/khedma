import '/core/utils/server_datetime.dart';
import '../../domain/entities/provider_entities.dart';

double _double(Object? value) => value is num ? value.toDouble() : 0;
double? _nullableDouble(Object? value) =>
    value is num ? value.toDouble() : null;
int _int(Object? value) => value is num ? value.toInt() : 0;

/// Server timestamps are UTC but arrive zone-less; [parseServerDateTime] reads
/// them as UTC so deadline math is not thrown off by the device's offset.
DateTime? _date(Object? value) => parseServerDateTime(value);

class PendingJobModel extends PendingJobEntity {
  const PendingJobModel({
    required super.bookingId,
    required super.serviceNameEn,
    required super.serviceNameAr,
    required super.categoryNameEn,
    required super.categoryNameAr,
    required super.customerFirstName,
    required super.distanceKm,
    required super.providerEarning,
    required super.currency,
    required super.bookingType,
    required super.expiresAt,
    required super.secondsRemaining,
    super.customerAvatarUrl,
    super.estimatedDurationMin,
    super.estimatedDurationMax,
    super.scheduledTime,
  });

  factory PendingJobModel.fromJson(Map<String, dynamic> json) =>
      PendingJobModel(
        bookingId: json['bookingId'] as String,
        serviceNameEn: json['serviceNameEn'] as String,
        serviceNameAr: json['serviceNameAr'] as String,
        categoryNameEn: json['categoryNameEn'] as String,
        categoryNameAr: json['categoryNameAr'] as String,
        customerFirstName: json['customerFirstName'] as String,
        customerAvatarUrl: json['customerAvatarUrl'] as String?,
        distanceKm: _double(json['distanceKm']),
        providerEarning: _double(json['providerEarning']),
        currency: json['currency'] as String? ?? '',
        estimatedDurationMin: (json['estimatedDurationMin'] as num?)?.toInt(),
        estimatedDurationMax: (json['estimatedDurationMax'] as num?)?.toInt(),
        bookingType: json['bookingType'] as String,
        scheduledTime: _date(json['scheduledTime']),
        expiresAt:
            _date(json['expiresAt']) ??
            DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        secondsRemaining: _int(json['secondsRemaining']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'bookingId': bookingId,
    'serviceNameEn': serviceNameEn,
    'serviceNameAr': serviceNameAr,
    'categoryNameEn': categoryNameEn,
    'categoryNameAr': categoryNameAr,
    'customerFirstName': customerFirstName,
    'customerAvatarUrl': customerAvatarUrl,
    'distanceKm': distanceKm,
    'providerEarning': providerEarning,
    'currency': currency,
    'estimatedDurationMin': estimatedDurationMin,
    'estimatedDurationMax': estimatedDurationMax,
    'bookingType': bookingType,
    'scheduledTime': scheduledTime?.toIso8601String(),
    'expiresAt': expiresAt.toIso8601String(),
    'secondsRemaining': secondsRemaining,
  };
}

class AcceptedJobModel extends AcceptedJobEntity {
  const AcceptedJobModel({
    required super.bookingId,
    required super.accepted,
    required super.customerName,
    required super.serviceNameEn,
    required super.serviceNameAr,
    required super.providerEarning,
    required super.currency,
    required super.acceptedAt,
    super.address,
    super.latitude,
    super.longitude,
    super.customerPhone,
    super.notes,
    super.scheduledTime,
  });

  factory AcceptedJobModel.fromJson(Map<String, dynamic> json) =>
      AcceptedJobModel(
        bookingId: json['bookingId'] as String,
        accepted: json['accepted'] as bool? ?? false,
        address: json['address'] as String?,
        latitude: _nullableDouble(json['latitude']),
        longitude: _nullableDouble(json['longitude']),
        customerName: json['customerName'] as String,
        customerPhone: json['customerPhone'] as String?,
        serviceNameEn: json['serviceNameEn'] as String,
        serviceNameAr: json['serviceNameAr'] as String,
        providerEarning: _double(json['providerEarning']),
        currency: json['currency'] as String? ?? '',
        notes: json['notes'] as String?,
        scheduledTime: _date(json['scheduledTime']),
        acceptedAt:
            _date(json['acceptedAt']) ??
            DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'bookingId': bookingId,
    'accepted': accepted,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'serviceNameEn': serviceNameEn,
    'serviceNameAr': serviceNameAr,
    'providerEarning': providerEarning,
    'currency': currency,
    'notes': notes,
    'scheduledTime': scheduledTime?.toIso8601String(),
    'acceptedAt': acceptedAt.toIso8601String(),
  };
}

class ProviderServiceModel extends ProviderServiceEntity {
  const ProviderServiceModel({
    required super.serviceId,
    required super.nameEn,
    required super.nameAr,
    required super.categoryNameEn,
    required super.categoryNameAr,
    required super.isOffered,
    super.image,
    super.fixedPrice,
  });

  factory ProviderServiceModel.fromJson(Map<String, dynamic> json) =>
      ProviderServiceModel(
        serviceId: json['serviceId'] as String,
        nameEn: json['nameEn'] as String? ?? '',
        nameAr: json['nameAr'] as String? ?? '',
        categoryNameEn: json['categoryNameEn'] as String? ?? '',
        categoryNameAr: json['categoryNameAr'] as String? ?? '',
        isOffered: json['isOffered'] as bool? ?? false,
        image: json['image'] as String?,
        fixedPrice: _nullableDouble(json['fixedPrice']),
      );
}

class ProviderAvailabilityModel extends ProviderAvailabilityEntity {
  const ProviderAvailabilityModel({
    required super.status,
    super.latitude,
    super.longitude,
  });

  factory ProviderAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      ProviderAvailabilityModel(
        status: json['status'] as int,
        latitude: _nullableDouble(json['latitude']),
        longitude: _nullableDouble(json['longitude']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'status': status,
    'latitude': latitude,
    'longitude': longitude,
  };
}


class EarningsBreakdownModel extends EarningsBreakdownEntity {
  const EarningsBreakdownModel({
    required super.bookingId,
    required super.serviceName,
    required super.date,
    required super.gross,
    required super.commission,
    required super.net,
  });

  factory EarningsBreakdownModel.fromJson(Map<String, dynamic> json) =>
      EarningsBreakdownModel(
        bookingId: json['bookingId'] as String,
        serviceName: json['serviceName'] as String,
        date:
            _date(json['date']) ??
            DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        gross: _double(json['gross']),
        commission: _double(json['commission']),
        net: _double(json['net']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'bookingId': bookingId,
    'serviceName': serviceName,
    'date': date.toIso8601String(),
    'gross': gross,
    'commission': commission,
    'net': net,
  };
}

class ProviderEarningsModel extends ProviderEarningsEntity {
  const ProviderEarningsModel({
    required super.period,
    required super.from,
    required super.to,
    required super.totalGross,
    required super.totalCommissionDeducted,
    required super.totalEarned,
    required super.bookingsCount,
    required super.currency,
    required super.commissionRate,
    required super.breakdown,
  });

  factory ProviderEarningsModel.fromJson(Map<String, dynamic> json) =>
      ProviderEarningsModel(
        period: json['period'] as String? ?? '',
        from:
            _date(json['from']) ??
            DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        to:
            _date(json['to']) ??
            DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        totalGross: _double(json['totalGross']),
        totalCommissionDeducted: _double(json['totalCommissionDeducted']),
        totalEarned: _double(json['totalEarned']),
        bookingsCount: _int(json['bookingsCount']),
        currency: json['currency'] as String? ?? '',
        commissionRate: _double(json['commissionRate']),
        breakdown: (json['breakdown'] as List<Object?>? ?? <Object?>[])
            .whereType<Map<String, dynamic>>()
            .map(EarningsBreakdownModel.fromJson)
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'period': period,
    'from': from.toIso8601String(),
    'to': to.toIso8601String(),
    'totalGross': totalGross,
    'totalCommissionDeducted': totalCommissionDeducted,
    'totalEarned': totalEarned,
    'bookingsCount': bookingsCount,
    'currency': currency,
    'commissionRate': commissionRate,
    'breakdown': breakdown
        .whereType<EarningsBreakdownModel>()
        .map((item) => item.toJson())
        .toList(),
  };
}

class PayoutModel extends PayoutEntity {
  const PayoutModel({
    required super.id,
    required super.amount,
    required super.status,
    required super.requestedAt,
    super.paidAt,
    super.reference,
  });

  factory PayoutModel.fromJson(Map<String, dynamic> json) => PayoutModel(
    id: json['id'] as String,
    amount: _double(json['amount']),
    status: json['status'] as String? ?? '',
    requestedAt:
        _date(json['requestedAt']) ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    paidAt: _date(json['paidAt']),
    reference: json['reference'] as String?,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'amount': amount,
    'status': status,
    'requestedAt': requestedAt.toIso8601String(),
    'paidAt': paidAt?.toIso8601String(),
    'reference': reference,
  };
}

class ProviderWalletModel extends ProviderWalletEntity {
  const ProviderWalletModel({
    required super.availableBalance,
    required super.pendingBalance,
    required super.totalEarned,
    required super.totalWithdrawn,
    required super.currency,
    required super.recentPayouts,
    super.nextPayoutDate,
  });

  factory ProviderWalletModel.fromJson(Map<String, dynamic> json) =>
      ProviderWalletModel(
        availableBalance: _double(json['availableBalance']),
        pendingBalance: _double(json['pendingBalance']),
        totalEarned: _double(json['totalEarned']),
        totalWithdrawn: _double(json['totalWithdrawn']),
        currency: json['currency'] as String? ?? '',
        nextPayoutDate: _date(json['nextPayoutDate']),
        recentPayouts: (json['recentPayouts'] as List<Object?>? ?? <Object?>[])
            .whereType<Map<String, dynamic>>()
            .map(PayoutModel.fromJson)
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'availableBalance': availableBalance,
    'pendingBalance': pendingBalance,
    'totalEarned': totalEarned,
    'totalWithdrawn': totalWithdrawn,
    'currency': currency,
    'nextPayoutDate': nextPayoutDate?.toIso8601String(),
    'recentPayouts': recentPayouts
        .whereType<PayoutModel>()
        .map((item) => item.toJson())
        .toList(),
  };
}
