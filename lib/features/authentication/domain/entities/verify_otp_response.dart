class VerifyOtpResponse {
  final String message;
  final bool isExistingUser;
  final String accessToken;
  final String refreshToken;
  final String? userStage;

  const VerifyOtpResponse({
    required this.message,
    required this.isExistingUser,
    required this.accessToken,
    required this.refreshToken,
    required this.userStage,
  });
}
