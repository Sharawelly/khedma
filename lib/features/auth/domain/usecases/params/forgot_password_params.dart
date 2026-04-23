class ForgotPasswordParams {
  final String email;

  const ForgotPasswordParams({required this.email});

  Map<String, dynamic> toJson() => {
        'email': email,
      };

  ForgotPasswordParams copyWith({String? email}) {
    return ForgotPasswordParams(email: email ?? this.email);
  }
}
