class UserModel {
  final String userId;
  final String name;
  final int coins;
  final String avatar;
  final String? dob;
  final String? gender;

  UserModel({
    required this.userId,
    required this.name,
    required this.coins,
    required this.avatar,
    this.dob,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      coins: json['coins'] ?? 0,
      avatar: json['avatar'] ?? '',
      dob: json['dob'],
      gender: json['gender'],
    );
  }
  @override
  String toString() {
    return "UserModel(userId: $userId, name: $name, dob: $dob, gender: $gender)";
  }
}
