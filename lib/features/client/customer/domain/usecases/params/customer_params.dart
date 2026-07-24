class ServiceQuery {
  const ServiceQuery({
    this.categoryId,
    this.search,
    this.page = 1,
    this.pageSize = 20,
  });

  final String? categoryId;
  final String? search;
  final int page;
  final int pageSize;

  Map<String, dynamic> toJson() => <String, dynamic>{
    if (categoryId != null) 'categoryId': categoryId,
    if (search != null && search!.isNotEmpty) 'search': search,
    'page': page,
    'pageSize': pageSize,
  };
}

class ProviderQuery {
  const ProviderQuery({
    this.categoryId,
    this.search,
    this.latitude,
    this.longitude,
    this.radiusKm = 25,
    this.page = 1,
    this.pageSize = 20,
  });

  final String? categoryId;
  final String? search;
  final double? latitude;
  final double? longitude;
  final double radiusKm;
  final int page;
  final int pageSize;

  Map<String, dynamic> toJson() => <String, dynamic>{
    if (categoryId != null) 'category': categoryId,
    if (search != null && search!.isNotEmpty) 'search': search,
    if (latitude != null && longitude != null) ...<String, dynamic>{
      'lat': latitude,
      'lng': longitude,
      'radiusKm': radiusKm,
    },
    'page': page,
    'pageSize': pageSize,
  };
}

class BookingDraft {
  const BookingDraft({
    required this.serviceId,
    required this.bookingType,
    this.providerId,
    this.scheduledTime,
    this.address,
    this.latitude,
    this.longitude,
    this.addressId,
    this.notes,
    this.attachmentUrl,
  }) : assert(
         addressId == null ||
             (address == null && latitude == null && longitude == null),
       );

  final String serviceId;
  final String? providerId;
  final int bookingType;
  final DateTime? scheduledTime;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? addressId;
  final String? notes;
  final String? attachmentUrl;

  BookingDraft copyWith({
    String? providerId,
    int? bookingType,
    DateTime? scheduledTime,
    String? address,
    double? latitude,
    double? longitude,
    String? addressId,
    String? notes,
    String? attachmentUrl,
  }) {
    return BookingDraft(
      serviceId: serviceId,
      providerId: providerId ?? this.providerId,
      bookingType: bookingType ?? this.bookingType,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      addressId: addressId ?? this.addressId,
      notes: notes ?? this.notes,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'serviceId': serviceId,
    'bookingType': bookingType,
    if (scheduledTime != null)
      'scheduledTime': scheduledTime!.toUtc().toIso8601String(),
    if (addressId != null)
      'addressId': addressId
    else ...<String, dynamic>{
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    },
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
    if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
    if (providerId != null) 'providerId': providerId,
  };
}

class BookingHistoryQuery {
  const BookingHistoryQuery({this.status, this.from, this.to, this.page = 1});

  final int? status;
  final DateTime? from;
  final DateTime? to;
  final int page;

  Map<String, dynamic> toJson() => <String, dynamic>{
    if (status != null) 'status': status,
    if (from != null) 'from': from!.toUtc().toIso8601String(),
    if (to != null) 'to': to!.toUtc().toIso8601String(),
    'page': page,
  };
}

class ReviewParams {
  const ReviewParams({
    required this.rating,
    this.bookingId,
    this.comment,
    this.punctualityRating,
    this.workQualityRating,
    this.cleanlinessRating,
  });

  final String? bookingId;
  final int rating;
  final String? comment;
  final int? punctualityRating;
  final int? workQualityRating;
  final int? cleanlinessRating;

  Map<String, dynamic> toJson() => <String, dynamic>{
    if (bookingId != null) 'bookingId': bookingId,
    ...toUpdateJson(),
  };

  Map<String, dynamic> toUpdateJson() => <String, dynamic>{
    'rating': rating,
    if (comment != null && comment!.isNotEmpty) 'comment': comment,
    if (punctualityRating != null) 'punctualityRating': punctualityRating,
    if (workQualityRating != null) 'workQualityRating': workQualityRating,
    if (cleanlinessRating != null) 'cleanlinessRating': cleanlinessRating,
  };
}
