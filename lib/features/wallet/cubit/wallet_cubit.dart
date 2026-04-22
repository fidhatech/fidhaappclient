import 'package:bloc/bloc.dart';
import 'package:dating_app/features/payment/service/payment_service.dart';
import 'package:dating_app/features/user/cubit/user_cubit.dart';

import 'package:dating_app/features/wallet/service/wallet_service.dart';
import 'package:dating_app/features/wallet/wallet.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletService _service;
  final PaymentService _paymentService;
  final UserCubit userCubit;

  WalletCubit(this._service, this._paymentService, this.userCubit)
    : super(WalletInitial()) {
    _paymentService.onPaymentSuccess = (response) {
      verifyPayment(response);
    };

    _paymentService.onPaymentError = (failure) {
      emit(WalletError("Payment Failed: ${failure.message}"));
    };
  }

  Future<void> loadWalletData() async {
    emit(WalletLoading());
    try {
      final packages = await _service.getCoinPackages();
      final balance = await _service.getWalletBalance();
      userCubit.syncCoins(balance.coins);
      emit(WalletLoaded(packages: packages, balance: balance));
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> refreshBalance() async {
    loadWalletData();
    // if (state is WalletLoaded) {
    //   try {
    //     final balance = await _service.getWalletBalance();
    //     final currentState = state as WalletLoaded;
    //     emit(currentState.copyWith(balance: balance));
    //   } catch (e) {
    //
    //   }
    // }
  }

  Future<void> startPayment(CoinPackage package) async {
    try {
      final order = await _paymentService.createOrder(package.id);
      _paymentService.openCheckout(order, "Buying ${package.coins} coins");
    } catch (e) {
      emit(WalletError("Failed to create order: $e"));
    }
  }

  Future<void> verifyPayment(PaymentSuccessResponse response) async {
    emit(WalletLoading());
    try {
      final isVerified = await _paymentService.verifyPayment(response);
      if (isVerified) {
        final packages = await _service.getCoinPackages();
        final balance = await _service.getWalletBalance();
        userCubit.syncCoins(balance.coins);
        emit(WalletPaymentSuccess(packages: packages, balance: balance));
      } else {
        emit(
          WalletError("Payment verification failed. Please contact support."),
        );
      }
    } catch (e) {
      emit(WalletError("Error verifying payment: $e"));
    }
  }

  @override
  Future<void> close() {
    _paymentService.dispose();
    return super.close();
  }
}
