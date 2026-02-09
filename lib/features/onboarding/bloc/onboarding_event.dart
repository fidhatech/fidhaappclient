part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingEvent {}

class RoleChecked extends OnboardingEvent {}

class PhoneSubmitted extends OnboardingEvent {
  final String number;
  PhoneSubmitted(this.number);
}

class AuthVerificationProcessed extends OnboardingEvent {
  final bool isExistingUser;
  AuthVerificationProcessed({required this.isExistingUser});
}

class NameSubmitted extends OnboardingEvent {
  final String name;
  NameSubmitted(this.name);
}

class DobSubmitted extends OnboardingEvent {
  final DateTime dob;
  DobSubmitted(this.dob);
}

class GenderAvatarSubmitted extends OnboardingEvent {
  final String gender;
  final String avatar;
  GenderAvatarSubmitted({required this.gender, required this.avatar});
}

class FemaleExtraSubmitted extends OnboardingEvent {
  final String? about;
  final String? age;
  final List<String>? interest;
  final String? audioPath;
  final String? language;

  FemaleExtraSubmitted({
    this.about,
    this.age,
    this.interest,
    this.audioPath,
    this.language,
  });
}

class FemaleSubmit extends OnboardingEvent {
  final String audioPath;
  final String language;
  FemaleSubmit({required this.audioPath, required this.language});
}

class VerificationChecked extends OnboardingEvent {}

class PremiumEmployee extends OnboardingEvent {
  final List<String>? list;
  PremiumEmployee([this.list]);
}
