import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/features/employee/profile/earning/service/kyc_service.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'kyc_verification_state.dart';

class KycVerificationCubit extends Cubit<KycVerificationState> {
  final KycService _kycService;

  KycVerificationCubit({required KycService kycService})
    : _kycService = kycService,
      super(KycVerificationInitial());

  /// Extract user-friendly error message from DioException
  String _extractErrorMessage(dynamic error, String defaultMessage) {
    if (error is DioException) {
      // Try to extract error message from response data
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        // Check for error.message pattern
        if (responseData['error'] is Map<String, dynamic>) {
          final errorMessage = responseData['error']['message'];
          if (errorMessage is String && errorMessage.isNotEmpty) {
            return errorMessage;
          }
        }
        // Check for direct message field
        if (responseData['message'] is String) {
          return responseData['message'] as String;
        }
      }
    }
    return defaultMessage;
  }

  /// Verify PAN (optional - only called if PAN is provided)
  Future<bool> verifyPan(String panNumber) async {
    emit(PanVerifying());
    try {
      log("Starting PAN verification for: $panNumber");

      final response = await _kycService.verifyPan(panNumber);

      final holderName = response['holderName'] as String? ?? '';
      final panVerified = response['panVerified'] as bool? ?? false;

      if (panVerified) {
        log("PAN verified successfully. Holder: $holderName");
        emit(PanVerified(holderName: holderName, panVerified: panVerified));
        return true;
      } else {
        log("PAN verification failed");
        emit(
          const KycVerificationError(
            "Unable to verify PAN. Please check the details and try again.",
          ),
        );
        return false;
      }
    } catch (e) {
      log("Error verifying PAN: $e");
      final errorMessage = _extractErrorMessage(
        e,
        "Unable to verify PAN. Please check the details and try again.",
      );
      emit(KycVerificationError(errorMessage));
      return false;
    }
  }

  /// Submit KYC with UPI (mandatory)
  /// Conditionally verifies PAN first if provided
  Future<void> submitKyc({required String upiId, String? panNumber}) async {
    try {
      // Step 1: Verify PAN if provided (OPTIONAL)
      if (panNumber != null && panNumber.trim().isNotEmpty) {
        log("PAN provided, verifying first...");
        final panSuccess = await verifyPan(panNumber.trim());

        if (!panSuccess) {
          log("PAN verification failed, stopping KYC flow");
          return; // Stop if PAN verification fails
        }
      } else {
        log("No PAN provided, skipping PAN verification");
      }

      // Step 2: Submit UPI KYC (MANDATORY)
      emit(KycVerificationLoading());
      log("Submitting UPI KYC...");

      final response = await _kycService.submitUpiKyc(upiId);

      final kycCompleted = response['kycCompleted'] as bool? ?? false;
      final message =
          response['message'] as String? ??
          'KYC completed successfully. You can now request withdrawals.';

      if (kycCompleted) {
        log("KYC completed successfully");
        emit(KycCompleted(kycCompleted: kycCompleted, message: message));
      } else {
        log("KYC submission failed");
        emit(
          const KycVerificationError(
            "Unable to complete KYC. Please try again.",
          ),
        );
      }
    } catch (e) {
      log("Error submitting KYC: $e");
      final errorMessage = _extractErrorMessage(
        e,
        "Unable to complete KYC. Please try again.",
      );
      emit(KycVerificationError(errorMessage));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(KycVerificationInitial());
  }
}
