import 'package:dating_app/features/payment/model/order_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:dio/dio.dart';

class PaymentService {
  final Dio _dio;
  late Razorpay _razorpay;

  Function(PaymentSuccessResponse)? onPaymentSuccess;
  Function(PaymentFailureResponse)? onPaymentError;

  PaymentService(this._dio) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
  }

  Future<RazorpayOrderModel> createOrder(String packageId) async {
    final response = await _dio.post(
      'user/payment/create-order',
      data: {"packageId": packageId},
    );
    return RazorpayOrderModel.fromJson(response.data['order']);
  }

  Future<RazorpayOrderModel> createOrderForPromotion(String promotionId) async {
    final response = await _dio.post(
      'user/payment/create-order',
      data: {"packageId": promotionId, "type": "promo"},
    );
    return RazorpayOrderModel.fromJson(response.data['order']);
  }

  Future<RazorpayOrderModel> createOrderWithPayload(
    Map<String, dynamic> payload,
  ) async {
    final response = await _dio.post(
      'user/payment/create-order',
      data: payload,
    );
    return RazorpayOrderModel.fromJson(response.data['order']);
  }

  void openCheckout(RazorpayOrderModel order, String description) {
    var options = {
      'key': order.razorpayKeyId,
      'amount': order.amount,
      'name': 'Fathima Fidha',
      'order_id': order.orderId,
      'description': description,
      'currency': order.currency,
    };
    _razorpay.open(options);
  }

  Future<bool> verifyPayment(PaymentSuccessResponse response) async {
    final result = await _dio.post(
      'user/payment/verify',
      data: {
        "razorpay_order_id": response.orderId,
        "razorpay_payment_id": response.paymentId,
        "razorpay_signature": response.signature,
      },
    );
    return result.data['success'] == true;
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    _razorpay.clear();
    onPaymentSuccess?.call(response);
  }

  void _handleError(PaymentFailureResponse response) =>
      onPaymentError?.call(response);

  void dispose() => _razorpay.clear();
}
