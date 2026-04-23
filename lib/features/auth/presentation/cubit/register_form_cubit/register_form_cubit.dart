import 'dart:io';

import 'package:bloc/bloc.dart';

import 'register_form_state.dart';

class RegisterFormCubit extends Cubit<RegisterFormState> {
  RegisterFormCubit() : super(RegisterFormState());

  void selectUserType(String userType) {
    emit(state.copyWith(selectedUserType: userType));
  }

  void selectImage(File? image) {
    emit(state.copyWith(selectedImage: image));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  void toggleAcceptTerms() {
    emit(state.copyWith(acceptTerms: !state.acceptTerms));
  }

  void selectGovernment(int? governmentId) {
    emit(state.copyWith(governmentId: governmentId));
  }

  void selectActivityType(int? activityTypeId) {
    emit(state.copyWith(selectedActivityTypeId: activityTypeId));
  }

  void selectGender(String? gender) {
    emit(state.copyWith(selectedGender: gender));
  }

  void updateCommercialRegistration(String? commercialRegistration) {
    emit(state.copyWith(commercialRegistration: commercialRegistration));
  }

  void updateTaxNumber(String? taxNumber) {
    emit(state.copyWith(taxNumber: taxNumber));
  }
}
