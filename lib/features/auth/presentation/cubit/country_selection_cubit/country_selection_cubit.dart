import 'package:bloc/bloc.dart';

import '../../../domain/entities/cities_entity.dart';
import 'country_selection_state.dart';

class CountrySelectionCubit extends Cubit<CountrySelectionState> {
  CountrySelectionCubit() : super(CountrySelectionInitial());

  void selectCountry(CountryEntity country) {
    emit(CountrySelected(country));
  }

  void clearSelection() {
    emit(CountrySelectionInitial());
  }

  CountryEntity? get selectedCountry {
    if (state is CountrySelected) {
      return (state as CountrySelected).country;
    }
    return null;
  }
}
