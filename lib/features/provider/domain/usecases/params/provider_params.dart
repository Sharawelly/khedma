class ProviderAvailabilityParams {
  const ProviderAvailabilityParams({
    required this.status,
    this.latitude,
    this.longitude,
  });

  final int status;
  final double? latitude;
  final double? longitude;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'status': status,
    if (latitude != null && longitude != null) ...<String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    },
  };
}

class ProviderJobActionParams {
  const ProviderJobActionParams(this.bookingId, {this.eta});

  final String bookingId;
  final int? eta;
}

class ProviderLocationParams {
  const ProviderLocationParams({
    required this.latitude,
    required this.longitude,
    this.headingDegrees,
  });

  final double latitude;
  final double longitude;
  final double? headingDegrees;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'latitude': latitude,
    'longitude': longitude,
    if (headingDegrees != null) 'headingDegrees': headingDegrees,
  };
}

class ProviderEarningsParams {
  const ProviderEarningsParams(this.period);

  final String period;

  Map<String, dynamic> toQuery() => <String, dynamic>{'period': period};
}

class ProviderPayoutParams {
  const ProviderPayoutParams(this.amount);

  final double amount;

  Map<String, dynamic> toJson() => <String, dynamic>{'amount': amount};
}

class ProviderReviewReplyParams {
  const ProviderReviewReplyParams({
    required this.reviewId,
    required this.reply,
  });

  final String reviewId;
  final String reply;
}
