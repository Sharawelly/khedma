import '/core/base_classes/pagination_model.dart';
import '/core/utils/server_datetime.dart';
import '../../domain/entities/customer_entities.dart';

double _double(Object? value) => value is num ? value.toDouble() : 0;
double? _nullableDouble(Object? value) =>
    value is num ? value.toDouble() : null;
int _int(Object? value) => value is num ? value.toInt() : 0;
int? _nullableInt(Object? value) => value is num ? value.toInt() : null;

/// Server timestamps are UTC but arrive without a zone marker;
/// [parseServerDateTime] reads them as UTC rather than device-local time.
DateTime? _date(Object? value) => parseServerDateTime(value);

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.nameEn,
    required super.nameAr,
    required super.serviceCount,
    super.iconUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] as String,
    nameEn: json['nameEn'] as String,
    nameAr: json['nameAr'] as String,
    iconUrl: json['iconUrl'] as String?,
    serviceCount: _int(json['serviceCount']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'nameEn': nameEn,
    'nameAr': nameAr,
    'iconUrl': iconUrl,
    'serviceCount': serviceCount,
  };
}

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.nameEn,
    required super.nameAr,
    required super.imageUrls,
    required super.categoryId,
    required super.categoryNameEn,
    required super.categoryNameAr,
    required super.currency,
    required super.rating,
    required super.reviewCount,
    super.descriptionEn,
    super.descriptionAr,
    super.imageUrl,
    super.fixedPrice,
    super.estimatedDurationMin,
    super.estimatedDurationMax,
    super.vatRate,
    super.vatAmount,
    super.total,
    super.availableProvidersCount,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json['id'] as String,
    nameEn: json['nameEn'] as String,
    nameAr: json['nameAr'] as String,
    descriptionEn: json['descriptionEn'] as String?,
    descriptionAr: json['descriptionAr'] as String?,
    imageUrl: json['imageUrl'] as String?,
    imageUrls: (json['imageUrls'] as List<Object?>? ?? <Object?>[])
        .whereType<String>()
        .toList(),
    categoryId: json['categoryId'] as String,
    categoryNameEn: json['categoryNameEn'] as String,
    categoryNameAr: json['categoryNameAr'] as String,
    fixedPrice: _nullableDouble(json['fixedPrice']),
    currency: json['currency'] as String? ?? '',
    estimatedDurationMin: (json['estimatedDurationMin'] as num?)?.toInt(),
    estimatedDurationMax: (json['estimatedDurationMax'] as num?)?.toInt(),
    rating: _double(json['rating']),
    reviewCount: _int(json['reviewCount']),
    vatRate: _nullableDouble(json['vatRate']),
    vatAmount: _nullableDouble(json['vatAmount']),
    total: _nullableDouble(json['total']),
    availableProvidersCount: (json['availableProvidersCount'] as num?)?.toInt(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'nameEn': nameEn,
    'nameAr': nameAr,
    'descriptionEn': descriptionEn,
    'descriptionAr': descriptionAr,
    'imageUrl': imageUrl,
    'imageUrls': imageUrls,
    'categoryId': categoryId,
    'categoryNameEn': categoryNameEn,
    'categoryNameAr': categoryNameAr,
    'fixedPrice': fixedPrice,
    'currency': currency,
    'estimatedDurationMin': estimatedDurationMin,
    'estimatedDurationMax': estimatedDurationMax,
    'rating': rating,
    'reviewCount': reviewCount,
    'vatRate': vatRate,
    'vatAmount': vatAmount,
    'total': total,
    'availableProvidersCount': availableProvidersCount,
  };
}

class ProviderSummaryModel extends ProviderSummaryEntity {
  const ProviderSummaryModel({
    required super.id,
    required super.name,
    required super.reviewCount,
    super.photo,
    super.jobTitle,
    super.rating,
    super.hourlyRate,
    super.distanceKm,
  });

  factory ProviderSummaryModel.fromJson(Map<String, dynamic> json) =>
      ProviderSummaryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        photo: json['photo'] as String?,
        jobTitle: json['jobTitle'] as String?,
        rating: _nullableDouble(json['rating']),
        reviewCount: _int(json['reviewCount']),
        hourlyRate: _nullableDouble(json['hourlyRate']),
        distanceKm: _nullableDouble(json['distanceKm']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'photo': photo,
    'jobTitle': jobTitle,
    'rating': rating,
    'reviewCount': reviewCount,
    'hourlyRate': hourlyRate,
    'distanceKm': distanceKm,
  };
}

class ProviderReviewModel extends ProviderReviewEntity {
  const ProviderReviewModel({
    required super.id,
    required super.customerName,
    required super.rating,
    required super.createdAt,
    super.customerAvatarUrl,
    super.comment,
  });

  factory ProviderReviewModel.fromJson(Map<String, dynamic> json) =>
      ProviderReviewModel(
        id: json['id'] as String,
        customerName: json['customerName'] as String,
        customerAvatarUrl: json['customerAvatarUrl'] as String?,
        rating: _double(json['rating']),
        comment: json['comment'] as String?,
        createdAt:
            _date(json['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'customerName': customerName,
    'customerAvatarUrl': customerAvatarUrl,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt.toIso8601String(),
  };
}

class CertificateModel extends CertificateEntity {
  const CertificateModel({required super.id, required super.imageUrl});

  factory CertificateModel.fromJson(Map<String, dynamic> json) =>
      CertificateModel(
        id: json['id'] as String,
        imageUrl: json['imageUrl'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'imageUrl': imageUrl,
  };
}

class ProviderProfileModel extends ProviderProfileEntity {
  const ProviderProfileModel({
    required super.id,
    required super.fullName,
    required super.isVerified,
    required super.isOnline,
    required super.reviewCount,
    required super.numberOfJobsDone,
    required super.portfolioImages,
    required super.certificates,
    required super.reviews,
    required super.servicesOffered,
    required super.workingAreas,
    super.jobTitle,
    super.avatarUrl,
    super.rating,
    super.experienceYears,
    super.descriptionEn,
    super.descriptionAr,
  });

  factory ProviderProfileModel.fromJson(
    Map<String, dynamic> json,
  ) => ProviderProfileModel(
    id: json['id'] as String,
    fullName: json['fullName'] as String,
    jobTitle: json['jobTitle'] as String?,
    avatarUrl: json['avatarUrl'] as String?,
    isVerified: json['isVerified'] as bool? ?? false,
    isOnline: json['isOnline'] as bool? ?? false,
    rating: _nullableDouble(json['rating']),
    reviewCount: _int(json['reviewCount']),
    numberOfJobsDone: _int(json['numberOfJobsDone']),
    experienceYears: (json['experienceYears'] as num?)?.toInt(),
    descriptionEn: json['descriptionEn'] as String?,
    descriptionAr: json['descriptionAr'] as String?,
    portfolioImages: (json['portfolioImages'] as List<Object?>? ?? <Object?>[])
        .whereType<String>()
        .toList(),
    certificates: (json['certificates'] as List<Object?>? ?? <Object?>[])
        .whereType<Map<String, dynamic>>()
        .map(CertificateModel.fromJson)
        .toList(),
    reviews: (json['reviews'] as List<Object?>? ?? <Object?>[])
        .whereType<Map<String, dynamic>>()
        .map(ProviderReviewModel.fromJson)
        .toList(),
    servicesOffered: (json['servicesOffered'] as List<Object?>? ?? <Object?>[])
        .whereType<Map<String, dynamic>>()
        .map(ServiceModel.fromJson)
        .toList(),
    workingAreas: (json['workingAreas'] as List<Object?>? ?? <Object?>[])
        .whereType<String>()
        .toList(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'fullName': fullName,
    'jobTitle': jobTitle,
    'avatarUrl': avatarUrl,
    'isVerified': isVerified,
    'isOnline': isOnline,
    'rating': rating,
    'reviewCount': reviewCount,
    'numberOfJobsDone': numberOfJobsDone,
    'experienceYears': experienceYears,
    'descriptionEn': descriptionEn,
    'descriptionAr': descriptionAr,
    'portfolioImages': portfolioImages,
    'certificates': certificates
        .whereType<CertificateModel>()
        .map((certificate) => certificate.toJson())
        .toList(),
    'reviews': reviews
        .whereType<ProviderReviewModel>()
        .map((review) => review.toJson())
        .toList(),
  };
}

class PriceBreakdownModel extends PriceBreakdownEntity {
  const PriceBreakdownModel({
    required super.serviceFee,
    required super.vatRate,
    required super.vatAmount,
    required super.total,
    required super.currency,
  });

  factory PriceBreakdownModel.fromJson(Map<String, dynamic> json) =>
      PriceBreakdownModel(
        serviceFee: _double(json['serviceFee']),
        vatRate: _double(json['vatRate']),
        vatAmount: _double(json['vatAmount']),
        total: _double(json['total']),
        currency: json['currency'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'serviceFee': serviceFee,
    'vatRate': vatRate,
    'vatAmount': vatAmount,
    'total': total,
    'currency': currency,
  };
}

class CreatedBookingModel extends CreatedBookingEntity {
  const CreatedBookingModel({
    required super.bookingId,
    required super.status,
    required super.statusLabelEn,
    required super.statusLabelAr,
    required super.priceBreakdown,
    required super.providersNotified,
    required super.dispatchStarted,
  });

  factory CreatedBookingModel.fromJson(Map<String, dynamic> json) =>
      CreatedBookingModel(
        bookingId: json['bookingId'] as String,
        status: _int(json['status']),
        statusLabelEn: json['statusLabelEn'] as String,
        statusLabelAr: json['statusLabelAr'] as String,
        priceBreakdown: PriceBreakdownModel.fromJson(
          json['priceBreakdown'] as Map<String, dynamic>,
        ),
        providersNotified: _int(json['providersNotified']),
        dispatchStarted: json['dispatchStarted'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'bookingId': bookingId,
    'status': status,
    'statusLabelEn': statusLabelEn,
    'statusLabelAr': statusLabelAr,
    'priceBreakdown': <String, dynamic>{
      'serviceFee': priceBreakdown.serviceFee,
      'vatRate': priceBreakdown.vatRate,
      'vatAmount': priceBreakdown.vatAmount,
      'total': priceBreakdown.total,
      'currency': priceBreakdown.currency,
    },
    'providersNotified': providersNotified,
    'dispatchStarted': dispatchStarted,
  };
}

class BookingRouteModel extends BookingRouteEntity {
  const BookingRouteModel({
    required super.bookingId,
    required super.originLatitude,
    required super.originLongitude,
    required super.destinationLatitude,
    required super.destinationLongitude,
    required super.etaMinutes,
    required super.distanceKm,
    required super.source,
    super.encodedPolyline,
  });

  factory BookingRouteModel.fromJson(Map<String, dynamic> json) =>
      BookingRouteModel(
        bookingId: json['bookingId'] as String,
        originLatitude: _double(json['originLatitude']),
        originLongitude: _double(json['originLongitude']),
        destinationLatitude: _double(json['destinationLatitude']),
        destinationLongitude: _double(json['destinationLongitude']),
        encodedPolyline: json['polyline'] as String?,
        etaMinutes: _int(json['etaMinutes']),
        distanceKm: _double(json['distanceKm']),
        source: json['source'] as String? ?? 'Haversine',
      );
}

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.customerId,
    required super.customerName,
    required super.serviceId,
    required super.serviceName,
    required super.bookingType,
    required super.status,
    required super.statusLabelEn,
    required super.statusLabelAr,
    required super.totalPrice,
    required super.createAt,
    super.serviceNameEn,
    super.serviceNameAr,
    super.providerId,
    super.providerName,
    super.providerPhone,
    super.providerRating,
    super.providerPhoto,
    super.scheduledTime,
    super.address,
    super.latitude,
    super.longitude,
    super.notes,
    super.cancelReason,
    super.acceptedAt,
    super.enRouteAt,
    super.arrivedAt,
    super.startedAt,
    super.completedAt,
    super.cancelledAt,
    super.cancellationFee,
    super.customerPhone,
    super.providerEarning,
    super.currency,
    super.review,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    id: json['id'] as String,
    customerId: json['customerId'] as String,
    customerName: json['customerName'] as String,
    providerId: json['providerId'] as String?,
    providerName: json['providerName'] as String?,
    providerPhone: json['providerPhone'] as String?,
    providerRating: _nullableDouble(json['providerRating']),
    providerPhoto: json['providerPhoto'] as String?,
    serviceId: json['serviceId'] as String,
    serviceName: json['serviceName'] as String,
    serviceNameEn: json['serviceNameEn'] as String?,
    serviceNameAr: json['serviceNameAr'] as String?,
    bookingType: _int(json['bookingType']),
    scheduledTime: _date(json['scheduledTime']),
    address: json['address'] as String?,
    latitude: _nullableDouble(json['latitude']),
    longitude: _nullableDouble(json['longitude']),
    status: _int(json['status']),
    statusLabelEn: json['statusLabelEn'] as String,
    statusLabelAr: json['statusLabelAr'] as String,
    totalPrice: _double(json['totalPrice']),
    notes: json['notes'] as String?,
    cancelReason: json['cancelReason'] as String?,
    createAt: _date(json['createAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
    acceptedAt: _date(json['acceptedAt']),
    enRouteAt: _date(json['enRouteAt']),
    arrivedAt: _date(json['arrivedAt']),
    startedAt: _date(json['startedAt']),
    completedAt: _date(json['completedAt']),
    cancelledAt: _date(json['cancelledAt']),
    cancellationFee: _nullableDouble(json['cancellationFee']),
    customerPhone: json['customerPhone'] as String?,
    providerEarning: _nullableDouble(json['providerEarning']),
    currency: json['currency'] as String?,
    review: json['review'] is Map<String, dynamic>
        ? BookingReviewModel.fromJson(json['review'] as Map<String, dynamic>)
        : null,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'customerId': customerId,
    'customerName': customerName,
    'providerId': providerId,
    'providerName': providerName,
    'providerPhone': providerPhone,
    'providerRating': providerRating,
    'providerPhoto': providerPhoto,
    'serviceId': serviceId,
    'serviceName': serviceName,
    'serviceNameEn': serviceNameEn,
    'serviceNameAr': serviceNameAr,
    'bookingType': bookingType,
    'scheduledTime': scheduledTime?.toIso8601String(),
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'status': status,
    'statusLabelEn': statusLabelEn,
    'statusLabelAr': statusLabelAr,
    'totalPrice': totalPrice,
    'notes': notes,
    'cancelReason': cancelReason,
    'createAt': createAt.toIso8601String(),
    'acceptedAt': acceptedAt?.toIso8601String(),
    'enRouteAt': enRouteAt?.toIso8601String(),
    'arrivedAt': arrivedAt?.toIso8601String(),
    'startedAt': startedAt?.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'cancelledAt': cancelledAt?.toIso8601String(),
    'cancellationFee': cancellationFee,
  };
}

class BookingReviewModel extends BookingReviewEntity {
  const BookingReviewModel({
    required super.id,
    required super.rating,
    required super.createAt,
    super.comment,
    super.providerReply,
    super.providerReplyAt,
    super.punctualityRating,
    super.workQualityRating,
    super.cleanlinessRating,
  });

  factory BookingReviewModel.fromJson(Map<String, dynamic> json) =>
      BookingReviewModel(
        id: json['id'] as String,
        rating: _int(json['rating']),
        comment: json['comment'] as String?,
        providerReply: json['providerReply'] as String?,
        providerReplyAt: _date(json['providerReplyAt']),
        punctualityRating: _nullableInt(json['punctualityRating']),
        workQualityRating: _nullableInt(json['workQualityRating']),
        cleanlinessRating: _nullableInt(json['cleanlinessRating']),
        createAt:
            _date(json['createAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      );
}

class BookingHistoryModel extends BookingHistoryEntity {
  const BookingHistoryModel({
    required super.id,
    required super.customerName,
    required super.serviceName,
    required super.status,
    required super.totalPrice,
    required super.createAt,
    super.serviceNameEn,
    super.serviceNameAr,
    super.providerName,
    super.scheduledTime,
  });

  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) =>
      BookingHistoryModel(
        id: json['id'] as String,
        // BookingListDto (history) omits customerName — only the detail DTO
        // carries it. Casting the missing field with `as String` threw a
        // TypeError that killed the whole list parse.
        customerName: json['customerName'] as String? ?? '',
        providerName: json['providerName'] as String?,
        serviceName: json['serviceName'] as String,
        serviceNameEn: json['serviceNameEn'] as String?,
        serviceNameAr: json['serviceNameAr'] as String?,
        status: _int(json['status']),
        totalPrice: _double(json['totalPrice']),
        scheduledTime: _date(json['scheduledTime']),
        createAt:
            _date(json['createAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'customerName': customerName,
    'providerName': providerName,
    'serviceName': serviceName,
    'serviceNameEn': serviceNameEn,
    'serviceNameAr': serviceNameAr,
    'status': status,
    'totalPrice': totalPrice,
    'scheduledTime': scheduledTime?.toIso8601String(),
    'createAt': createAt.toIso8601String(),
  };
}

class EtaModel extends EtaEntity {
  const EtaModel({
    required super.bookingId,
    required super.etaMinutes,
    required super.distanceKm,
    required super.source,
    required super.calculatedAt,
  });

  factory EtaModel.fromJson(Map<String, dynamic> json) => EtaModel(
    bookingId: json['bookingId'] as String,
    etaMinutes: _int(json['etaMinutes']),
    distanceKm: _double(json['distanceKm']),
    source: json['source'] as String,
    calculatedAt:
        _date(json['calculatedAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'bookingId': bookingId,
    'etaMinutes': etaMinutes,
    'distanceKm': distanceKm,
    'source': source,
    'calculatedAt': calculatedAt.toIso8601String(),
  };
}

class ModelPage<T> extends EntityPage<T> {
  const ModelPage({required super.items, required super.pagination});

  factory ModelPage.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) parse,
  ) {
    final values = json['data'] as List<Object?>? ?? <Object?>[];
    return ModelPage<T>(
      items: values.whereType<Map<String, dynamic>>().map(parse).toList(),
      pagination: PaginationModel.fromJson(json),
    );
  }
}
