part of 'catalog_cubit.dart';

sealed class CatalogState extends Equatable {
  const CatalogState();
  @override
  List<Object?> get props => <Object?>[];
}

class CatalogInitial extends CatalogState {
  const CatalogInitial();
}

class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

class CatalogFailure extends CatalogState {
  const CatalogFailure(this.message);
  final String message;
  @override
  List<Object?> get props => <Object?>[message];
}

class CategoriesSuccess extends CatalogState {
  const CategoriesSuccess(this.items);
  final List<CategoryEntity> items;
  @override
  List<Object?> get props => <Object?>[items];
}

class ServicesSuccess extends CatalogState {
  const ServicesSuccess(this.items, this.hasNextPage);
  final List<ServiceEntity> items;
  final bool hasNextPage;
  @override
  List<Object?> get props => <Object?>[items, hasNextPage];
}

class ServiceSuccess extends CatalogState {
  const ServiceSuccess(this.item);
  final ServiceEntity item;
  @override
  List<Object?> get props => <Object?>[item];
}

class ProvidersSuccess extends CatalogState {
  const ProvidersSuccess(
    this.items, {
    required this.nearby,
    required this.hasNextPage,
  });
  final List<ProviderSummaryEntity> items;
  final bool nearby;
  final bool hasNextPage;
  @override
  List<Object?> get props => <Object?>[items, nearby, hasNextPage];
}
