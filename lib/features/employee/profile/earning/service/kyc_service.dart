import 'dart:developer';

import 'package:dating_app/features/employee/profile/earning/models/kyc_status_model.dart';
import 'package:dio/dio.dart';

class KycService {
  final Dio _dio;

  KycService(this._dio);

  /// Verify PAN card number (OPTIONAL - only call if PAN is provided)
  /// Endpoint: POST /api/employee/kyc/pan
  Future<Map<String, dynamic>> verifyPan(String panNumber) async {
    try {
      log("Verifying PAN: $panNumber");

      final response = await _dio.post(
        "/employee/kyc/pan",
        data: {"panNumber": panNumber},
      );

      if (response.statusCode == 200) {
        log("PAN verification response: ${response.data}");
        return response.data["data"];
      } else {
        log(
          "Error verifying PAN: ${response.statusCode} ${response.statusMessage}",
        );
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to verify PAN",
        );
      }
    } on DioException catch (e) {
      log("DioException in verifyPan: ${e.toString()}");
      rethrow;
    } catch (e) {
      log("Unexpected error in verifyPan: ${e.toString()}");
      rethrow;
    }
  }

  /// Submit UPI for KYC completion (MANDATORY)
  /// Endpoint: POST /api/employee/kyc/upi
  Future<Map<String, dynamic>> submitUpiKyc(String upiId) async {
    try {
      log("Submitting UPI KYC: $upiId");

      final response = await _dio.post(
        "/employee/kyc/upi",
        data: {"upiId": upiId},
      );

      if (response.statusCode == 200) {
        log("UPI KYC submission response: ${response.data}");
        return response.data["data"];
      } else {
        log(
          "Error submitting UPI KYC: ${response.statusCode} ${response.statusMessage}",
        );
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to submit UPI KYC",
        );
      }
    } on DioException catch (e) {
      log("DioException in submitUpiKyc: ${e.toString()}");
      rethrow;
    } catch (e) {
      log("Unexpected error in submitUpiKyc: ${e.toString()}");
      rethrow;
    }
  }

  /// Fetch earning data including balance and KYC status
  Future<Map<String, dynamic>> fetchEarningData() async {
    try {
      final response = await _dio.get("employee/earnings");

      if (response.statusCode == 200) {
        log("[EMPLOYEE_EARNINGS] Data fetched: ${response.data}");
        return response.data;
      } else {
        log(
          "Error fetching earning data: ${response.statusCode} ${response.statusMessage}",
        );
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to fetch earning data",
        );
      }
    } on DioException catch (e) {
      log("DioException in fetchEarningData: ${e.toString()}");
      rethrow;
    } catch (e) {
      log("Unexpected error in fetchEarningData: ${e.toString()}");
      rethrow;
    }
  }

  /// Check KYC status
  Future<EmployeeKycStatusModel> checkKycStatus() async {
    try {
      log("[EMPLOYEE_KYC] Fetching KYC status...");
      final response = await _dio.get("employee/kyc/status");

      if (response.statusCode == 200) {
        log("[EMPLOYEE_KYC] Status fetched: ${response.data}");
        final data = response.data['data'] as Map<String, dynamic>;
        return EmployeeKycStatusModel.fromJson(data);
      } else {
        log(
          "[EMPLOYEE_KYC] Error fetching status: ${response.statusCode} ${response.statusMessage}",
        );
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to check KYC status",
        );
      }
    } on DioException catch (e) {
      log("[EMPLOYEE_KYC] DioException in checkKycStatus: ${e.message}");
      rethrow;
    } catch (e) {
      log("[EMPLOYEE_KYC] Unexpected error in checkKycStatus: ${e.toString()}");
      rethrow;
    }
  }
}
