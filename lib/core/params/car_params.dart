import 'package:equatable/equatable.dart';

class CarParams extends Equatable {
  final String? brand;
  final String? keyword;
  final String? cityId;
  final String? plan;
  final String? fromPrice;
  final String? toPrice;
  final String? cats;
  final String? sortByLowerPrice;
  final String? sortByLatestYear;
  final String? onlyCarOffer;
  final String? latitude;
  final String? longitude;
  final String? branchId;
  final String? customerId;
  final String? fromBranchId;
  final String? toBranchId;
  final String? recerveDataFrom;
  final String? recerveDataTo;
  final String? categoryId;
  final List<int>? additionalIds;
  final String? carId;

  const CarParams({
    this.brand,
    this.keyword,
    this.cityId,
    this.plan,
    this.fromPrice,
    this.toPrice,
    this.cats,
    this.sortByLowerPrice,
    this.sortByLatestYear,
    this.onlyCarOffer,
    this.latitude,
    this.longitude,
    this.branchId,
    this.customerId,
    this.fromBranchId,
    this.recerveDataFrom,
    this.recerveDataTo,
    this.categoryId,
    this.toBranchId,
    this.additionalIds,
    this.carId,
  });

  CarParams copyWith({
    String? brand,
    String? keyword,
    String? cityId,
    String? plan,
    String? fromPrice,
    String? toPrice,
    String? cats,
    String? sortByLowerPrice,
    String? sortByLatestYear,
    String? onlyCarOffer,
    String? latitude,
    String? longitude,
    String? branchId,
    String? customerId,
    String? fromBranchId,
    String? recerveDataFrom,
    String? recerveDataTo,
    String? categoryId,
    String? toBranchId,
    List<int>? additionalIds,
    String? carId,
  }) {
    return CarParams(
      brand: brand ?? this.brand,
      keyword: keyword ?? this.keyword,
      cityId: cityId ?? this.cityId,
      plan: plan ?? this.plan,
      fromPrice: fromPrice ?? this.fromPrice,
      toPrice: toPrice ?? this.toPrice,
      cats: cats ?? this.cats,
      sortByLowerPrice: sortByLowerPrice ?? this.sortByLowerPrice,
      sortByLatestYear: sortByLatestYear ?? this.sortByLatestYear,
      onlyCarOffer: onlyCarOffer ?? this.onlyCarOffer,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      branchId: branchId ?? this.branchId,
      customerId: customerId ?? this.customerId,
      fromBranchId: fromBranchId ?? this.fromBranchId,
      recerveDataFrom: recerveDataFrom ?? this.recerveDataFrom,
      recerveDataTo: recerveDataTo ?? this.recerveDataTo,
      categoryId: categoryId ?? this.categoryId,
      toBranchId: toBranchId ?? this.toBranchId,
      additionalIds: additionalIds ?? this.additionalIds,
      carId: carId ?? this.carId,
    );
  }

  @override
  List<Object?> get props => [
        brand,
        keyword,
        cityId,
        plan,
        fromPrice,
        toPrice,
        cats,
        sortByLowerPrice,
        sortByLatestYear,
        onlyCarOffer,
        latitude,
        longitude,
        branchId,
        customerId,
        fromBranchId,
        recerveDataFrom,
        recerveDataTo,
        categoryId,
        toBranchId,
        additionalIds,
        carId,
      ];
}
