import 'package:equatable/equatable.dart';

/// Base onboarding state
/// Represents ONLY the current onboarding phase
abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingNameState extends OnboardingState {
  final bool isValid;

  const OnboardingNameState({this.isValid = false});

  @override
  List<Object?> get props => [isValid];
}

class OnboardingGenderAvatarState extends OnboardingState {
  final bool isValid;

  const OnboardingGenderAvatarState({this.isValid = false});

  @override
  List<Object?> get props => [isValid];
}

/// 3️⃣ DOB screen
class OnboardingDobState extends OnboardingState {
  final bool isValid;

  const OnboardingDobState({this.isValid = false});

  @override
  List<Object?> get props => [isValid];
}

class OnboardingSubmittingState extends OnboardingState {
  const OnboardingSubmittingState();
}

/// 5️⃣ Onboarding completed successfully
class OnboardingCompletedState extends OnboardingState {
  const OnboardingCompletedState();
}

/// 6️⃣ Onboarding failed
class OnboardingErrorState extends OnboardingState {
  final String message;

  const OnboardingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
