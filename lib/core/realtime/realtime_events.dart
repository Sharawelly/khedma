enum RealtimeHub { booking, chat, notifications }

class RealtimeHubConnected {
  const RealtimeHubConnected(this.hub);

  final RealtimeHub hub;
}

enum JobOfferDismissalKind { expired, taken, cancelled }

class JobOfferDismissed {
  const JobOfferDismissed({
    required this.bookingId,
    required this.kind,
    this.reason,
  });

  final String bookingId;
  final JobOfferDismissalKind kind;
  final String? reason;
}

class BookingStatusChangedEvent {
  const BookingStatusChangedEvent({
    required this.bookingId,
    required this.status,
    required this.statusLabelEn,
    required this.statusLabelAr,
    required this.changedAt,
    this.etaMinutes,
    this.message,
  });

  final String bookingId;
  final int status;
  final String statusLabelEn;
  final String statusLabelAr;
  final DateTime changedAt;
  final int? etaMinutes;
  final String? message;

  String localizedLabel(bool isArabic) =>
      isArabic ? statusLabelAr : statusLabelEn;
}

class ProviderAssignedEvent {
  const ProviderAssignedEvent({
    required this.providerId,
    required this.fullName,
    required this.reviewCount,
    required this.isVerified,
    this.jobTitle,
    this.avatarUrl,
    this.rating,
    this.etaMinutes,
    this.distanceKm,
    this.phoneNumber,
    this.currentLatitude,
    this.currentLongitude,
  });

  final String providerId;
  final String fullName;
  final String? jobTitle;
  final String? avatarUrl;
  final double? rating;
  final int reviewCount;
  final bool isVerified;
  final int? etaMinutes;
  final double? distanceKm;
  final String? phoneNumber;
  final double? currentLatitude;
  final double? currentLongitude;
}

class ProviderLocationEvent {
  const ProviderLocationEvent({
    required this.bookingId,
    required this.providerId,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
    this.headingDegrees,
    this.etaMinutes,
  });

  final String bookingId;
  final String providerId;
  final double latitude;
  final double longitude;
  final double? headingDegrees;
  final int? etaMinutes;
  final DateTime updatedAt;
}

class NoProviderFoundEvent {
  const NoProviderFoundEvent({
    required this.bookingId,
    required this.roundsTried,
  });

  final String bookingId;
  final int roundsTried;
}

class PaymentStatusChangedEvent {
  const PaymentStatusChangedEvent(this.payload);

  final Map<String, dynamic> payload;
}

class MessageReadEvent {
  const MessageReadEvent({required this.bookingId, required this.messageId});

  final String bookingId;
  final String messageId;
}

class ChatLockedEvent {
  const ChatLockedEvent(this.bookingId);

  final String bookingId;
}

class PresenceChangedEvent {
  const PresenceChangedEvent({required this.userId, required this.isOnline});

  final String userId;
  final bool isOnline;
}
