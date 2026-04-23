import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_account_form_state.dart';

class CreateAccountFormCubit extends Cubit<CreateAccountFormState> {
  CreateAccountFormCubit() : super(const CreateAccountFormState());

  void onFormInputChanged({
    required String name,
    required String email,
    required String password,
  }) {
    final String trimmedName = name.trim();
    final String trimmedEmail = email.trim();
    final bool filled = trimmedName.isNotEmpty &&
        trimmedEmail.isNotEmpty &&
        password.isNotEmpty;
    emit(
      state.copyWith(
        hasMinLength: password.length >= 8,
        hasUppercase: password.contains(RegExp(r'[A-Z]')),
        hasNumber: password.contains(RegExp(r'[0-9]')),
        formFieldsFilled: filled,
        passwordNotEmpty: password.isNotEmpty,
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }
}
