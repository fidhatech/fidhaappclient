part of 'employee_cubit.dart';

sealed class EmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class EmployeeInitial extends EmployeeState {}

final class EmployeeLoading extends EmployeeState {}

final class EmployeeSuccess extends EmployeeState {
  final EmployeeModel employee;
  EmployeeSuccess({required this.employee});

  @override
  List<Object?> get props => [employee];
}

final class EmployeeFailure extends EmployeeState {
  final String message;
  EmployeeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

final class EmployeeOffline extends EmployeeState {}
