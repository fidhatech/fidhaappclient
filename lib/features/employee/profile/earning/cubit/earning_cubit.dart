import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/features/employee/profile/earning/models/kyc_status_model.dart';
import 'package:dating_app/features/employee/profile/earning/service/kyc_service.dart';
import 'package:equatable/equatable.dart';

part 'earning_state.dart';

class EarningCubit extends Cubit<EarningState> {
  final KycService _kycService;
  static const String _tag = '[EMPLOYEE_KYC] EarningCubit';

  EarningCubit({required KycService kycService})
    : _kycService = kycService,
      super(EarningInitial());

  /// Load earning data + KYC status
  Future<void> loadEarningData() async {
    emit(EarningLoading());
    try {
      log('$_tag Loading earning data and KYC status...');

      // Parallel fetch for efficiency
      final results = await Future.wait([
        _kycService.fetchEarningData(),
        _kycService.checkKycStatus(),
      ]);

      final earningResponse = results[0] as Map<String, dynamic>;
      final kycStatus = results[1] as EmployeeKycStatusModel;

      final earnings = earningResponse['earnings'] as Map<String, dynamic>?;
      final double balance = (earnings?['totalEarning'] ?? 0).toDouble();

      emit(EarningLoaded(currentBalance: balance, kycStatus: kycStatus));

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
