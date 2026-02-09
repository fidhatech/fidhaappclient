part of 'earning_cubit.dart';

abstract class EarningState extends Equatable {
  const EarningState();

  @override
  List<Object?> get props => [];
}

class EarningInitial extends EarningState {}

class EarningLoading extends EarningState {}

class EarningLoaded extends EarningState {
  final double currentBalance;
  final EmployeeKycStatusModel kycStatus;

  const EarningLoaded({required this.currentBalance, required this.kycStatus});

  @override
  List<Object?> get props => [currentBalance, kycStatus];
}

class EarningError extends EarningState {
  final String message;

  const EarningError(this.message);

  @override
  List<Object?> get props => [message];
}
