import 'package:equatable/equatable.dart';
import '../../../../models/employee_model.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object> get props => [];
}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsError extends UserDetailsState {
  final String message;

  const UserDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

class UserDetailsLoaded extends UserDetailsState {
  final EmployeeModel employee;
  final int currentImageIndex;

  const UserDetailsLoaded({required this.employee, this.currentImageIndex = 0});

  UserDetailsLoaded copyWith({
    EmployeeModel? employee,
    int? currentImageIndex,
  }) {
    return UserDetailsLoaded(
      employee: employee ?? this.employee,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
    );
  }

  @override
  List<Object> get props => [employee, currentImageIndex];
}
