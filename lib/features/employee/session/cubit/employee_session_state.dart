part of 'employee_session_cubit.dart';

abstract class EmployeeSessionState extends Equatable {
  const EmployeeSessionState();

  @override
  List<Object?> get props => [];
}

class EmployeeSessionInitial extends EmployeeSessionState {}

class EmployeeSessionLoading extends EmployeeSessionState {}

class EmployeeSessionLoaded extends EmployeeSessionState {
  final EmployeeModel employee;

  const EmployeeSessionLoaded({required this.employee});

  @override
  List<Object?> get props => [employee];

  EmployeeSessionLoaded copyWith({EmployeeModel? employee}) {
    return EmployeeSessionLoaded(employee: employee ?? this.employee);
  }
}

class EmployeeSessionError extends EmployeeSessionState {
  final String message;

  const EmployeeSessionError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Helper state for explicit offline handling
class EmployeeSessionOffline extends EmployeeSessionState {}
