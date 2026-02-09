import 'package:equatable/equatable.dart';

abstract class EmployeeInfoState extends Equatable {
  const EmployeeInfoState();

  @override
  List<Object> get props => [];
}

class EmployeeInfoInitial extends EmployeeInfoState {}

class EmployeeInfoUpdated extends EmployeeInfoState {
  final List<String> selectedInterests;

  const EmployeeInfoUpdated({this.selectedInterests = const []});

  @override
  List<Object> get props => [selectedInterests];
}
