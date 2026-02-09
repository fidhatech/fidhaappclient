import 'package:dating_app/features/wallet/wallet.dart';
import 'package:dio/dio.dart';

class WalletService {
  final Dio _dio;

  WalletService(this._dio);

  Future<List<CoinPackage>> getCoinPackages() async {
    try {
      final response = await _dio.get('user/wallet/packages');
      final data = response.data;
      if (data != null && data['packages'] != null) {
        return (data['packages'] as List)
            .map((e) => CoinPackage.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<WalletBalance> getWalletBalance() async {
    try {
      final response = await _dio.get('user/home');
      final data = response.data;
      if (data != null && data['user'] != null) {
        final coins = data['user']['coins'] ?? 0;
        return WalletBalance(coins: coins, message: "Fetched from home");
      }
      return WalletBalance(coins: 0, message: "Failed to fetch balance");
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createRazorpayOrder(String packageId) async {
    try {
      final response = await _dio.post(
        'user/payment/create-order',
        data: {"packageId": packageId},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final response = await _dio.post(
        'user/payment/verify',
        data: {
          "razorpay_order_id": orderId,
          "razorpay_payment_id": paymentId,
          "razorpay_signature": signature,
        },
      );
      return response.data['success'] ?? false;
    } catch (e) {
      rethrow;
    }
  }
}
