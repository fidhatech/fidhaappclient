class User {
  final String phone;
  final String name;
  final String gender;
  final DateTime dob;
  final String avatar;

  User({
    required this.phone,
    required this.name,
    required this.gender,
    required this.dob,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phone: json['phone'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String,
      dob: DateTime.parse(json['dob'] as String),
      avatar: json['avatar'] as String,
    );
  }
}
