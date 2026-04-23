part of 'create_account_form_cubit.dart';

enum PasswordStrength { none, weak, fair, strong }

class CreateAccountFormState extends Equatable {
  final bool obscurePassword;
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasNumber;
  final bool formFieldsFilled;
  final bool passwordNotEmpty;

  const CreateAccountFormState({
    this.obscurePassword = true,
    this.hasMinLength = false,
    this.hasUppercase = false,
    this.hasNumber = false,
    this.formFieldsFilled = false,
    this.passwordNotEmpty = false,
  });

  PasswordStrength get strength {
    if (!hasMinLength && !hasUppercase && !hasNumber) {
      return PasswordStrength.none;
    }
    final met = [hasMinLength, hasUppercase, hasNumber]
        .where((bool c) => c)
        .length;
    if (met <= 1) return PasswordStrength.weak;
    if (met == 2) return PasswordStrength.fair;
    return PasswordStrength.strong;
  }

  CreateAccountFormState copyWith({
    bool? obscurePassword,
    bool? hasMinLength,
    bool? hasUppercase,
    bool? hasNumber,
    bool? formFieldsFilled,
    bool? passwordNotEmpty,
  }) {
    return CreateAccountFormState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasNumber: hasNumber ?? this.hasNumber,
      formFieldsFilled: formFieldsFilled ?? this.formFieldsFilled,
      passwordNotEmpty: passwordNotEmpty ?? this.passwordNotEmpty,
    );
  }

  @override
  List<Object?> get props => [
        obscurePassword,
        hasMinLength,
        hasUppercase,
        hasNumber,
        formFieldsFilled,
        passwordNotEmpty,
      ];
}
