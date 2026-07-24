import '/core/base_classes/pagination.dart';

class CategoryEntity {
  const CategoryEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.serviceCount,
    this.iconUrl,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String? iconUrl;
  final int serviceCount;

  String localizedName(bool isArabic) => isArabic ? nameAr : nameEn;
}

class ServiceEntity {
  const ServiceEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.imageUrls,
    required this.categoryId,
    required this.categoryNameEn,
    required this.categoryNameAr,
    required this.currency,
    required this.rating,
    required this.reviewCount,
    this.descriptionEn,
    this.descriptionAr,
    this.imageUrl,
    this.fixedPrice,
    this.estimatedDurationMin,
    this.estimatedDurationMax,
    this.vatRate,
    this.vatAmount,
    this.total,
    this.availableProvidersCount,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? imageUrl;
  final List<String> imageUrls;
  final String categoryId;
  final String categoryNameEn;
  final String categoryNameAr;
  final double? fixedPrice;
  final String currency;
  final int? estimatedDurationMin;
  final int? estimatedDurationMax;
  final double rating;
  final int reviewCount;
  final double? vatRate;
  final double? vatAmount;
  final double? total;
  final int? availableProvidersCount;

  String localizedName(bool isArabic) => isArabic ? nameAr : nameEn;
  String localizedDescription(bool isArabic) =>
      (isArabic ? descriptionAr : descriptionEn) ?? '';
  String localizedCategory(bool isArabic) =>
      isArabic ? categoryNameAr : categoryNameEn;
}

class ProviderSummaryEntity {
  const ProviderSummaryEntity({
    required this.id,
    required this.name,
    required this.reviewCount,
    this.photo,
    this.jobTitle,
    this.rating,
    this.hourlyRate,
    this.distanceKm,
  });

  final String id;
  final String name;
  final String? photo;
  final String? jobTitle;
  final double? rating;
  final int reviewCount;
  final double? hourlyRate;
  final double? distanceKm;
}

class ProviderReviewEntity {
  const ProviderReviewEntity({
    required this.id,
    required this.customerName,
    required this.rating,
    required this.createdAt,
    this.customerAvatarUrl,
    this.comment,
  });

  final String id;
  final String customerName;
  final String? customerAvatarUrl;
  final double rating;
  final String? comment;
  final DateTime createdAt;
}

class CertificateEntity {
  const CertificateEntity({required this.id, required this.imageUrl});
  final String id;
  final String imageUrl;
}

class ProviderProfileEntity {
  const ProviderProfileEntity({
    required this.id,
    required this.fullName,
    required this.isVerified,
    required this.isOnline,
    required this.reviewCount,
    required this.numberOfJobsDone,
    required this.portfolioImages,
    required this.certificates,
    required this.reviews,
    required this.servicesOffered,
    required this.workingAreas,
    this.jobTitle,
    this.avatarUrl,
    this.rating,
    this.experienceYears,
    this.descriptionEn,
    this.descriptionAr,
  });

  final String id;
  final String fullName;
  final String? jobTitle;
  final String? avatarUrl;
  final bool isVerified;
  final bool isOnline;
  final double? rating;
  final int reviewCount;
  final int numberOfJobsDone;
  final int? experienceYears;
  final String? descriptionEn;
  final String? descriptionAr;
  final List<String> portfolioImages;
  final List<CertificateEntity> certificates;
  final List<ProviderReviewEntity> reviews;
  final List<ServiceEntity> servicesOffered;
  final List<String> workingAreas;

  String localizedDescription(bool isArabic) =>
      (isArabic ? descriptionAr : descriptionEn) ?? '';
}

class PriceBreakdownEntity {
  const PriceBreakdownEntity({
    required this.serviceFee,
    required this.vatRate,
    required this.vatAmount,
    required this.total,
    required this.currency,
  });

  final double serviceFee;
  final double vatRate;
  final double vatAmount;
  final double total;
  final String currency;
}

class CreatedBookingEntity {
  const CreatedBookingEntity({
    required this.bookingId,
    required this.status,
    required this.statusLabelEn,
    required this.statusLabelAr,
    required this.priceBreakdown,
    required this.providersNotified,
    required this.dispatchStarted,
  });

  final String bookingId;
  final int status;
  final String statusLabelEn;
  final String statusLabelAr;
  final PriceBreakdownEntity priceBreakdown;
  final int providersNotified;
  final bool dispatchStarted;
}

class BookingEntity {
  const BookingEntity({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.serviceId,
    required this.serviceName,
    required this.bookingType,
    required this.status,
    required this.statusLabelEn,
    required this.statusLabelAr,
    required this.totalPrice,
    required this.createAt,
    this.providerId,
    this.providerName,
    this.providerPhone,
    this.providerRating,
    this.providerPhoto,
    this.scheduledTime,
    this.address,
    this.latitude,
    this.longitude,
    this.notes,
    this.cancelReason,
    this.acceptedAt,
    this.enRouteAt,
    this.arrivedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
  });

  final String id;
  final String customerId;
  final String customerName;
  final String? providerId;
  final String? providerName;
  final String? providerPhone;
  final double? providerRating;
  final String? providerPhoto;
  final String serviceId;
  final String serviceName;
  final int bookingType;
  final DateTime? scheduledTime;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int status;
  final String statusLabelEn;
  final String statusLabelAr;
  final double totalPrice;
  final String? notes;
  final String? cancelReason;
  final DateTime createAt;
  final DateTime? acceptedAt;
  final DateTime? enRouteAt;
  final DateTime? arrivedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  String localizedStatus(bool isArabic) =>
      isArabic ? statusLabelAr : statusLabelEn;
}

class BookingHistoryEntity {
  const BookingHistoryEntity({
    required this.id,
    required this.customerName,
    required this.serviceName,
    required this.status,
    required this.totalPrice,
    required this.createAt,
    this.providerName,
    this.scheduledTime,
  });

  final String id;
  final String customerName;
  final String? providerName;
  final String serviceName;
  final int status;
  final double totalPrice;
  final DateTime? scheduledTime;
  final DateTime createAt;
}

class EtaEntity {
  const EtaEntity({
    required this.bookingId,
    required this.etaMinutes,
    required this.distanceKm,
    required this.source,
    required this.calculatedAt,
  });

  final String bookingId;
  final int etaMinutes;
  final double distanceKm;
  final String source;
  final DateTime calculatedAt;
  bool get isApproximate => source == 'Haversine';
}

class EntityPage<T> {
  const EntityPage({required this.items, required this.pagination});
  final List<T> items;
  final Pagination pagination;
}
