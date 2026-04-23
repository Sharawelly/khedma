import 'package:equatable/equatable.dart';
import '../../../domain/entities/cities_entity.dart';

class LoginFormState extends Equatable {
  final CountryEntity? selectedCountry;
  final bool obscurePassword;

  const LoginFormState({this.selectedCountry, this.obscurePassword = true});

  LoginFormState copyWith({
    CountryEntity? selectedCountry,
    bool? obscurePassword,
  }) {
    return LoginFormState(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object?> get props => [selectedCountry, obscurePassword];
}
