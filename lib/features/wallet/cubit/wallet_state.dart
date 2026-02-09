import 'package:dating_app/features/wallet/wallet.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final List<CoinPackage> packages;
  final WalletBalance? balance;

  WalletLoaded({required this.packages, this.balance});

  WalletLoaded copyWith({List<CoinPackage>? packages, WalletBalance? balance}) {
    return WalletLoaded(
      packages: packages ?? this.packages,
      balance: balance ?? this.balance,
    );
  }
}

class WalletError extends WalletState {
  final String message;

  WalletError(this.message);
}
