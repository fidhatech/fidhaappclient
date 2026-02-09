class VerifyOtpResponse {
  final String message;
  final bool isExistingUser;
  final String accessToken;
  final String refreshToken;
  final String? userStage;

  VerifyOtpResponse({
    required this.message,
    required this.isExistingUser,
    required this.accessToken,
    required this.refreshToken,
    this.userStage,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      message: json['message'],
      isExistingUser: json['isExistingUser'],
      accessToken: json['tokens']['accessToken'],
      refreshToken: json['tokens']['refreshToken'],
      userStage: json['userStage'],
    );
  }
}
