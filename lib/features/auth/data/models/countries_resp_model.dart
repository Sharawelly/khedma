import '/core/base_classes/base_list_response.dart';
import '/features/auth/domain/entities/cities_entity.dart';

class CountriesRespModel extends BaseListResponse {
  const CountriesRespModel({super.data, super.message, super.success});

  factory CountriesRespModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json["data"];

    return CountriesRespModel(
      success: json["success"],
      message: json["message"],
      data: dataJson == null
          ? []
          : List<CountryModel>.from(
              (dataJson["countries"] ?? []).map(
                (x) => CountryModel.fromJson(x),
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((e) => (e as CountryModel).toJson())),
  };
}

class CountryModel extends CountryEntity {
  const CountryModel({
    super.id,
    super.nameAr,
    super.nameEn,
    super.code,
    super.currency,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      nameAr: json['name_ar'],
      nameEn: json['name_en'],
      code: json['code'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'code': code,
      'currency': currency,
    };
  }
}
