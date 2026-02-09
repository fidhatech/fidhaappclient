part of 'onboarding_bloc.dart';

enum OnboardingStatus {
  initial,
  loading,
  moreDetailsRequired,
  success,
  failure,
  onDioError,
}

class OnboardingState {
  final String? name;
  final String? dob;
  final String? gender;
  final String? avatar;
  final String? phone;
  final String? audioPath;
  final String? about;
  final String? language;
  final String? age;
  final List<String> interest;
  final OnboardingStatus status;

  OnboardingState({
    this.name,
    this.dob,
    this.gender,
    this.avatar,
    this.phone,
    this.audioPath,
    this.about,
    this.language,
    this.interest = const [],
    this.age,
    this.status = OnboardingStatus.initial,
  });

  OnboardingState copyWith({
    String? name,
    String? dob,
    String? gender,
    String? avatar,
    String? phone,
    String? age,
    String? audioPath,
    String? about,
    String? language,
    List<String>? interest,
    OnboardingStatus? status,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      audioPath: audioPath ?? this.audioPath,
      about: about ?? this.about,
      language: language ?? this.language,
      interest: interest ?? this.interest,
      status: status ?? this.status,
    );
  }
}
