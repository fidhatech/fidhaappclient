import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/features/employee/profile/earning/models/bank_account_model.dart';
import 'package:dating_app/features/employee/profile/earning/models/kyc_status_model.dart';
import 'package:dating_app/features/employee/profile/earning/models/withdrawal_model.dart';
import 'package:dating_app/features/employee/profile/earning/service/bank_service.dart';
import 'package:dating_app/features/employee/profile/earning/service/kyc_service.dart';
import 'package:dating_app/features/employee/profile/earning/service/withdrawal_service.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'earning_state.dart';

class EarningCubit extends Cubit<EarningState> {
  final KycService _kycService;
  final BankService _bankService;
  final WithdrawalService _withdrawalService;
  static const String _tag = '[EMPLOYEE_EARNING] EarningCubit';

  EarningCubit({
    required KycService kycService,
    required BankService bankService,
    required WithdrawalService withdrawalService,
  }) : _kycService = kycService,
       _bankService = bankService,
       _withdrawalService = withdrawalService,
       super(EarningInitial());

  /// Load earning data + KYC status + Bank Details
  Future<void> loadEarningData() async {
    emit(EarningLoading());
    try {
      log('$_tag Loading earning data, KYC status, and Bank details...');

      // Parallel fetch for efficiency
      final results = await Future.wait([
        _kycService.fetchEarningData(),
        _kycService.checkKycStatus(),
        _bankService.getBankDetails(),
        _withdrawalService.fetchWithdrawalHistory(),
      ]);

      final earningResponse = results[0] as Map<String, dynamic>;
      final kycStatus = results[1] as EmployeeKycStatusModel;
      final bankAccount = results[2] as BankAccountModel;
      final withdrawalHistory = results[3] as List<WithdrawalHistoryItem>;

      final earnings = earningResponse['earnings'] as Map<String, dynamic>?;
      final double balance =
          (earnings?['availableBalance'] ??
                  earnings?['balance'] ??
                  earnings?['totalEarning'] ??
                  0)
              .toDouble();

      emit(
        EarningLoaded(
          currentBalance: balance,
          kycStatus: kycStatus,
          bankAccount: bankAccount,
          withdrawalHistory: withdrawalHistory,
        ),
      );

      log('$_tag Data loaded successfully. Balance: $balance');
    } catch (e) {
      log('$_tag Error loading data: $e');
      emit(EarningError(e.toString()));
    }
  }

  Future<void> requestWithdrawal(int amount) async {
    final currentState = state;
    if (currentState is! EarningLoaded) {
      throw Exception('Unable to request withdrawal right now.');
    }

    emit(
      currentState.copyWith(
        isRequestingWithdrawal: true,
        resetWithdrawalError: true,
      ),
    );

    try {
      await _withdrawalService.requestWithdrawal(amount: amount);

      final results = await Future.wait([
        _kycService.fetchEarningData(),
        _withdrawalService.fetchWithdrawalHistory(),
      ]);

      final earningResponse = results[0] as Map<String, dynamic>;
      final updatedHistory = results[1] as List<WithdrawalHistoryItem>;
      final earnings = earningResponse['earnings'] as Map<String, dynamic>?;
      final double updatedBalance =
          (earnings?['availableBalance'] ??
                  earnings?['balance'] ??
                  earnings?['totalEarning'] ??
                  0)
              .toDouble();

      emit(
        currentState.copyWith(
          currentBalance: updatedBalance,
          withdrawalHistory: updatedHistory,
          isRequestingWithdrawal: false,
          resetWithdrawalError: true,
        ),
      );
    } catch (e) {
      final message = _extractErrorMessage(e);
      emit(
        currentState.copyWith(
          isRequestingWithdrawal: false,
          withdrawalError: message,
        ),
      );
      throw Exception(message);
    }
  }

  String _extractErrorMessage(Object error) {
    if (error is DioException) {
      final responseMessage = error.response?.data is Map<String, dynamic>
          ? (error.response?.data['message'] as String?)
          : null;
      return responseMessage ??
          error.message ??
          'Withdrawal failed. Please try again.';
    }

    final value = error.toString();
    if (value.startsWith('Exception: ')) {
      return value.replaceFirst('Exception: ', '');
    }
    return value;
  }

  /// Initiate KYC verification
  /// Ready for API integration
  Future<void> initiateKycVerification() async {
    try {
      // TODO: Implement KYC initiation API call
      // await _kycService.initiateKyc();
      log('KYC verification initiated');

      // Reload data after initiation
      await loadEarningData();
    } catch (e) {
      log('Error initiating KYC: $e');
      emit(EarningError(e.toString()));
    }
  }
}
