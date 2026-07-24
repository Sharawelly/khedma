import '/core/base_classes/pagination.dart';

class PaginationModel extends Pagination {
  const PaginationModel({
    super.page,
    super.pageSize,
    super.totalCount,
    super.totalPages,
    super.hasNextPage,
    super.hasPreviousPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      PaginationModel(
        page: json['page'],
        pageSize: json['pageSize'],
        totalCount: json['totalCount'],
        totalPages: json['totalPages'],
        hasNextPage: json['hasNextPage'],
        hasPreviousPage: json['hasPreviousPage'],
      );

  Map<String, dynamic> toJson() => {
    'page': page,
    'pageSize': pageSize,
    'totalCount': totalCount,
    'totalPages': totalPages,
    'hasNextPage': hasNextPage,
    'hasPreviousPage': hasPreviousPage,
  };
}
