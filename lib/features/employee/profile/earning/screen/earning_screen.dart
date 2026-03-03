import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/di/injection.dart';
import 'package:dating_app/features/employee/profile/earning/cubit/earning_cubit.dart';
import 'package:dating_app/features/employee/profile/earning/kyc/screen/kyc_verification_screen.dart';
import 'package:dating_app/features/employee/profile/earning/models/kyc_status_model.dart';
import 'package:dating_app/features/employee/profile/earning/service/bank_service.dart';
import 'package:dating_app/features/employee/profile/earning/service/kyc_service.dart';
import 'package:dating_app/features/employee/profile/earning/widgets/current_balance_card.dart';
import 'package:dating_app/features/employee/profile/earning/widgets/kyc_status_card.dart';
import 'package:dating_app/features/employee/profile/earning/models/bank_account_model.dart';
import 'package:dating_app/features/employee/profile/earning/screen/add_bank_account_screen.dart';
import 'package:dating_app/features/employee/profile/earning/widgets/bank_account_card.dart';
import 'package:dating_app/features/employee/profile/earning/widgets/withdraw_money_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EarningScreen extends StatelessWidget {
  const EarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EarningCubit(
        kycService: KycService(sl()),
        bankService: BankService(sl()),
      )..loadEarningData(),
      child: GradientScaffold(
        appBar: AppBar(
          title: const Text(
            'Earnings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<EarningCubit, EarningState>(
            builder: (context, state) {
              if (state is EarningLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (state is EarningError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading earnings',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context.read<EarningCubit>().loadEarningData();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Default to loaded state with initial values
              double balance = 0.0;
              EmployeeKycStatusModel kycStatus = EmployeeKycStatusModel.empty();

              if (state is EarningLoaded) {
                balance = state.currentBalance;
                kycStatus = state.kycStatus;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurrentBalanceCard(balance: balance),
                    const SizedBox(height: 20),
                    KycStatusCard(
                      kycStatus: kycStatus,
                      onVerifyTap: () async {
                        // Navigate to KYC verification screen
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KycVerificationScreen(),
                          ),
                        );
                        // Reload earning data after returning from KYC screen
                        if (context.mounted) {
                          context.read<EarningCubit>().loadEarningData();
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    BankAccountCard(
                      bankAccount: context
                          .select<EarningCubit, BankAccountModel>((cubit) {
                            final state = cubit.state;
                            if (state is EarningLoaded) {
                              return state.bankAccount;
                            }
                            return BankAccountModel.empty();
                          }),
                      onAddBankTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddBankAccountScreen(),
                          ),
                        );
                        if (context.mounted) {
                          context.read<EarningCubit>().loadEarningData();
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    WithdrawMoneyCard(availableBalance: balance),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
