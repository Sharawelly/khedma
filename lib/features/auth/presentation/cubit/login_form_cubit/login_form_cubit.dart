import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/domain/entities/cities_entity.dart';
import 'login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

  void selectCountry(CountryEntity country) {
    emit(state.copyWith(selectedCountry: country));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }
}

