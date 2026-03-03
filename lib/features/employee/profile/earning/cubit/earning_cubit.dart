import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/features/employee/profile/earning/models/bank_account_model.dart';
import 'package:dating_app/features/employee/profile/earning/models/kyc_status_model.dart';
import 'package:dating_app/features/employee/profile/earning/service/bank_service.dart';
import 'package:dating_app/features/employee/profile/earning/service/kyc_service.dart';
import 'package:equatable/equatable.dart';

part 'earning_state.dart';

class EarningCubit extends Cubit<EarningState> {
  final KycService _kycService;
  final BankService _bankService;
  static const String _tag = '[EMPLOYEE_EARNING] EarningCubit';

  EarningCubit({
    required KycService kycService,
    required BankService bankService,
  }) : _kycService = kycService,
       _bankService = bankService,
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
      ]);

      final earningResponse = results[0] as Map<String, dynamic>;
      final kycStatus = results[1] as EmployeeKycStatusModel;
      final bankAccount = results[2] as BankAccountModel;

      final earnings = earningResponse['earnings'] as Map<String, dynamic>?;
      final double balance = (earnings?['totalEarning'] ?? 0).toDouble();

      emit(
        EarningLoaded(
          currentBalance: balance,
          kycStatus: kycStatus,
          bankAccount: bankAccount,
        ),
      );

      log('$_tag Data loaded successfully. Balance: $balance');
    } catch (e) {
      log('$_tag Error loading data: $e');
      emit(EarningError(e.toString()));
    }
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
