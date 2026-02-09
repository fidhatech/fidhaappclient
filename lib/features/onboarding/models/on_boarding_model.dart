abstract class OnboardingModel {
  final String name;
  final String gender;
  final String dob;
  final String phone;
  final String avatar;

  OnboardingModel({
    required this.name,
    required this.gender,
    required this.dob,
    required this.phone,
    required this.avatar,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    if (json['gender'] == 'male') {
      return MaleOnboarding.fromJson(json);
    } else {
      return FemaleOnboarding.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}

// --- Male Model ---
class MaleOnboarding extends OnboardingModel {
  MaleOnboarding({
    required super.name,
    required super.gender,
    required super.dob,
    required super.phone,
    required super.avatar,
  });

  factory MaleOnboarding.fromJson(Map<String, dynamic> json) {
    return MaleOnboarding(
      name: json['name'] ?? '',
      gender: json['gender'] ?? 'male',
      dob: json['dob'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'gender': gender,
    'dob': dob,
    'phone': phone,
    'avatar': avatar,
  };
}

// --- Female Model ---
class FemaleOnboarding extends OnboardingModel {
  final String age;
  final String audio;
  final String about;
  final String language;
  final List<String> interest;

  FemaleOnboarding({
    required super.name,
    required super.gender,
    required super.dob,
    required super.phone,
    required super.avatar,
    required this.age,
    required this.audio,
    required this.about,
    required this.language,
    required this.interest,
  });

  factory FemaleOnboarding.fromJson(Map<String, dynamic> json) {
    return FemaleOnboarding(
      age: json["age"],
      name: json['name'] ?? '',
      gender: json['gender'] ?? 'female',
      dob: json['dob'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
      audio: json['audio'] ?? '',
      about: json['about'] ?? '',
      language: json['language'] ?? '',
      interest: List<String>.from(json['interest'] ?? []),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'gender': gender,
    'dob': dob,
    'phone': phone,
    "age": age,
    'avatar': avatar,
    'audio': audio,
    'about': about,
    'language': language,
    'interest': interest,
  };
}
