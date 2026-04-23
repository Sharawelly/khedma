 class AddServiceParams {
  final int? id;
  final String? serviceTypeId;
  final String? categoryId;
  final String? subcategoryId;
  final String? prices;
  final List? newPrices;

  AddServiceParams({
    this.id,
    this.serviceTypeId,
    this.categoryId,
    this.subcategoryId,
    this.prices,
    this.newPrices,
  });

  factory AddServiceParams.fromJson(Map<String, dynamic> json) =>
      AddServiceParams(
        id: json["id"],
        serviceTypeId: json["service_type_id"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        prices: json["prices"],
      );

  Map<String, dynamic> toJson() => {
        "service_type_id": serviceTypeId,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "prices": prices,
      };
}
