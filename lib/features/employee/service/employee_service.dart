import 'dart:developer';

import 'package:dating_app/features/employee/constants/employee_constants.dart';
import 'package:dating_app/features/employee/model/employee_model.dart';
import 'package:dio/dio.dart';

class EmployeeService {
  final Dio _dio;
  static const String _tag = '[${EmployeeConstants.featureName}] Service';

  EmployeeService(this._dio);

  Future<EmployeeModel> fetchFullEmployeeData() async {
    try {
      log('$_tag 🔄 Fetching full employee data (Home + Profile)...');

      // Parallel execution
      final results = await Future.wait([
        fetchEmployeeHomeData(),
        fetchEmployeeProfile(),
      ]);

      final homeData = results[0] as EmployeeModel;
      final profileData = results[1] as Map<String, dynamic>;

      // Merge Logic (Moved from Cubit)
      final userProfile = profileData.containsKey('user')
          ? profileData['user']
          : profileData;
      final earnings = profileData['earnings'] ?? {};

      final mergedEmployee = homeData.copyWith(
        name: userProfile['name'] ?? homeData.name,
        avatar:
            (userProfile['avatar'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            homeData.avatar,
        language:
            (userProfile['language'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            homeData.language,
        totalEarning:
            (earnings['totalEarning'] as num?)?.toDouble() ??
            homeData.totalEarning,
        todayEarning:
            (earnings['todayEarning'] as num?)?.toDouble() ??
            homeData.todayEarning,
        totalCalls:
            (profileData['totalCalls'] as num?)?.toInt() ?? homeData.totalCalls,
      );

      log('$_tag ✅ Full employee data merged successfully');
      return mergedEmployee;
    } catch (e) {
      log('$_tag ❌ Error fetching full data: $e');
      rethrow;
    }
  }

  Future<EmployeeModel> fetchEmployeeHomeData() async {
    try {
      log('$_tag Fetching home data...');
      final response = await _dio.get(EmployeeConstants.endpointHome);

      if (response.statusCode == 200) {
        log('$_tag Home data fetched successfully');
        return EmployeeModel.fromJson(response.data["data"]);
      } else {
        log(
          '$_tag ${EmployeeConstants.msgFetchHomeError}: ${response.statusCode}',
        );
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: EmployeeConstants.msgFetchHomeError,
        );
      }
    } on DioException catch (e) {
      log('$_tag DioException in fetchEmployeeHomeData: ${e.message}');
      rethrow;
    } catch (e) {
      log('$_tag Unexpected error in fetchEmployeeHomeData: $e');
      throw Exception('$_tag $e');
    }
  }

  Future<void> updateCallPreference({
    bool? isAudioEnabled,
    bool? isVideoEnabled,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (isAudioEnabled != null) data['isAudioEnabled'] = isAudioEnabled;
      if (isVideoEnabled != null) data['isVideoEnabled'] = isVideoEnabled;

      log('$_tag Updating call preference: $data');

      final response = await _dio.patch(
        EmployeeConstants.endpointCallPreference,
        data: data,
      );

      if (response.statusCode == 200) {
        log('$_tag Call preference updated successfully');
      } else {
        log(
          '$_tag ${EmployeeConstants.msgUpdatePrefError}: ${response.statusCode}',
        );
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: EmployeeConstants.msgUpdatePrefError,
        );
      }
    } on DioException catch (e) {
      log('$_tag DioException in updateCallPreference: ${e.message}');
      rethrow;
    } catch (e) {
      log('$_tag Unexpected error in updateCallPreference: $e');
      throw Exception('$_tag $e');
    }
  }

  Future<void> logout() async {
    try {
      log('$_tag Logging out...');
      await _dio.post(EmployeeConstants.endpointLogout);
      log('$_tag Logout successful');
    } catch (e) {
      log('$_tag Logout failed: $e');
      throw Exception('${EmployeeConstants.msgLogoutError}: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      log('$_tag Deleting account...');
      await _dio.delete(EmployeeConstants.endpointProfileDelete);
      log('$_tag Account deleted successfully');
    } catch (e) {
      log('$_tag Delete account failed: $e');
      throw Exception('${EmployeeConstants.msgDeleteError}: $e');
    }
  }

  Future<Map<String, dynamic>> fetchEmployeeProfile() async {
    try {
      log('$_tag Fetching profile...');
      final response = await _dio.get(EmployeeConstants.endpointProfile);

      if (response.statusCode == 200) {
        log('$_tag Profile fetched successfully');
        return response.data["data"];
      } else {
        log(
          '$_tag ${EmployeeConstants.msgFetchProfileError}: ${response.statusCode}',
        );
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: EmployeeConstants.msgFetchProfileError,
        );
      }
    } on DioException catch (e) {
      log('$_tag DioException in fetchEmployeeProfile: ${e.message}');
      rethrow;
    } catch (e) {
      log('$_tag Unexpected error in fetchEmployeeProfile: $e');
      throw Exception('$_tag $e');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      log('$_tag Updating profile: $data');
      final response = await _dio.patch(
        EmployeeConstants.endpointProfileUpdate,
        data: data,
      );

      if (response.statusCode == 200) {
        log('$_tag Profile updated successfully');
      } else {
        log(
          '$_tag ${EmployeeConstants.msgUpdateProfileError}: ${response.statusCode}',
        );
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: EmployeeConstants.msgUpdateProfileError,
        );
      }
    } on DioException catch (e) {
      log('$_tag DioException in updateProfile: ${e.message}');
      rethrow;
    } catch (e) {
      log('$_tag Unexpected error in updateProfile: $e');
      throw Exception('$_tag $e');
    }
  }
}
