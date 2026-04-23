class OtpEntity {
  final int? passwordResetId;
  final int? pendingUserId;
  final String? otp;

  const OtpEntity({this.passwordResetId, this.pendingUserId, this.otp});
}
