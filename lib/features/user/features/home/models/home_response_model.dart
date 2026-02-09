import 'package:equatable/equatable.dart';

import '../../../models/employee_model.dart';

class HomeResponseModel extends Equatable {
  final List<EmployeeModel> employees;
  final bool hasMore;

  const HomeResponseModel({required this.hasMore, required this.employees});

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeResponseModel(
      hasMore: json["hasMore"],
      employees: (json['employees'] as List? ?? [])
          .map((e) => EmployeeModel.fromJson(e))
          .toList(),
    );
  }
  @override
  String toString() {
    return "HomeResponseModel(hasMore: $hasMore, employees: $employees)";
  }

  @override
  List<Object> get props => [employees];
}
