import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entities/customer_entities.dart';
import '../../domain/usecases/customer_use_cases.dart';
import '../../domain/usecases/params/customer_params.dart';

part 'catalog_state.dart';

enum CatalogAction { categories, services, service, providers }

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

  Future<void> execute(CatalogCommand command) async {
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
        final result = await getServices(
          ServiceQuery(categoryId: command.categoryId, search: command.search),
        );
        result.fold(
          (failure) => emit(CatalogFailure(failure.message ?? '')),
          (page) => emit(ServicesSuccess(page.items)),
        );
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
        final result = await getProviders(
          ProviderQuery(
            categoryId: command.categoryId,
            search: command.search,
            latitude: position?.latitude,
            longitude: position?.longitude,
          ),
        );
        result.fold(
          (failure) => emit(CatalogFailure(failure.message ?? '')),
          (page) =>
              emit(ProvidersSuccess(page.items, nearby: position != null)),
        );
        break;
    }
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
