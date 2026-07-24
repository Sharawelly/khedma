import 'package:equatable/equatable.dart';

class Pagination extends Equatable {
  final int? page;
  final int? pageSize;
  final int? totalCount;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;

  const Pagination({
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json['page'],
    pageSize: json['pageSize'],
    totalCount: json['totalCount'],
    totalPages: json['totalPages'],
    hasNextPage: json['hasNextPage'],
    hasPreviousPage: json['hasPreviousPage'],
  );

  @override
  List<Object?> get props => [
    page,
    pageSize,
    totalCount,
    totalPages,
    hasNextPage,
    hasPreviousPage,
  ];
}
