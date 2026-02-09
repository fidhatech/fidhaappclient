import 'package:dating_app/features/user/models/employee_model.dart';

class StatusUpdateModel {
  final String employeeId;
  final String status;
  final EmployeeModel? employee;

  StatusUpdateModel({
    required this.employeeId,
    required this.status,
    this.employee,
  });

  factory StatusUpdateModel.fromJson(Map<String, dynamic> json) {
    return StatusUpdateModel(
      employeeId: json['employeeId'] as String,
      status: json['status'] as String,
      employee: json['employee'] != null
          ? EmployeeModel.fromJson(json['employee'])
          : null,
    );
  }
}
