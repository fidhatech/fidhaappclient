import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String userId;
  final String name;
  final int coins;
  final String avatar;
  final String? dob;
  final String? gender;

  const UserModel({
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

  UserModel copyWith({
    String? userId,
    String? name,
    int? coins,
    String? avatar,
    String? dob,
    String? gender,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      coins: coins ?? this.coins,
      avatar: avatar ?? this.avatar,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }

  @override
  String toString() {
    return "UserModel(userId: $userId, name: $name, dob: $dob, gender: $gender)";
  }

  @override
  List<Object?> get props => [userId, name, coins, avatar, dob, gender];
}
