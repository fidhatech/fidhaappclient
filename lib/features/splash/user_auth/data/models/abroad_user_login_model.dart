class AbroadUserLoginModel {
  final bool isExistingUser;
  final String accessToken;
  final String refreshToken;
  final String? userStage;

  const AbroadUserLoginModel({
    required this.isExistingUser,
    required this.accessToken,
    required this.refreshToken,
    this.userStage,
  });

  factory AbroadUserLoginModel.fromJson(Map<String, dynamic> json) {
    return AbroadUserLoginModel(
      isExistingUser: json['isExistingUser'],
      accessToken: json['tokens']['accessToken'],
      refreshToken: json['tokens']['refreshToken'],
      userStage: json['userStage'],
    );
  }
}