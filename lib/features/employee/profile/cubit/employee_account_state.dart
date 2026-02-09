part of 'employee_account_cubit.dart';

abstract class EmployeeAccountState extends Equatable {
  const EmployeeAccountState();

  @override
  List<Object> get props => [];
}

class EmployeeAccountInitial extends EmployeeAccountState {}

class EmployeeAccountLoading extends EmployeeAccountState {}

class EmployeeAccountLoaded extends EmployeeAccountState {
  final String name;
  final String? avatarUrl;

  const EmployeeAccountLoaded({required this.name, this.avatarUrl});

  @override
  List<Object> get props => [name, if (avatarUrl != null) avatarUrl!];
}

class EmployeeAccountError extends EmployeeAccountState {
  final String message;

  const EmployeeAccountError(this.message);

  @override
  List<Object> get props => [message];
}

class LogoutLoading extends EmployeeAccountState {}

class LogoutSuccess extends EmployeeAccountState {}

class LogoutFailure extends EmployeeAccountState {
  final String error;
  const LogoutFailure(this.error);
  @override
  List<Object> get props => [error];
}

class DeleteAccountLoading extends EmployeeAccountState {}

class DeleteAccountSuccess extends EmployeeAccountState {}

class DeleteAccountFailure extends EmployeeAccountState {
  final String error;
  const DeleteAccountFailure(this.error);
  @override
  List<Object> get props => [error];
}
