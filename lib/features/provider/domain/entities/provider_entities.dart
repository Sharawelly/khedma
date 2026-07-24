class PendingJobEntity {
  const PendingJobEntity({
    required this.bookingId,
    required this.serviceNameEn,
    required this.serviceNameAr,
    required this.categoryNameEn,
    required this.categoryNameAr,
    required this.customerFirstName,
    required this.distanceKm,
    required this.providerEarning,
    required this.currency,
    required this.bookingType,
    required this.expiresAt,
    required this.secondsRemaining,
    this.customerAvatarUrl,
    this.estimatedDurationMin,
    this.estimatedDurationMax,
    this.scheduledTime,
  });

  final String bookingId;
  final String serviceNameEn;
  final String serviceNameAr;
  final String categoryNameEn;
  final String categoryNameAr;
  final String customerFirstName;
  final String? customerAvatarUrl;
  final double distanceKm;
  final double providerEarning;
  final String currency;
  final int? estimatedDurationMin;
  final int? estimatedDurationMax;
  final String bookingType;
  final DateTime? scheduledTime;
  final DateTime expiresAt;
  final int secondsRemaining;

  String localizedService(bool isArabic) =>
      isArabic ? serviceNameAr : serviceNameEn;
  String localizedCategory(bool isArabic) =>
      isArabic ? categoryNameAr : categoryNameEn;

  PendingJobEntity copyWith({int? secondsRemaining}) => PendingJobEntity(
    bookingId: bookingId,
    serviceNameEn: serviceNameEn,
    serviceNameAr: serviceNameAr,
    categoryNameEn: categoryNameEn,
    categoryNameAr: categoryNameAr,
    customerFirstName: customerFirstName,
    customerAvatarUrl: customerAvatarUrl,
    distanceKm: distanceKm,
    providerEarning: providerEarning,
    currency: currency,
    estimatedDurationMin: estimatedDurationMin,
    estimatedDurationMax: estimatedDurationMax,
    bookingType: bookingType,
    scheduledTime: scheduledTime,
    expiresAt: expiresAt,
    secondsRemaining: secondsRemaining ?? this.secondsRemaining,
  );
}

enum ProviderJobStage {
  accepted,
  enRoute,
  arrived,
  inProgress,
  completed,
  cancelled,
}

class AcceptedJobEntity {
  const AcceptedJobEntity({
    required this.bookingId,
    required this.accepted,
    required this.customerName,
    required this.serviceNameEn,
    required this.serviceNameAr,
    required this.providerEarning,
    required this.currency,
    required this.acceptedAt,
    this.address,
    this.latitude,
    this.longitude,
    this.customerPhone,
    this.notes,
    this.scheduledTime,
    this.stage = ProviderJobStage.accepted,
  });

  final String bookingId;
  final bool accepted;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String customerName;
  final String? customerPhone;
  final String serviceNameEn;
  final String serviceNameAr;
  final double providerEarning;
  final String currency;
  final String? notes;
  final DateTime? scheduledTime;
  final DateTime acceptedAt;
  final ProviderJobStage stage;

  String localizedService(bool isArabic) =>
      isArabic ? serviceNameAr : serviceNameEn;

  AcceptedJobEntity copyWith({ProviderJobStage? stage}) => AcceptedJobEntity(
    bookingId: bookingId,
    accepted: accepted,
    address: address,
    latitude: latitude,
    longitude: longitude,
    customerName: customerName,
    customerPhone: customerPhone,
    serviceNameEn: serviceNameEn,
    serviceNameAr: serviceNameAr,
    providerEarning: providerEarning,
    currency: currency,
    notes: notes,
    scheduledTime: scheduledTime,
    acceptedAt: acceptedAt,
    stage: stage ?? this.stage,
  );
}

class ProviderCoordinatesEntity {
  const ProviderCoordinatesEntity({
    required this.latitude,
    required this.longitude,
    this.headingDegrees,
  });

  final double latitude;
  final double longitude;
  final double? headingDegrees;
}

class ProviderAvailabilityEntity {
  const ProviderAvailabilityEntity({
    required this.status,
    this.latitude,
    this.longitude,
  });

  final int status;
  final double? latitude;
  final double? longitude;
}

class EarningsBreakdownEntity {
  const EarningsBreakdownEntity({
    required this.bookingId,
    required this.serviceName,
    required this.date,
    required this.gross,
    required this.commission,
    required this.net,
  });

  final String bookingId;
  final String serviceName;
  final DateTime date;
  final double gross;
  final double commission;
  final double net;
}

class ProviderEarningsEntity {
  const ProviderEarningsEntity({
    required this.period,
    required this.from,
    required this.to,
    required this.totalGross,
    required this.totalCommissionDeducted,
    required this.totalEarned,
    required this.bookingsCount,
    required this.currency,
    required this.commissionRate,
    required this.breakdown,
  });

  final String period;
  final DateTime from;
  final DateTime to;
  final double totalGross;
  final double totalCommissionDeducted;
  final double totalEarned;
  final int bookingsCount;
  final String currency;
  final double commissionRate;
  final List<EarningsBreakdownEntity> breakdown;
}

class PayoutEntity {
  const PayoutEntity({
    required this.id,
    required this.amount,
    required this.status,
    required this.requestedAt,
    this.paidAt,
    this.reference,
  });

  final String id;
  final double amount;

  /// ProviderPayoutDto.Status is a string server-side, unlike the integer
  /// enums used elsewhere in this API.
  final String status;
  final DateTime requestedAt;
  final DateTime? paidAt;
  final String? reference;
}

class ProviderWalletEntity {
  const ProviderWalletEntity({
    required this.availableBalance,
    required this.pendingBalance,
    required this.totalEarned,
    required this.totalWithdrawn,
    required this.currency,
    required this.recentPayouts,
    this.nextPayoutDate,
  });

  final double availableBalance;
  final double pendingBalance;
  final double totalEarned;
  final double totalWithdrawn;
  final String currency;
  final DateTime? nextPayoutDate;
  final List<PayoutEntity> recentPayouts;
}
