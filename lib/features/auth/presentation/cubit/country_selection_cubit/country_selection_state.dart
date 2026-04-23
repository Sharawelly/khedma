import 'package:equatable/equatable.dart';

import '../../../domain/entities/cities_entity.dart';

abstract class CountrySelectionState extends Equatable {
  const CountrySelectionState();

  @override
  List<Object?> get props => [];
}

class CountrySelectionInitial extends CountrySelectionState {}

class CountrySelected extends CountrySelectionState {
  final CountryEntity country;

  const CountrySelected(this.country);

  @override
  List<Object?> get props => [country];
}
