import 'package:dating_app/core/network/http/dio_client.dart';
import 'package:dating_app/features/user/models/employee_model.dart';
import 'package:dio/dio.dart';

class UserDetailsRepository {
  final Dio _dio = DioClient.instance;

  Future<EmployeeModel> getEmployeeDetails(String empId) async {
    try {
      final response = await _dio.get('user/discover/prime-employees/$empId');

      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data['empId'] == null) {
          data['empId'] = empId;
        }
        return EmployeeModel.fromJson(data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load details');
      }
    } catch (e) {
      throw Exception('Failed to fetch employee details: $e');
    }
  }
}
