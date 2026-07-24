import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entities/customer_entities.dart';
import '../../domain/usecases/customer_use_cases.dart';
import '../../domain/usecases/params/customer_params.dart';

part 'catalog_state.dart';

enum CatalogAction {
  categories,
  services,
  service,
  providers,
  moreServices,
  moreProviders,
}

class CatalogCommand {
  const CatalogCommand._(
    this.action, {
    this.id,
    this.categoryId,
    this.search,
    this.nearby = false,
  });

  const CatalogCommand.categories() : this._(CatalogAction.categories);
  const CatalogCommand.services({String? categoryId, String? search})
    : this._(CatalogAction.services, categoryId: categoryId, search: search);
  const CatalogCommand.service(String id)
    : this._(CatalogAction.service, id: id);
  const CatalogCommand.providers({
    String? categoryId,
    String? search,
    bool nearby = true,
  }) : this._(
         CatalogAction.providers,
         categoryId: categoryId,
         search: search,
         nearby: nearby,
       );
  const CatalogCommand.moreServices() : this._(CatalogAction.moreServices);
  const CatalogCommand.moreProviders() : this._(CatalogAction.moreProviders);

  final CatalogAction action;
  final String? id;
  final String? categoryId;
  final String? search;
  final bool nearby;
}

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit({
    required this.getCategories,
    required this.getServices,
    required this.getService,
    required this.getProviders,
  }) : super(const CatalogInitial());

  final GetCategories getCategories;
  final GetServices getServices;
  final GetService getService;
  final GetProviders getProviders;
  final List<ServiceEntity> _services = <ServiceEntity>[];
  final List<ProviderSummaryEntity> _providers = <ProviderSummaryEntity>[];
  ServiceQuery _serviceQuery = const ServiceQuery();
  ProviderQuery _providerQuery = const ProviderQuery();
  bool _servicesHaveNextPage = false;
  bool _providersHaveNextPage = false;
  int _servicePage = 1;
  int _providerPage = 1;
  bool _providersNearby = false;
  bool _isLoadingMore = false;

  Future<void> execute(CatalogCommand command) async {
    if (command.action == CatalogAction.moreServices) {
      await _loadMoreServices();
      return;
    }
    if (command.action == CatalogAction.moreProviders) {
      await _loadMoreProviders();
      return;
    }
    emit(const CatalogLoading());
    switch (command.action) {
      case CatalogAction.categories:
        final result = await getCategories();
        result.fold(
          (failure) => emit(CatalogFailure(failure.message ?? '')),
          (items) => emit(CategoriesSuccess(items)),
        );
        break;
      case CatalogAction.services:
        _serviceQuery = ServiceQuery(
          categoryId: command.categoryId,
          search: command.search,
        );
        final result = await getServices(_serviceQuery);
        result.fold((failure) => emit(CatalogFailure(failure.message ?? '')), (
          page,
        ) {
          _services
            ..clear()
            ..addAll(page.items);
          _servicePage = page.pagination.page ?? 1;
          _servicesHaveNextPage = page.pagination.hasNextPage ?? false;
          emit(
            ServicesSuccess(
              List<ServiceEntity>.unmodifiable(_services),
              _servicesHaveNextPage,
            ),
          );
        });
        break;
      case CatalogAction.service:
        final result = await getService(command.id!);
        result.fold(
          (failure) => emit(CatalogFailure(failure.message ?? '')),
          (item) => emit(ServiceSuccess(item)),
        );
        break;
      case CatalogAction.providers:
        Position? position;
        if (command.nearby) {
          position = await _positionOrNull();
        }
        _providerQuery = ProviderQuery(
          categoryId: command.categoryId,
          search: command.search,
          latitude: position?.latitude,
          longitude: position?.longitude,
        );
        final result = await getProviders(_providerQuery);
        result.fold((failure) => emit(CatalogFailure(failure.message ?? '')), (
          page,
        ) {
          _providers
            ..clear()
            ..addAll(page.items);
          _providerPage = page.pagination.page ?? 1;
          _providersHaveNextPage = page.pagination.hasNextPage ?? false;
          _providersNearby = position != null;
          emit(
            ProvidersSuccess(
              List<ProviderSummaryEntity>.unmodifiable(_providers),
              nearby: _providersNearby,
              hasNextPage: _providersHaveNextPage,
            ),
          );
        });
        break;
      case CatalogAction.moreServices:
      case CatalogAction.moreProviders:
        break;
    }
  }

  Future<void> _loadMoreServices() async {
    if (_isLoadingMore || !_servicesHaveNextPage) {
      return;
    }
    _isLoadingMore = true;
    final query = ServiceQuery(
      categoryId: _serviceQuery.categoryId,
      search: _serviceQuery.search,
      page: _servicePage + 1,
      pageSize: _serviceQuery.pageSize,
    );
    final response = await getServices(query);
    response.fold((failure) => emit(CatalogFailure(failure.message ?? '')), (
      page,
    ) {
      _serviceQuery = query;
      _services.addAll(page.items);
      _servicePage = page.pagination.page ?? query.page;
      _servicesHaveNextPage = page.pagination.hasNextPage ?? false;
      emit(
        ServicesSuccess(
          List<ServiceEntity>.unmodifiable(_services),
          _servicesHaveNextPage,
        ),
      );
    });
    _isLoadingMore = false;
  }

  Future<void> _loadMoreProviders() async {
    if (_isLoadingMore || !_providersHaveNextPage) {
      return;
    }
    _isLoadingMore = true;
    final query = ProviderQuery(
      categoryId: _providerQuery.categoryId,
      search: _providerQuery.search,
      latitude: _providerQuery.latitude,
      longitude: _providerQuery.longitude,
      radiusKm: _providerQuery.radiusKm,
      page: _providerPage + 1,
      pageSize: _providerQuery.pageSize,
    );
    final response = await getProviders(query);
    response.fold((failure) => emit(CatalogFailure(failure.message ?? '')), (
      page,
    ) {
      _providerQuery = query;
      _providers.addAll(page.items);
      _providerPage = page.pagination.page ?? query.page;
      _providersHaveNextPage = page.pagination.hasNextPage ?? false;
      emit(
        ProvidersSuccess(
          List<ProviderSummaryEntity>.unmodifiable(_providers),
          nearby: _providersNearby,
          hasNextPage: _providersHaveNextPage,
        ),
      );
    });
    _isLoadingMore = false;
  }

  Future<Position?> _positionOrNull() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return null;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      return Geolocator.getCurrentPosition();
    } on Exception {
      return null;
    }
  }
}
