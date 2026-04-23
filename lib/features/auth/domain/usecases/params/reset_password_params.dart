class ResetPasswordParams {
  final String email;
  final String token;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordParams({
    required this.email,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };

  ResetPasswordParams copyWith({
    String? email,
    String? token,
    String? password,
    String? passwordConfirmation,
  }) {
    return ResetPasswordParams(
      email: email ?? this.email,
      token: token ?? this.token,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }
}
