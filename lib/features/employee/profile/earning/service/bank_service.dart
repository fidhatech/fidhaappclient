import 'dart:developer';

import 'package:dating_app/features/employee/profile/earning/models/bank_account_model.dart';
import 'package:dio/dio.dart';

class BankService {
  final Dio _dio;
  static const String _tag = '[EMPLOYEE_BANK]';

  BankService(this._dio);

  /// Fetch bank details
  /// Endpoint: GET /api/employee/bank-details
  Future<BankAccountModel> getBankDetails() async {
    try {
      log("$_tag Fetching bank details...");

      // TODO: Replace with actual endpoint when available
      // Simulating API call for now or use actual if exists
      /*
      final response = await _dio.get("/employee/bank-details");

      if (response.statusCode == 200) {
        log("$_tag Data fetched: ${response.data}");
        final data = response.data['data'] as Map<String, dynamic>;
        return BankAccountModel.fromJson(data);
      } else {
        log("$_tag Error fetching details: ${response.statusCode}");
        return BankAccountModel.empty();
      }
      */

      // Returning empty model for now as endpoint might not exist
      return BankAccountModel.empty();
    } on DioException catch (e) {
      log("$_tag DioException in getBankDetails: ${e.message}");
      // throw e; // Optionally rethrow or return empty
      return BankAccountModel.empty();
    } catch (e) {
      log("$_tag Unexpected error in getBankDetails: ${e.toString()}");
      return BankAccountModel.empty();
    }
  }

  /// Submit bank details
  /// Endpoint: POST /api/employee/bank-details
  Future<void> submitBankDetails({
    required String accountHolderName,
    required String bankName,
    required String accountNumber,
    required String ifscCode,
  }) async {
    try {
      log("$_tag Submitting bank details: $accountHolderName, $bankName");

      final data = {
        "accountHolderName": accountHolderName,
        "bankName": bankName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
      };

      final response = await _dio.post("/employee/bank-details", data: data);

      if (response.statusCode == 200) {
        log("$_tag details submitted successfully: ${response.data}");
      } else {
        log(
          "$_tag Error submitting details: ${response.statusCode} ${response.statusMessage}",
        );
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to submit bank details",
        );
      }
    } on DioException catch (e) {
      log("$_tag DioException in submitBankDetails: ${e.toString()}");
      rethrow;
    } catch (e) {
      log("$_tag Unexpected error in submitBankDetails: ${e.toString()}");
      rethrow;
    }
  }
}
