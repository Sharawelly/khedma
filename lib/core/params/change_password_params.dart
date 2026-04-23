import 'package:equatable/equatable.dart';

class ChangePasswordParams extends Equatable{
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    };
  }
  
  @override
  List<Object?> get props => [currentPassword, newPassword, newPasswordConfirmation];
}