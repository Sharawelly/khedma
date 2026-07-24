part of 'favorites_cubit.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object?> get props => <Object?>[];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesFailure extends FavoritesState {
  const FavoritesFailure(this.message);
  final String message;
  @override
  List<Object?> get props => <Object?>[message];
}

class FavoritesSuccess extends FavoritesState {
  const FavoritesSuccess(this.providers);
  final List<ProviderSummaryEntity> providers;
  @override
  List<Object?> get props => <Object?>[providers];
}
