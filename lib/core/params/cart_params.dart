import 'package:equatable/equatable.dart';

import '/injection_container.dart';

class CartParams extends Equatable {
  final int? id;
  final String? userId;
  final String? providerId;
  final String? subCategoryId;
  final String? subCategoryName;
  final String? subCategoryPhoto;
  final String? serviceId;
  final String? serviceTypeId;
  final String? serviceName;
  final String? servicePrice;
  final String? serviceCount;
  final String? totalPrice;

  const CartParams({
    this.id,
    this.userId,
    this.providerId,
    this.subCategoryId,
    this.subCategoryName,
    this.subCategoryPhoto,
    this.serviceId,
    this.serviceTypeId,
    this.serviceName,
    this.serviceCount,
    this.servicePrice,
    this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': "${userId ?? sharedPreferences.getUserId()}",
      'provider_id': providerId,
      'service_id': serviceId,
      'service_name': serviceName,
      'service_type_id': serviceTypeId,
      'subcategory_id': subCategoryId,
      'subcategory_name': subCategoryName,
      'subcategory_photo': subCategoryPhoto,
      'price': servicePrice,
      'quantity': serviceCount,
    };
  }

  factory CartParams.fromJson(Map<String, dynamic> json) => CartParams(
        id: json["id"],
        userId: json["user_id"],
        providerId: json["provider_id"],
        serviceId: json['service_id'],
        serviceName: json['service_name'],
        serviceTypeId: json['service_type_id'],
        subCategoryId: json['subcategory_id'],
        subCategoryName: json['subcategory_name'],
        subCategoryPhoto: json['subcategory_photo'],
        servicePrice: json['price'],
        serviceCount: json['quantity'],
      );

  @override
  String toString() {
    return '''CartParams(
      id: $id,
      providerId: $providerId,
      serviceId: $serviceId,
      serviceName: $serviceName,
      subCategoryId: $subCategoryId,
      subCategoryPhoto: $subCategoryPhoto,
      servicePrice: $servicePrice,
      serviceCount: $serviceCount,
     ''';
  }

  @override
  List<Object?> get props => [
        id,
        subCategoryId,
        subCategoryName,
        subCategoryPhoto,
        serviceId,
        serviceName,
        serviceCount,
        servicePrice,
        totalPrice,
      ];

  CartParams copyWith({
    int? id,
    String? subCategoryId,
    String? serviceId,
    String? path,
  }) =>
      CartParams(
        id: id ?? this.id,
        subCategoryId: subCategoryId ?? this.subCategoryId,
        serviceId: serviceId ?? this.serviceId,
      );
}
