import 'package:dating_app/features/user/models/employee_model.dart';
import 'package:equatable/equatable.dart';

class PremiumEmployeesResponse extends Equatable {
  final List<EmployeeModel> employees;
  final int total;

  final bool hasMore;

  const PremiumEmployeesResponse({
    required this.employees,
    required this.total,

    required this.hasMore,
  });

  factory PremiumEmployeesResponse.fromJson(Map<String, dynamic> json) {
    return PremiumEmployeesResponse(
      employees:
          (json['employees'] as List<dynamic>?)
              ?.map((e) => EmployeeModel.fromJson(e))
              .toList() ??
          [],
      total: json['total'],

      hasMore: json['hasMore'],
    );
  }
  PremiumEmployeesResponse copyWith({
    List<EmployeeModel>? employees,
    int? total,
    bool? hasMore,
  }) {
    return PremiumEmployeesResponse(
      employees: employees ?? this.employees,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object> get props => [employees];
}
