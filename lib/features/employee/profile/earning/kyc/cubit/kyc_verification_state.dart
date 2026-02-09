part of 'kyc_verification_cubit.dart';

abstract class KycVerificationState extends Equatable {
  const KycVerificationState();

  @override
  List<Object?> get props => [];
}

class KycVerificationInitial extends KycVerificationState {}

class KycVerificationLoading extends KycVerificationState {}

class PanVerifying extends KycVerificationState {}

class PanVerified extends KycVerificationState {
  final String holderName;
  final bool panVerified;

  const PanVerified({required this.holderName, required this.panVerified});

  @override
  List<Object?> get props => [holderName, panVerified];
}

class KycCompleted extends KycVerificationState {
  final bool kycCompleted;
  final String message;

  const KycCompleted({required this.kycCompleted, required this.message});

  @override
  List<Object?> get props => [kycCompleted, message];
}

class KycVerificationError extends KycVerificationState {
  final String message;

  const KycVerificationError(this.message);

  @override
  List<Object?> get props => [message];
}
