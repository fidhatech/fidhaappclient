part of 'premium_bloc.dart';

sealed class PremiumState extends Equatable {
  const PremiumState();

  @override
  List<Object> get props => [];
}

final class PremiumInitial extends PremiumState {}

final class PremiumLoading extends PremiumState {}

final class PremiumLoaded extends PremiumState {
  final PremiumEmployeesResponse premiumEmployeesList;
  const PremiumLoaded(this.premiumEmployeesList);

  @override
  List<Object> get props => [premiumEmployeesList];
}

final class PremiumError extends PremiumState {
  final String message;
  const PremiumError(this.message);

  @override
  List<Object> get props => [message];
}
