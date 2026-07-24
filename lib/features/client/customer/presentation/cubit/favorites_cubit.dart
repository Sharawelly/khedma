import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/customer_entities.dart';
import '../../domain/usecases/customer_use_cases.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this.getFavorites) : super(const FavoritesInitial());
  final GetFavorites getFavorites;

  Future<void> load() async {
    emit(const FavoritesLoading());
    final response = await getFavorites();
    response.fold(
      (failure) => emit(FavoritesFailure(failure.message ?? '')),
      (providers) => emit(FavoritesSuccess(providers)),
    );
  }
}
