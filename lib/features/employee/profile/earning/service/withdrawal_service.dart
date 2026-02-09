import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dating_app/features/employee/constants/employee_constants.dart';
import 'package:dating_app/features/employee/profile/earning/models/withdrawal_model.dart';

class WithdrawalService {
  final Dio _dio;
  static const String _tag =
      '[${EmployeeConstants.featureName}] WithdrawalService';

  WithdrawalService(this._dio);

  /// Requests a withdrawal for the specified [amount].
  /// This is currently implemented but should NOT be called automatically.
  Future<WithdrawalRequestResponse> requestWithdrawal({
    required int amount,
  }) async {
    try {
      log('$_tag Requesting withdrawal: $amount');
      final response = await _dio.post(
        EmployeeConstants.endpointWithdrawalRequest,
        data: {'amount': amount},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('$_tag Withdrawal requested successfully');
        return WithdrawalRequestResponse.fromJson(response.data);
      } else {
        log('$_tag Request failed: ${response.statusCode}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to request withdrawal',
        );
      }
    } catch (e) {
      log('$_tag Error requesting withdrawal: $e');
      rethrow;
    }
  }

  /// Fetches the withdrawal history.
  Future<List<WithdrawalHistoryItem>> fetchWithdrawalHistory() async {
    try {
      log('$_tag Fetching withdrawal history...');
      final response = await _dio.get(
        EmployeeConstants.endpointWithdrawalHistory,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        log('$_tag Fetched ${data.length} history items');
        return data.map((e) => WithdrawalHistoryItem.fromJson(e)).toList();
      } else {
        log('$_tag Fetch history failed: ${response.statusCode}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to fetch withdrawal history',
        );
      }
    } catch (e) {
      log('$_tag Error fetching history: $e');
      // Return empty list instead of throwing to avoid breaking UI on history failure?
      // No, let's rethrow to allow UI to show error / retry.
      rethrow;
    }
  }
}
