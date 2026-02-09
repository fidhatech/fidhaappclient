import 'package:dating_app/features/user/models/employee_model.dart';

class HomeHelper {
  static ({List<EmployeeModel> premium, List<EmployeeModel> normal}) separate(
    List<EmployeeModel> employees,
  ) {
    return (
      premium: employees.where((e) => e.isPrime == true).toList(),
      normal: employees.where((e) => e.isPrime != true).toList(),
    );
  }
}
