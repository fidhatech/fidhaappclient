part of 'earning_cubit.dart';

abstract class EarningState extends Equatable {
  const EarningState();

  @override
  List<Object?> get props => [];
}

class EarningInitial extends EarningState {}

class EarningLoading extends EarningState {}

class EarningLoaded extends EarningState {
  final double currentBalance;
  final EmployeeKycStatusModel kycStatus;
  final BankAccountModel bankAccount;
  final List<WithdrawalHistoryItem> withdrawalHistory;
  final bool isRequestingWithdrawal;
  final String? withdrawalError;

  const EarningLoaded({
    required this.currentBalance,
    required this.kycStatus,
    required this.bankAccount,
    this.withdrawalHistory = const [],
    this.isRequestingWithdrawal = false,
    this.withdrawalError,
  });

  EarningLoaded copyWith({
    double? currentBalance,
    EmployeeKycStatusModel? kycStatus,
    BankAccountModel? bankAccount,
    List<WithdrawalHistoryItem>? withdrawalHistory,
    bool? isRequestingWithdrawal,
    String? withdrawalError,
    bool resetWithdrawalError = false,
  }) {
    return EarningLoaded(
      currentBalance: currentBalance ?? this.currentBalance,
      kycStatus: kycStatus ?? this.kycStatus,
      bankAccount: bankAccount ?? this.bankAccount,
      withdrawalHistory: withdrawalHistory ?? this.withdrawalHistory,
      isRequestingWithdrawal:
          isRequestingWithdrawal ?? this.isRequestingWithdrawal,
      withdrawalError: resetWithdrawalError
          ? null
          : (withdrawalError ?? this.withdrawalError),
    );
  }

  @override
  List<Object?> get props => [
    currentBalance,
    kycStatus,
    bankAccount,
    withdrawalHistory,
    isRequestingWithdrawal,
    withdrawalError,
  ];
}

class EarningError extends EarningState {
  final String message;

  const EarningError(this.message);

  @override
  List<Object?> get props => [message];
}
